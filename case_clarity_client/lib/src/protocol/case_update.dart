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
import 'case_update_kind.dart' as _ibzvjs03;

abstract class CaseUpdate
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CaseUpdate._({
    this.id,
    required this.caseId,
    required this.authorId,
    required this.kind,
    required this.title,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CaseUpdate({
    int? id,
    required int caseId,
    required _isc.UuidValue authorId,
    required _ibzvjs03.CaseUpdateKind kind,
    required String title,
    required String description,
    DateTime? createdAt,
  }) = _CaseUpdateImpl;

  factory CaseUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaseUpdate(
      id: jsonSerialization['id'] as int?,
      caseId: jsonSerialization['caseId'] as int,
      authorId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authorId'],
      ),
      kind: _ibzvjs03.CaseUpdateKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
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

  _isc.UuidValue authorId;

  _ibzvjs03.CaseUpdateKind kind;

  String title;

  String description;

  DateTime createdAt;

  /// Returns a shallow copy of this [CaseUpdate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CaseUpdate copyWith({
    int? id,
    int? caseId,
    _isc.UuidValue? authorId,
    _ibzvjs03.CaseUpdateKind? kind,
    String? title,
    String? description,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaseUpdate',
      if (id != null) 'id': id,
      'caseId': caseId,
      'authorId': authorId.toJson(),
      'kind': kind.toJson(),
      'title': title,
      'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaseUpdate',
      if (id != null) 'id': id,
      'caseId': caseId,
      'authorId': authorId.toJson(),
      'kind': kind.toJson(),
      'title': title,
      'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaseUpdateImpl extends CaseUpdate {
  _CaseUpdateImpl({
    int? id,
    required int caseId,
    required _isc.UuidValue authorId,
    required _ibzvjs03.CaseUpdateKind kind,
    required String title,
    required String description,
    DateTime? createdAt,
  }) : super._(
         id: id,
         caseId: caseId,
         authorId: authorId,
         kind: kind,
         title: title,
         description: description,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CaseUpdate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CaseUpdate copyWith({
    Object? id = _Undefined,
    int? caseId,
    _isc.UuidValue? authorId,
    _ibzvjs03.CaseUpdateKind? kind,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return CaseUpdate(
      id: id is int? ? id : this.id,
      caseId: caseId ?? this.caseId,
      authorId: authorId ?? this.authorId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
