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
import 'case_stage.dart' as _if5glxvh;
import 'case_type.dart' as _igfaebu4;

abstract class LegalCase
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LegalCase._({
    this.id,
    required this.title,
    required this.caseType,
    required this.description,
    _if5glxvh.CaseStage? stage,
    required this.creatorId,
    this.assignedLawyerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : stage = stage ?? _if5glxvh.CaseStage.underReview,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory LegalCase({
    int? id,
    required String title,
    required _igfaebu4.CaseType caseType,
    required String description,
    _if5glxvh.CaseStage? stage,
    required _isc.UuidValue creatorId,
    _isc.UuidValue? assignedLawyerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LegalCaseImpl;

  factory LegalCase.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegalCase(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      caseType: _igfaebu4.CaseType.fromJson(
        (jsonSerialization['caseType'] as String),
      ),
      description: jsonSerialization['description'] as String,
      stage: jsonSerialization['stage'] == null
          ? null
          : _if5glxvh.CaseStage.fromJson(
              (jsonSerialization['stage'] as String),
            ),
      creatorId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['creatorId'],
      ),
      assignedLawyerId: jsonSerialization['assignedLawyerId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['assignedLawyerId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  _igfaebu4.CaseType caseType;

  String description;

  _if5glxvh.CaseStage stage;

  _isc.UuidValue creatorId;

  _isc.UuidValue? assignedLawyerId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [LegalCase]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LegalCase copyWith({
    int? id,
    String? title,
    _igfaebu4.CaseType? caseType,
    String? description,
    _if5glxvh.CaseStage? stage,
    _isc.UuidValue? creatorId,
    _isc.UuidValue? assignedLawyerId = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LegalCase',
      if (id != null) 'id': id,
      'title': title,
      'caseType': caseType.toJson(),
      'description': description,
      'stage': stage.toJson(),
      'creatorId': creatorId.toJson(),
      if (assignedLawyerId != null)
        'assignedLawyerId': assignedLawyerId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LegalCase',
      if (id != null) 'id': id,
      'title': title,
      'caseType': caseType.toJson(),
      'description': description,
      'stage': stage.toJson(),
      'creatorId': creatorId.toJson(),
      if (assignedLawyerId != null)
        'assignedLawyerId': assignedLawyerId?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegalCaseImpl extends LegalCase {
  _LegalCaseImpl({
    int? id,
    required String title,
    required _igfaebu4.CaseType caseType,
    required String description,
    _if5glxvh.CaseStage? stage,
    required _isc.UuidValue creatorId,
    _isc.UuidValue? assignedLawyerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         title: title,
         caseType: caseType,
         description: description,
         stage: stage,
         creatorId: creatorId,
         assignedLawyerId: assignedLawyerId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LegalCase]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LegalCase copyWith({
    Object? id = _Undefined,
    String? title,
    _igfaebu4.CaseType? caseType,
    String? description,
    _if5glxvh.CaseStage? stage,
    _isc.UuidValue? creatorId,
    _isc.UuidValue? assignedLawyerId = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LegalCase(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      caseType: caseType ?? this.caseType,
      description: description ?? this.description,
      stage: stage ?? this.stage,
      creatorId: creatorId ?? this.creatorId,
      assignedLawyerId: assignedLawyerId is _isc.UndefinedSentinel
          ? this.assignedLawyerId
          : assignedLawyerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
