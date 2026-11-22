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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class DocumentUploadTicket
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DocumentUploadTicket._({
    required this.documentId,
    required this.uploadDescription,
  });

  factory DocumentUploadTicket({
    required int documentId,
    required String uploadDescription,
  }) = _DocumentUploadTicketImpl;

  factory DocumentUploadTicket.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DocumentUploadTicket(
      documentId: jsonSerialization['documentId'] as int,
      uploadDescription: jsonSerialization['uploadDescription'] as String,
    );
  }

  int documentId;

  String uploadDescription;

  /// Returns a shallow copy of this [DocumentUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DocumentUploadTicket copyWith({
    int? documentId,
    String? uploadDescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DocumentUploadTicket',
      'documentId': documentId,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DocumentUploadTicket',
      'documentId': documentId,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DocumentUploadTicketImpl extends DocumentUploadTicket {
  _DocumentUploadTicketImpl({
    required int documentId,
    required String uploadDescription,
  }) : super._(
         documentId: documentId,
         uploadDescription: uploadDescription,
       );

  /// Returns a shallow copy of this [DocumentUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DocumentUploadTicket copyWith({
    int? documentId,
    String? uploadDescription,
  }) {
    return DocumentUploadTicket(
      documentId: documentId ?? this.documentId,
      uploadDescription: uploadDescription ?? this.uploadDescription,
    );
  }
}
