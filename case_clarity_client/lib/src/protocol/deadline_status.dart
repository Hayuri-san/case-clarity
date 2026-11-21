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

enum DeadlineStatus implements _isc.SerializableModel {
  upcoming,
  dueSoon,
  passed,
  notYetComputable;

  static DeadlineStatus fromJson(String name) {
    switch (name) {
      case 'upcoming':
        return DeadlineStatus.upcoming;
      case 'dueSoon':
        return DeadlineStatus.dueSoon;
      case 'passed':
        return DeadlineStatus.passed;
      case 'notYetComputable':
        return DeadlineStatus.notYetComputable;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DeadlineStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
