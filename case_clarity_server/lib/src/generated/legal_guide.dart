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
import 'package:case_clarity_server/src/generated/protocol.dart' as _i794f3qj;
import 'package:serverpod/serverpod.dart' as _is;
import 'case_type.dart' as _igfaebu4;

abstract class LegalGuide
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      steps: _i794f3qj.Protocol().deserialize<List<String>>(
        jsonSerialization['steps'],
      ),
      relevantSections: _i794f3qj.Protocol().deserialize<List<String>>(
        jsonSerialization['relevantSections'],
      ),
      disclaimer: jsonSerialization['disclaimer'] as String,
      sortOrder: jsonSerialization['sortOrder'] as int,
    );
  }

  static final t = LegalGuideTable();

  static const db = LegalGuideRepository._();

  @override
  int? id;

  String slug;

  String title;

  _igfaebu4.CaseType caseType;

  String summary;

  List<String> steps;

  List<String> relevantSections;

  String disclaimer;

  int sortOrder;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LegalGuide]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static LegalGuideInclude include() {
    return LegalGuideInclude._();
  }

  static LegalGuideIncludeList includeList({
    _is.WhereExpressionBuilder<LegalGuideTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalGuideTable>? orderBy,
    _is.OrderByListBuilder<LegalGuideTable>? orderByList,
    LegalGuideInclude? include,
  }) {
    return LegalGuideIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalGuide.t),
      orderByList: orderByList?.call(LegalGuide.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class LegalGuideUpdateTable extends _is.UpdateTable<LegalGuideTable> {
  LegalGuideUpdateTable(super.table);

  _is.ColumnValue<String, String> slug(String value) => _is.ColumnValue(
    table.slug,
    value,
  );

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

  _is.ColumnValue<String, String> summary(String value) => _is.ColumnValue(
    table.summary,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> steps(List<String> value) =>
      _is.ColumnValue(
        table.steps,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> relevantSections(
    List<String> value,
  ) => _is.ColumnValue(
    table.relevantSections,
    value,
  );

  _is.ColumnValue<String, String> disclaimer(String value) => _is.ColumnValue(
    table.disclaimer,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );
}

class LegalGuideTable extends _is.Table<int?> {
  LegalGuideTable({super.tableRelation}) : super(tableName: 'legal_guide') {
    updateTable = LegalGuideUpdateTable(this);
    slug = _is.ColumnString(
      'slug',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    caseType = _is.ColumnEnum(
      'caseType',
      this,
      _is.EnumSerialization.byName,
    );
    summary = _is.ColumnString(
      'summary',
      this,
    );
    steps = _is.ColumnSerializable<List<String>>(
      'steps',
      this,
    );
    relevantSections = _is.ColumnSerializable<List<String>>(
      'relevantSections',
      this,
    );
    disclaimer = _is.ColumnString(
      'disclaimer',
      this,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
    );
  }

  late final LegalGuideUpdateTable updateTable;

  late final _is.ColumnString slug;

  late final _is.ColumnString title;

  late final _is.ColumnEnum<_igfaebu4.CaseType> caseType;

  late final _is.ColumnString summary;

  late final _is.ColumnSerializable<List<String>> steps;

  late final _is.ColumnSerializable<List<String>> relevantSections;

  late final _is.ColumnString disclaimer;

  late final _is.ColumnInt sortOrder;

  @override
  List<_is.Column> get columns => [
    id,
    slug,
    title,
    caseType,
    summary,
    steps,
    relevantSections,
    disclaimer,
    sortOrder,
  ];
}

class LegalGuideInclude extends _is.IncludeObject {
  LegalGuideInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LegalGuide.t;
}

class LegalGuideIncludeList extends _is.IncludeList {
  LegalGuideIncludeList._({
    _is.WhereExpressionBuilder<LegalGuideTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegalGuide.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LegalGuide.t;
}

class LegalGuideRepository {
  const LegalGuideRepository._();

  /// Returns a list of [LegalGuide]s matching the given query parameters.
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
  Future<List<LegalGuide>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalGuideTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalGuideTable>? orderBy,
    _is.OrderByListBuilder<LegalGuideTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LegalGuide>(
      where: where?.call(LegalGuide.t),
      orderBy: orderBy?.call(LegalGuide.t),
      orderByList: orderByList?.call(LegalGuide.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [LegalGuide]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `LegalGuide.t`.
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
  _ida.Stream<List<LegalGuide>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalGuideTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalGuideTable>? orderBy,
    _is.OrderByListBuilder<LegalGuideTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<LegalGuide>(
      where: where?.call(LegalGuide.t),
      orderBy: orderBy?.call(LegalGuide.t),
      orderByList: orderByList?.call(LegalGuide.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [LegalGuide] matching the given query parameters.
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
  Future<LegalGuide?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalGuideTable>? where,
    int? offset,
    _is.OrderByBuilder<LegalGuideTable>? orderBy,
    _is.OrderByListBuilder<LegalGuideTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LegalGuide>(
      where: where?.call(LegalGuide.t),
      orderBy: orderBy?.call(LegalGuide.t),
      orderByList: orderByList?.call(LegalGuide.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LegalGuide] by its [id] or null if no such row exists.
  Future<LegalGuide?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LegalGuide>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LegalGuide]s in the list and returns the inserted rows.
  ///
  /// The returned [LegalGuide]s will have their `id` fields set.
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
  Future<List<LegalGuide>> insert(
    _is.DatabaseSession session,
    List<LegalGuide> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LegalGuide>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LegalGuide] and returns the inserted row.
  ///
  /// The returned [LegalGuide] will have its `id` field set.
  Future<LegalGuide> insertRow(
    _is.DatabaseSession session,
    LegalGuide row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegalGuide>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LegalGuide]s in the list and returns the resulting rows.
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
  /// The returned [LegalGuide]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalGuide>> upsert(
    _is.DatabaseSession session,
    List<LegalGuide> rows, {
    required _is.ColumnSelections<LegalGuideTable> conflictColumns,
    _is.ColumnSelections<LegalGuideTable>? updateColumns,
    _is.WhereExpressionBuilder<LegalGuideTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LegalGuide>(
      rows,
      conflictColumns: conflictColumns(LegalGuide.t),
      updateColumns: updateColumns?.call(LegalGuide.t),
      updateWhere: updateWhere?.call(LegalGuide.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LegalGuide] and returns the resulting row.
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
  /// The returned [LegalGuide] will have its `id` field set.
  Future<LegalGuide?> upsertRow(
    _is.DatabaseSession session,
    LegalGuide row, {
    required _is.ColumnSelections<LegalGuideTable> conflictColumns,
    _is.ColumnSelections<LegalGuideTable>? updateColumns,
    _is.WhereExpressionBuilder<LegalGuideTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LegalGuide>(
      row,
      conflictColumns: conflictColumns(LegalGuide.t),
      updateColumns: updateColumns?.call(LegalGuide.t),
      updateWhere: updateWhere?.call(LegalGuide.t),
      transaction: transaction,
    );
  }

  /// Updates all [LegalGuide]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalGuide>> update(
    _is.DatabaseSession session,
    List<LegalGuide> rows, {
    _is.ColumnSelections<LegalGuideTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LegalGuide>(
      rows,
      columns: columns?.call(LegalGuide.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LegalGuide]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegalGuide> updateRow(
    _is.DatabaseSession session,
    LegalGuide row, {
    _is.ColumnSelections<LegalGuideTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegalGuide>(
      row,
      columns: columns?.call(LegalGuide.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegalGuide] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegalGuide?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LegalGuideUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LegalGuide>(
      id,
      columnValues: columnValues(LegalGuide.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegalGuide]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LegalGuide>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LegalGuideUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LegalGuideTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LegalGuideTable>? orderBy,
    _is.OrderByListBuilder<LegalGuideTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LegalGuide>(
      columnValues: columnValues(LegalGuide.t.updateTable),
      where: where(LegalGuide.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegalGuide.t),
      orderByList: orderByList?.call(LegalGuide.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LegalGuide]s in the list and returns the deleted rows.
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
  Future<List<LegalGuide>> delete(
    _is.DatabaseSession session,
    List<LegalGuide> rows, {
    _is.OrderByBuilder<LegalGuideTable>? orderBy,
    _is.OrderByListBuilder<LegalGuideTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LegalGuide>(
      rows,
      orderBy: orderBy?.call(LegalGuide.t),
      orderByList: orderByList?.call(LegalGuide.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LegalGuide].
  Future<LegalGuide> deleteRow(
    _is.DatabaseSession session,
    LegalGuide row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegalGuide>(
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
  Future<List<LegalGuide>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegalGuideTable> where,
    _is.OrderByBuilder<LegalGuideTable>? orderBy,
    _is.OrderByListBuilder<LegalGuideTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LegalGuide>(
      where: where(LegalGuide.t),
      orderBy: orderBy?.call(LegalGuide.t),
      orderByList: orderByList?.call(LegalGuide.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LegalGuideTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LegalGuide>(
      where: where?.call(LegalGuide.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LegalGuide] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LegalGuideTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LegalGuide>(
      where: where(LegalGuide.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
