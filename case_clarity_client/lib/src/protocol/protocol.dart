/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:case_clarity_client/src/protocol/case_update.dart' as _id85u6x2;
import 'package:case_clarity_client/src/protocol/legal_case.dart' as _ikj33umw;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'case_clarity_user_profile.dart' as _ijms5s6d;
import 'case_stage.dart' as _if5glxvh;
import 'case_type.dart' as _igfaebu4;
import 'case_update.dart' as _idl61rz9;
import 'case_update_kind.dart' as _ibzvjs03;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'legal_case.dart' as _ii7rdblg;
import 'user_role.dart' as _ir0y0iu6;
export 'case_clarity_user_profile.dart';
export 'case_stage.dart';
export 'case_type.dart';
export 'case_update.dart';
export 'case_update_kind.dart';
export 'greetings/greeting.dart';
export 'legal_case.dart';
export 'user_role.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager
    implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata =>
      _isc.ProtocolDeserialization.cached(
        this,
        types: const [
          _isc.getType<_ijms5s6d.CaseClarityUserProfile>,
          _isc.getType<_if5glxvh.CaseStage>,
          _isc.getType<_igfaebu4.CaseType>,
          _isc.getType<_idl61rz9.CaseUpdate>,
          _isc.getType<_ibzvjs03.CaseUpdateKind>,
          _isc.getType<_izw8z7ou.Greeting>,
          _isc.getType<_ii7rdblg.LegalCase>,
          _isc.getType<_ir0y0iu6.UserRole>,
          _isc.getType<_ijms5s6d.CaseClarityUserProfile?>,
          _isc.getType<_if5glxvh.CaseStage?>,
          _isc.getType<_igfaebu4.CaseType?>,
          _isc.getType<_idl61rz9.CaseUpdate?>,
          _isc.getType<_ibzvjs03.CaseUpdateKind?>,
          _isc.getType<_izw8z7ou.Greeting?>,
          _isc.getType<_ii7rdblg.LegalCase?>,
          _isc.getType<_ir0y0iu6.UserRole?>,
          _isc.getType<List<_ikj33umw.LegalCase>>,
          _isc.getType<List<_id85u6x2.CaseUpdate>>,
        ],
        modules: const [
          _iaic.Protocol.new,
          _iacc.Protocol.new,
        ],
        classNames: const [
          'CaseClarityUserProfile',
          'CaseStage',
          'CaseType',
          'CaseUpdate',
          'CaseUpdateKind',
          'Greeting',
          'LegalCase',
          'UserRole',
        ],
      );

  static String? getClassNameFromObjectJson(dynamic data) =>
      _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ijms5s6d.CaseClarityUserProfile) {
      return _ijms5s6d.CaseClarityUserProfile.fromJson(data) as T;
    }
    if (t == _if5glxvh.CaseStage) {
      return _if5glxvh.CaseStage.fromJson(data) as T;
    }
    if (t == _igfaebu4.CaseType) {
      return _igfaebu4.CaseType.fromJson(data) as T;
    }
    if (t == _idl61rz9.CaseUpdate) {
      return _idl61rz9.CaseUpdate.fromJson(data) as T;
    }
    if (t == _ibzvjs03.CaseUpdateKind) {
      return _ibzvjs03.CaseUpdateKind.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _ii7rdblg.LegalCase) {
      return _ii7rdblg.LegalCase.fromJson(data) as T;
    }
    if (t == _ir0y0iu6.UserRole) {
      return _ir0y0iu6.UserRole.fromJson(data) as T;
    }
    if (t == _isc.getType<_ijms5s6d.CaseClarityUserProfile?>()) {
      return (data != null
              ? _ijms5s6d.CaseClarityUserProfile.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_if5glxvh.CaseStage?>()) {
      return (data != null ? _if5glxvh.CaseStage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igfaebu4.CaseType?>()) {
      return (data != null ? _igfaebu4.CaseType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idl61rz9.CaseUpdate?>()) {
      return (data != null ? _idl61rz9.CaseUpdate.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibzvjs03.CaseUpdateKind?>()) {
      return (data != null ? _ibzvjs03.CaseUpdateKind.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ii7rdblg.LegalCase?>()) {
      return (data != null ? _ii7rdblg.LegalCase.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ir0y0iu6.UserRole?>()) {
      return (data != null ? _ir0y0iu6.UserRole.fromJson(data) : null) as T;
    }
    if (t == List<_ikj33umw.LegalCase>) {
      return (data as List)
              .map((e) => deserialize<_ikj33umw.LegalCase>(e))
              .toList()
          as T;
    }
    if (t == List<_id85u6x2.CaseUpdate>) {
      return (data as List)
              .map((e) => deserialize<_id85u6x2.CaseUpdate>(e))
              .toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _isc.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ijms5s6d.CaseClarityUserProfile => 'CaseClarityUserProfile',
      _if5glxvh.CaseStage => 'CaseStage',
      _igfaebu4.CaseType => 'CaseType',
      _idl61rz9.CaseUpdate => 'CaseUpdate',
      _ibzvjs03.CaseUpdateKind => 'CaseUpdateKind',
      _izw8z7ou.Greeting => 'Greeting',
      _ii7rdblg.LegalCase => 'LegalCase',
      _ir0y0iu6.UserRole => 'UserRole',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'case_clarity.',
        '',
      );
    }

    switch (data) {
      case _ijms5s6d.CaseClarityUserProfile():
        return 'CaseClarityUserProfile';
      case _if5glxvh.CaseStage():
        return 'CaseStage';
      case _igfaebu4.CaseType():
        return 'CaseType';
      case _idl61rz9.CaseUpdate():
        return 'CaseUpdate';
      case _ibzvjs03.CaseUpdateKind():
        return 'CaseUpdateKind';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _ii7rdblg.LegalCase():
        return 'LegalCase';
      case _ir0y0iu6.UserRole():
        return 'UserRole';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CaseClarityUserProfile') {
      return deserialize<_ijms5s6d.CaseClarityUserProfile>(data['data']);
    }
    if (dataClassName == 'CaseStage') {
      return deserialize<_if5glxvh.CaseStage>(data['data']);
    }
    if (dataClassName == 'CaseType') {
      return deserialize<_igfaebu4.CaseType>(data['data']);
    }
    if (dataClassName == 'CaseUpdate') {
      return deserialize<_idl61rz9.CaseUpdate>(data['data']);
    }
    if (dataClassName == 'CaseUpdateKind') {
      return deserialize<_ibzvjs03.CaseUpdateKind>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'LegalCase') {
      return deserialize<_ii7rdblg.LegalCase>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_ir0y0iu6.UserRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iaic.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacc.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('case_clarity', this);
    _iacc.Protocol().registerHostProtocol('case_clarity', this);
  }

  @override
  String getModuleName() => 'case_clarity';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
