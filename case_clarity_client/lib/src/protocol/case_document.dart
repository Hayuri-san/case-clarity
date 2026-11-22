/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:case_clarity_client/src/protocol/protocol.dart' as _ism1ooo3;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'document_ocr_status.dart' as _igofstph;

abstract class CaseDocument
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CaseDocument._({
    this.id,
    required this.caseId,
    required this.uploaderId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    _igofstph.DocumentOcrStatus? ocrStatus,
    this.extractedText,
    this.candidateDates,
    this.errorMessage,
    DateTime? createdAt,
  }) : ocrStatus = ocrStatus ?? _igofstph.DocumentOcrStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory CaseDocument({
    int? id,
    required int caseId,
    required _isc.UuidValue uploaderId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    _igofstph.DocumentOcrStatus? ocrStatus,
    String? extractedText,
    List<String>? candidateDates,
    String? errorMessage,
    DateTime? createdAt,
  }) = _CaseDocumentImpl;

  factory CaseDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaseDocument(
      id: jsonSerialization['id'] as int?,
      caseId: jsonSerialization['caseId'] as int,
      uploaderId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['uploaderId'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      ocrStatus: jsonSerialization['ocrStatus'] == null
          ? null
          : _igofstph.DocumentOcrStatus.fromJson(
              (jsonSerialization['ocrStatus'] as String),
            ),
      extractedText: jsonSerialization['extractedText'] as String?,
      candidateDates: jsonSerialization['candidateDates'] == null
          ? null
          : _ism1ooo3.Protocol().deserialize<List<String>>(
              jsonSerialization['candidateDates'],
            ),
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int caseId;

  _isc.UuidValue uploaderId;

  String fileName;

  String mimeType;

  int sizeBytes;

  _igofstph.DocumentOcrStatus ocrStatus;

  String? extractedText;

  List<String>? candidateDates;

  String? errorMessage;

  DateTime createdAt;

  /// Returns a shallow copy of this [CaseDocument]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CaseDocument copyWith({
    int? id,
    int? caseId,
    _isc.UuidValue? uploaderId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    _igofstph.DocumentOcrStatus? ocrStatus,
    String? extractedText,
    List<String>? candidateDates = const _isc.$UndefinedList<String>(),
    String? errorMessage,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaseDocument',
      if (id != null) 'id': id,
      'caseId': caseId,
      'uploaderId': uploaderId.toJson(),
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'ocrStatus': ocrStatus.toJson(),
      if (extractedText != null) 'extractedText': extractedText,
      if (candidateDates != null) 'candidateDates': candidateDates?.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaseDocument',
      if (id != null) 'id': id,
      'caseId': caseId,
      'uploaderId': uploaderId.toJson(),
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'ocrStatus': ocrStatus.toJson(),
      if (extractedText != null) 'extractedText': extractedText,
      if (candidateDates != null) 'candidateDates': candidateDates?.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaseDocumentImpl extends CaseDocument {
  _CaseDocumentImpl({
    int? id,
    required int caseId,
    required _isc.UuidValue uploaderId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    _igofstph.DocumentOcrStatus? ocrStatus,
    String? extractedText,
    List<String>? candidateDates,
    String? errorMessage,
    DateTime? createdAt,
  }) : super._(
         id: id,
         caseId: caseId,
         uploaderId: uploaderId,
         fileName: fileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         ocrStatus: ocrStatus,
         extractedText: extractedText,
         candidateDates: candidateDates,
         errorMessage: errorMessage,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CaseDocument]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CaseDocument copyWith({
    Object? id = _Undefined,
    int? caseId,
    _isc.UuidValue? uploaderId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    _igofstph.DocumentOcrStatus? ocrStatus,
    Object? extractedText = _Undefined,
    List<String>? candidateDates = const _isc.$UndefinedList<String>(),
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
  }) {
    return CaseDocument(
      id: id is int? ? id : this.id,
      caseId: caseId ?? this.caseId,
      uploaderId: uploaderId ?? this.uploaderId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      ocrStatus: ocrStatus ?? this.ocrStatus,
      extractedText: extractedText is String?
          ? extractedText
          : this.extractedText,
      candidateDates: candidateDates is _isc.UndefinedSentinel
          ? this.candidateDates?.map((e0) => e0).toList()
          : candidateDates,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
