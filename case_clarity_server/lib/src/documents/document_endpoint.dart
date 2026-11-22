import 'dart:async';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/case_document.dart';
import '../generated/document_ocr_status.dart';
import '../generated/document_upload_ticket.dart';
import '../generated/user_role.dart';
import '../services/authorization.dart';
import '../services/ocr_service.dart';

const maxDocumentSizeBytes = 5 * 1024 * 1024;
const _privateStorageId = 'private';

class DocumentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<DocumentUploadTicket> startUpload(
    Session session,
    int caseId,
    String fileName,
    String mimeType,
    int sizeBytes,
  ) async {
    final access = await Authorization.requireCaseAccess(session, caseId);
    if (access.profile.role != UserRole.citizen ||
        access.legalCase.creatorId != access.userId) {
      throw Exception(Authorization.caseUnavailableMessage);
    }
    final normalizedFileName = _validateUploadDetails(
      fileName,
      mimeType,
      sizeBytes,
    );

    var document = await CaseDocument.db.insertRow(
      session,
      CaseDocument(
        caseId: caseId,
        uploaderId: access.userId,
        fileName: normalizedFileName,
        mimeType: mimeType,
        sizeBytes: sizeBytes,
        storagePath: 'pending',
        ocrStatus: DocumentOcrStatus.pending,
      ),
    );
    final extension = normalizedFileName.split('.').last.toLowerCase();
    final storagePath = 'case-documents/$caseId/${document.id}.$extension';
    document = await CaseDocument.db.updateRow(
      session,
      document.copyWith(storagePath: storagePath),
    );

    try {
      final uploadDescription = await session.storage.createUploadDescription(
        storageId: _privateStorageId,
        path: storagePath,
        options: UploadOptions(
          maxFileSize: maxDocumentSizeBytes,
          contentLength: sizeBytes,
          preventOverwrite: true,
          metadata: FileMetadata(contentType: mimeType),
        ),
      );
      return DocumentUploadTicket(
        documentId: document.id!,
        uploadDescription: uploadDescription,
      );
    } catch (_) {
      await CaseDocument.db.deleteRow(session, document);
      throw StateError('Unable to start this document upload.');
    }
  }

  Future<CaseDocument> finishUpload(Session session, int documentId) async {
    final signedIn = await Authorization.getSignedInUserAndProfile(session);
    final document = await CaseDocument.db.findById(session, documentId);
    if (document == null) {
      throw Exception(Authorization.caseUnavailableMessage);
    }
    final access = await Authorization.requireCaseAccess(
      session,
      document.caseId,
    );
    if (access.profile.role != UserRole.citizen ||
        document.uploaderId != signedIn.userId ||
        access.legalCase.creatorId != signedIn.userId) {
      throw Exception(Authorization.caseUnavailableMessage);
    }
    if (document.ocrStatus != DocumentOcrStatus.pending) return document;
    final storagePath = document.storagePath;
    if (storagePath == null || storagePath.isEmpty) {
      throw StateError('Document storage path is missing.');
    }

    final verified = await session.storage.verifyUpload(
      storageId: _privateStorageId,
      path: storagePath,
    );
    if (!verified) throw StateError('The uploaded file is missing or incomplete.');

    final stat = await session.storage.statFile(
      storageId: _privateStorageId,
      path: storagePath,
    );
    if (stat.size != document.sizeBytes || stat.size > maxDocumentSizeBytes) {
      await _discardRejectedUpload(session, document);
      throw ArgumentError('The uploaded file size does not match its declaration.');
    }

    final bytes = await session.storage.retrieveFile(
      storageId: _privateStorageId,
      path: storagePath,
    );
    final actualMimeType = documentMimeTypeFromMagicBytes(bytes);
    if (actualMimeType == null || actualMimeType != document.mimeType) {
      await _discardRejectedUpload(session, document);
      throw ArgumentError(
        'File contents do not match the declared PDF, JPG, or PNG type.',
      );
    }

    final processing = await CaseDocument.db.updateRow(
      session,
      document.copyWith(
        ocrStatus: DocumentOcrStatus.processing,
        errorMessage: null,
      ),
    );
    unawaited(_processOcrInBackground(session.serverpod, documentId));
    return processing;
  }

  Future<List<CaseDocument>> listDocuments(Session session, int caseId) async {
    await Authorization.requireCaseAccess(session, caseId);
    return CaseDocument.db.find(
      session,
      where: (t) => t.caseId.equals(caseId),
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
  }

  Future<CaseDocument> getDocument(Session session, int id) async {
    final document = await CaseDocument.db.findById(session, id);
    if (document == null) {
      throw Exception(Authorization.caseUnavailableMessage);
    }
    await Authorization.requireCaseAccess(session, document.caseId);
    return document;
  }

  String _validateUploadDetails(String fileName, String mimeType, int sizeBytes) {
    final name = fileName.trim();
    if (name.isEmpty || name.length > 255 || name.contains('/') || name.contains('\\')) {
      throw ArgumentError('File name must be between 1 and 255 characters without a path.');
    }
    if (sizeBytes <= 0 || sizeBytes > maxDocumentSizeBytes) {
      throw ArgumentError('File size must be between 1 byte and 5 MiB.');
    }

    final extension = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    final expectedMimeType = switch (extension) {
      'pdf' => 'application/pdf',
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      _ => null,
    };
    if (expectedMimeType == null || mimeType.toLowerCase() != expectedMimeType) {
      throw ArgumentError('Only PDF, JPG, and PNG files are supported.');
    }
    return name;
  }

  Future<void> _discardRejectedUpload(
    Session session,
    CaseDocument document,
  ) async {
    try {
      final storagePath = document.storagePath;
      if (storagePath == null || storagePath.isEmpty) {
        throw StateError('Document storage path is missing.');
      }
      await session.storage.deleteFile(
        storageId: _privateStorageId,
        path: storagePath,
      );
    } catch (_) {
      // The file is private; do not expose storage-provider details to callers.
    }
    await CaseDocument.db.deleteRow(session, document);
  }
}

Future<void> _processOcrInBackground(Serverpod serverpod, int documentId) async {
  Session? backgroundSession;
  try {
    backgroundSession = await serverpod.createSession();
    await const OcrService(MockOcrProvider()).processDocument(
      backgroundSession,
      documentId,
    );
  } catch (_) {
    // OCR/provider details and document contents must never escape this task.
    if (backgroundSession == null) {
      try {
        backgroundSession = await serverpod.createSession();
      } catch (_) {
        // A session may be unavailable while the server is shutting down.
      }
    }
    if (backgroundSession != null) {
      try {
        final document = await CaseDocument.db.findById(
          backgroundSession,
          documentId,
        );
        if (document != null) {
          await CaseDocument.db.updateRow(
            backgroundSession,
            document.copyWith(
              ocrStatus: DocumentOcrStatus.failed,
              extractedText: null,
              candidateDates: null,
              errorMessage: 'OCR processing failed. Please try again later.',
            ),
          );
        }
      } catch (_) {
        // Background failures are contained; polling reports the last saved state.
      }
    }
  } finally {
    try {
      await backgroundSession?.close();
    } catch (_) {
      // Session cleanup errors must not escape the unawaited background task.
    }
  }
}

String? documentMimeTypeFromMagicBytes(ByteData bytes) {
  if (bytes.lengthInBytes >= 5 &&
      String.fromCharCodes(Uint8List.sublistView(bytes, 0, 5)) == '%PDF-') {
    return 'application/pdf';
  }
  if (bytes.lengthInBytes >= 3 &&
      bytes.getUint8(0) == 0xff &&
      bytes.getUint8(1) == 0xd8 &&
      bytes.getUint8(2) == 0xff) {
    return 'image/jpeg';
  }
  const pngSignature = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
  if (bytes.lengthInBytes >= pngSignature.length) {
    var matchesPng = true;
    for (var i = 0; i < pngSignature.length; i++) {
      if (bytes.getUint8(i) != pngSignature[i]) {
        matchesPng = false;
        break;
      }
    }
    if (matchesPng) return 'image/png';
  }
  return null;
}
