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
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import 'case_stage.dart' as _if5glxvh;
import 'case_type.dart' as _igfaebu4;

abstract class LegalCase
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue creatorId,
    _is.UuidValue? assignedLawyerId,
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
      creatorId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['creatorId'],
      ),
      assignedLawyerId: jsonSerialization['assignedLawyerId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['assignedLawyerId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = LegalCaseTable();

  static const db = LegalCaseRepository._();

  @override
  int? id;

  String title;

  _igfaebu4.CaseType caseType;

  String description;

  _if5glxvh.CaseStage stage;

  _is.UuidValue creatorId;

  _is.UuidValue? assignedLawyerId;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LegalCase]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LegalCase copyWith({
    int? id,
    String? title,
    _igfaebu4.CaseType? caseType,
    String? description,
    _if5glxvh.CaseStage? stage,
    _is.UuidValue? creatorId,
    _is.UuidValue? assignedLawyerId = const _is.$UndefinedUuidValue(),
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

  static LegalCaseInclude include() {
    return LegalCaseInclude._();
  }

  static LegalCaseIncludeList includeList({
    _is.WhereExpressionBuilder<LegalCaseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalCaseTable>? orderBy,
    _is.OrderByListBuilder<LegalCaseTable>? orderByList,
    LegalCaseInclude? include,
  }) {
    return LegalCaseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
    required _is.UuidValue creatorId,
    _is.UuidValue? assignedLawyerId,
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
  @_is.useResult
  @override
  LegalCase copyWith({
    Object? id = _Undefined,
    String? title,
    _igfaebu4.CaseType? caseType,
    String? description,
    _if5glxvh.CaseStage? stage,
    _is.UuidValue? creatorId,
    _is.UuidValue? assignedLawyerId = const _is.$UndefinedUuidValue(),
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
      assignedLawyerId: assignedLawyerId is _is.UndefinedSentinel
          ? this.assignedLawyerId
          : assignedLawyerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LegalCaseUpdateTable extends _is.UpdateTable<LegalCaseTable> {
  LegalCaseUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<_igfaebu4.CaseType, _igfaebu4.CaseType> caseType(
    _igfaebu4.CaseType value,
  ) => _is.ColumnValue(
    table.caseType,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<_if5glxvh.CaseStage, _if5glxvh.CaseStage> stage(
    _if5glxvh.CaseStage value,
  ) => _is.ColumnValue(
    table.stage,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> creatorId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.creatorId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> assignedLawyerId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.assignedLawyerId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class LegalCaseTable extends _is.Table<int?> {
  LegalCaseTable({super.tableRelation}) : super(tableName: 'legal_case') {
    updateTable = LegalCaseUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    caseType = _is.ColumnEnum(
      'caseType',
      this,
      _is.EnumSerialization.byName,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    stage = _is.ColumnEnum(
      'stage',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    creatorId = _is.ColumnUuid(
      'creatorId',
      this,
    );
    assignedLawyerId = _is.ColumnUuid(
      'assignedLawyerId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final LegalCaseUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnEnum<_igfaebu4.CaseType> caseType;

  late final _is.ColumnString description;

  late final _is.ColumnEnum<_if5glxvh.CaseStage> stage;

  late final _is.ColumnUuid creatorId;

  late final _is.ColumnUuid assignedLawyerId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    title,
    caseType,
    description,
    stage,
    creatorId,
    assignedLawyerId,
    createdAt,
    updatedAt,
  ];
}

class LegalCaseInclude extends _is.IncludeObject {
  LegalCaseInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LegalCase.t;
}

class LegalCaseIncludeList extends _is.IncludeList {
  LegalCaseIncludeList._({
    _is.WhereExpressionBuilder<LegalCaseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegalCase.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LegalCase.t;
}

class LegalCaseRepository {
  const LegalCaseRepository._();

  /// Returns a list of [LegalCase]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<LegalCase>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalCaseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalCaseTable>? orderBy,
    _is.OrderByListBuilder<LegalCaseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LegalCase>(
      where: where?.call(LegalCase.t),
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [LegalCase]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `LegalCase.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<LegalCase>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalCaseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalCaseTable>? orderBy,
    _is.OrderByListBuilder<LegalCaseTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<LegalCase>(
      where: where?.call(LegalCase.t),
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [LegalCase] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<LegalCase?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalCaseTable>? where,
    int? offset,
    _is.OrderByBuilder<LegalCaseTable>? orderBy,
    _is.OrderByListBuilder<LegalCaseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LegalCase>(
      where: where?.call(LegalCase.t),
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LegalCase] by its [id] or null if no such row exists.
  Future<LegalCase?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LegalCase>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LegalCase]s in the list and returns the inserted rows.
  ///
  /// The returned [LegalCase]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalCase>> insert(
    _is.DatabaseSession session,
    List<LegalCase> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LegalCase>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LegalCase] and returns the inserted row.
  ///
  /// The returned [LegalCase] will have its `id` field set.
  Future<LegalCase> insertRow(
    _is.DatabaseSession session,
    LegalCase row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegalCase>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LegalCase]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [LegalCase]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalCase>> upsert(
    _is.DatabaseSession session,
    List<LegalCase> rows, {
    required _is.ColumnSelections<LegalCaseTable> conflictColumns,
    _is.ColumnSelections<LegalCaseTable>? updateColumns,
    _is.WhereExpressionBuilder<LegalCaseTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LegalCase>(
      rows,
      conflictColumns: conflictColumns(LegalCase.t),
      updateColumns: updateColumns?.call(LegalCase.t),
      updateWhere: updateWhere?.call(LegalCase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LegalCase] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [LegalCase] will have its `id` field set.
  Future<LegalCase?> upsertRow(
    _is.DatabaseSession session,
    LegalCase row, {
    required _is.ColumnSelections<LegalCaseTable> conflictColumns,
    _is.ColumnSelections<LegalCaseTable>? updateColumns,
    _is.WhereExpressionBuilder<LegalCaseTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LegalCase>(
      row,
      conflictColumns: conflictColumns(LegalCase.t),
      updateColumns: updateColumns?.call(LegalCase.t),
      updateWhere: updateWhere?.call(LegalCase.t),
      transaction: transaction,
    );
  }

  /// Updates all [LegalCase]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalCase>> update(
    _is.DatabaseSession session,
    List<LegalCase> rows, {
    _is.ColumnSelections<LegalCaseTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LegalCase>(
      rows,
      columns: columns?.call(LegalCase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LegalCase]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegalCase> updateRow(
    _is.DatabaseSession session,
    LegalCase row, {
    _is.ColumnSelections<LegalCaseTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegalCase>(
      row,
      columns: columns?.call(LegalCase.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegalCase] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegalCase?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LegalCaseUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LegalCase>(
      id,
      columnValues: columnValues(LegalCase.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegalCase]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalCase>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LegalCaseUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LegalCaseTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalCaseTable>? orderBy,
    _is.OrderByListBuilder<LegalCaseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LegalCase>(
      columnValues: columnValues(LegalCase.t.updateTable),
      where: where(LegalCase.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LegalCase]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalCase>> delete(
    _is.DatabaseSession session,
    List<LegalCase> rows, {
    _is.OrderByBuilder<LegalCaseTable>? orderBy,
    _is.OrderByListBuilder<LegalCaseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LegalCase>(
      rows,
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LegalCase].
  Future<LegalCase> deleteRow(
    _is.DatabaseSession session,
    LegalCase row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegalCase>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalCase>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegalCaseTable> where,
    _is.OrderByBuilder<LegalCaseTable>? orderBy,
    _is.OrderByListBuilder<LegalCaseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LegalCase>(
      where: where(LegalCase.t),
      orderBy: orderBy?.call(LegalCase.t),
      orderByList: orderByList?.call(LegalCase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalCaseTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LegalCase>(
      where: where?.call(LegalCase.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LegalCase] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegalCaseTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LegalCase>(
      where: where(LegalCase.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
