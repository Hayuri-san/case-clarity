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
import 'case_type.dart' as _igfaebu4;

abstract class LegalGuide
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LegalGuide._({
    this.id,
    required this.slug,
    required this.title,
    required this.caseType,
    required this.summary,
    required this.steps,
    required this.relevantSections,
    required this.disclaimer,
    required this.sortOrder,
  });

  factory LegalGuide({
    int? id,
    required String slug,
    required String title,
    required _igfaebu4.CaseType caseType,
    required String summary,
    required List<String> steps,
    required List<String> relevantSections,
    required String disclaimer,
    required int sortOrder,
  }) = _LegalGuideImpl;

  factory LegalGuide.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegalGuide(
      id: jsonSerialization['id'] as int?,
      slug: jsonSerialization['slug'] as String,
      title: jsonSerialization['title'] as String,
      caseType: _igfaebu4.CaseType.fromJson(
        (jsonSerialization['caseType'] as String),
      ),
      summary: jsonSerialization['summary'] as String,
      steps: _ism1ooo3.Protocol().deserialize<List<String>>(
        jsonSerialization['steps'],
      ),
      relevantSections: _ism1ooo3.Protocol().deserialize<List<String>>(
        jsonSerialization['relevantSections'],
      ),
      disclaimer: jsonSerialization['disclaimer'] as String,
      sortOrder: jsonSerialization['sortOrder'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String slug;

  String title;

  _igfaebu4.CaseType caseType;

  String summary;

  List<String> steps;

  List<String> relevantSections;

  String disclaimer;

  int sortOrder;

  /// Returns a shallow copy of this [LegalGuide]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LegalGuide copyWith({
    int? id,
    String? slug,
    String? title,
    _igfaebu4.CaseType? caseType,
    String? summary,
    List<String>? steps,
    List<String>? relevantSections,
    String? disclaimer,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LegalGuide',
      if (id != null) 'id': id,
      'slug': slug,
      'title': title,
      'caseType': caseType.toJson(),
      'summary': summary,
      'steps': steps.toJson(),
      'relevantSections': relevantSections.toJson(),
      'disclaimer': disclaimer,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LegalGuide',
      if (id != null) 'id': id,
      'slug': slug,
      'title': title,
      'caseType': caseType.toJson(),
      'summary': summary,
      'steps': steps.toJson(),
      'relevantSections': relevantSections.toJson(),
      'disclaimer': disclaimer,
      'sortOrder': sortOrder,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegalGuideImpl extends LegalGuide {
  _LegalGuideImpl({
    int? id,
    required String slug,
    required String title,
    required _igfaebu4.CaseType caseType,
    required String summary,
    required List<String> steps,
    required List<String> relevantSections,
    required String disclaimer,
    required int sortOrder,
  }) : super._(
         id: id,
         slug: slug,
         title: title,
         caseType: caseType,
         summary: summary,
         steps: steps,
         relevantSections: relevantSections,
         disclaimer: disclaimer,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [LegalGuide]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LegalGuide copyWith({
    Object? id = _Undefined,
    String? slug,
    String? title,
    _igfaebu4.CaseType? caseType,
    String? summary,
    List<String>? steps,
    List<String>? relevantSections,
    String? disclaimer,
    int? sortOrder,
  }) {
    return LegalGuide(
      id: id is int? ? id : this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      caseType: caseType ?? this.caseType,
      summary: summary ?? this.summary,
      steps: steps ?? this.steps.map((e0) => e0).toList(),
      relevantSections:
          relevantSections ?? this.relevantSections.map((e0) => e0).toList(),
      disclaimer: disclaimer ?? this.disclaimer,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
