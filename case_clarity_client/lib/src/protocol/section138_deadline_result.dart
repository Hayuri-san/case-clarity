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
import 'deadline_item.dart' as _ith1d9x5;

abstract class Section138DeadlineResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Section138DeadlineResult._({
    required this.items,
    required this.assumptions,
    required this.disclaimer,
  });

  factory Section138DeadlineResult({
    required List<_ith1d9x5.DeadlineItem> items,
    required List<String> assumptions,
    required String disclaimer,
  }) = _Section138DeadlineResultImpl;

  factory Section138DeadlineResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return Section138DeadlineResult(
      items: _ism1ooo3.Protocol().deserialize<List<_ith1d9x5.DeadlineItem>>(
        jsonSerialization['items'],
      ),
      assumptions: _ism1ooo3.Protocol().deserialize<List<String>>(
        jsonSerialization['assumptions'],
      ),
      disclaimer: jsonSerialization['disclaimer'] as String,
    );
  }

  List<_ith1d9x5.DeadlineItem> items;

  List<String> assumptions;

  String disclaimer;

  /// Returns a shallow copy of this [Section138DeadlineResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Section138DeadlineResult copyWith({
    List<_ith1d9x5.DeadlineItem>? items,
    List<String>? assumptions,
    String? disclaimer,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Section138DeadlineResult',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'assumptions': assumptions.toJson(),
      'disclaimer': disclaimer,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Section138DeadlineResult',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'assumptions': assumptions.toJson(),
      'disclaimer': disclaimer,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Section138DeadlineResultImpl extends Section138DeadlineResult {
  _Section138DeadlineResultImpl({
    required List<_ith1d9x5.DeadlineItem> items,
    required List<String> assumptions,
    required String disclaimer,
  }) : super._(
         items: items,
         assumptions: assumptions,
         disclaimer: disclaimer,
       );

  /// Returns a shallow copy of this [Section138DeadlineResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Section138DeadlineResult copyWith({
    List<_ith1d9x5.DeadlineItem>? items,
    List<String>? assumptions,
    String? disclaimer,
  }) {
    return Section138DeadlineResult(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      assumptions: assumptions ?? this.assumptions.map((e0) => e0).toList(),
      disclaimer: disclaimer ?? this.disclaimer,
    );
  }
}
