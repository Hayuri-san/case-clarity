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
import 'deadline_status.dart' as _i9rknlqw;

abstract class DeadlineItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeadlineItem._({
    required this.label,
    this.dueDate,
    required this.basis,
    required this.status,
  });

  factory DeadlineItem({
    required String label,
    DateTime? dueDate,
    required String basis,
    required _i9rknlqw.DeadlineStatus status,
  }) = _DeadlineItemImpl;

  factory DeadlineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeadlineItem(
      label: jsonSerialization['label'] as String,
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      basis: jsonSerialization['basis'] as String,
      status: _i9rknlqw.DeadlineStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
    );
  }

  String label;

  DateTime? dueDate;

  String basis;

  _i9rknlqw.DeadlineStatus status;

  /// Returns a shallow copy of this [DeadlineItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeadlineItem copyWith({
    String? label,
    DateTime? dueDate = const _isc.$UndefinedDateTime(),
    String? basis,
    _i9rknlqw.DeadlineStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeadlineItem',
      'label': label,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'basis': basis,
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeadlineItem',
      'label': label,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'basis': basis,
      'status': status.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeadlineItemImpl extends DeadlineItem {
  _DeadlineItemImpl({
    required String label,
    DateTime? dueDate,
    required String basis,
    required _i9rknlqw.DeadlineStatus status,
  }) : super._(
         label: label,
         dueDate: dueDate,
         basis: basis,
         status: status,
       );

  /// Returns a shallow copy of this [DeadlineItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeadlineItem copyWith({
    String? label,
    DateTime? dueDate = const _isc.$UndefinedDateTime(),
    String? basis,
    _i9rknlqw.DeadlineStatus? status,
  }) {
    return DeadlineItem(
      label: label ?? this.label,
      dueDate: dueDate is _isc.UndefinedSentinel ? this.dueDate : dueDate,
      basis: basis ?? this.basis,
      status: status ?? this.status,
    );
  }
}
