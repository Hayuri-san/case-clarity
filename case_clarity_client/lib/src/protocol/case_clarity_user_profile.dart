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
import 'user_role.dart' as _ir0y0iu6;

abstract class CaseClarityUserProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CaseClarityUserProfile._({
    this.id,
    required this.userId,
    required this.fullName,
    required this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CaseClarityUserProfile({
    int? id,
    required _isc.UuidValue userId,
    required String fullName,
    required _ir0y0iu6.UserRole role,
    DateTime? createdAt,
  }) = _CaseClarityUserProfileImpl;

  factory CaseClarityUserProfile.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CaseClarityUserProfile(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      fullName: jsonSerialization['fullName'] as String,
      role: _ir0y0iu6.UserRole.fromJson((jsonSerialization['role'] as String)),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue userId;

  String fullName;

  _ir0y0iu6.UserRole role;

  DateTime createdAt;

  /// Returns a shallow copy of this [CaseClarityUserProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CaseClarityUserProfile copyWith({
    int? id,
    _isc.UuidValue? userId,
    String? fullName,
    _ir0y0iu6.UserRole? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaseClarityUserProfile',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'fullName': fullName,
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaseClarityUserProfile',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'fullName': fullName,
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaseClarityUserProfileImpl extends CaseClarityUserProfile {
  _CaseClarityUserProfileImpl({
    int? id,
    required _isc.UuidValue userId,
    required String fullName,
    required _ir0y0iu6.UserRole role,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         fullName: fullName,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CaseClarityUserProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CaseClarityUserProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? fullName,
    _ir0y0iu6.UserRole? role,
    DateTime? createdAt,
  }) {
    return CaseClarityUserProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
