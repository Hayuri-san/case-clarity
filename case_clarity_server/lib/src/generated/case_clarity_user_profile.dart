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
import 'user_role.dart' as _ir0y0iu6;

abstract class CaseClarityUserProfile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CaseClarityUserProfile._({
    this.id,
    required this.userId,
    required this.fullName,
    required this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CaseClarityUserProfile({
    int? id,
    required _is.UuidValue userId,
    required String fullName,
    required _ir0y0iu6.UserRole role,
    DateTime? createdAt,
  }) = _CaseClarityUserProfileImpl;

  factory CaseClarityUserProfile.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CaseClarityUserProfile(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      fullName: jsonSerialization['fullName'] as String,
      role: _ir0y0iu6.UserRole.fromJson((jsonSerialization['role'] as String)),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = CaseClarityUserProfileTable();

  static const db = CaseClarityUserProfileRepository._();

  @override
  int? id;

  _is.UuidValue userId;

  String fullName;

  _ir0y0iu6.UserRole role;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CaseClarityUserProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CaseClarityUserProfile copyWith({
    int? id,
    _is.UuidValue? userId,
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

  static CaseClarityUserProfileInclude include() {
    return CaseClarityUserProfileInclude._();
  }

  static CaseClarityUserProfileIncludeList includeList({
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseClarityUserProfileTable>? orderBy,
    _is.OrderByListBuilder<CaseClarityUserProfileTable>? orderByList,
    CaseClarityUserProfileInclude? include,
  }) {
    return CaseClarityUserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseClarityUserProfile.t),
      orderByList: orderByList?.call(CaseClarityUserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaseClarityUserProfileImpl extends CaseClarityUserProfile {
  _CaseClarityUserProfileImpl({
    int? id,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  CaseClarityUserProfile copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
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

class CaseClarityUserProfileUpdateTable
    extends _is.UpdateTable<CaseClarityUserProfileTable> {
  CaseClarityUserProfileUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> fullName(String value) => _is.ColumnValue(
    table.fullName,
    value,
  );

  _is.ColumnValue<_ir0y0iu6.UserRole, _ir0y0iu6.UserRole> role(
    _ir0y0iu6.UserRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CaseClarityUserProfileTable extends _is.Table<int?> {
  CaseClarityUserProfileTable({super.tableRelation})
    : super(tableName: 'case_clarity_user_profile') {
    updateTable = CaseClarityUserProfileUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    fullName = _is.ColumnString(
      'fullName',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final CaseClarityUserProfileUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnString fullName;

  late final _is.ColumnEnum<_ir0y0iu6.UserRole> role;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    fullName,
    role,
    createdAt,
  ];
}

class CaseClarityUserProfileInclude extends _is.IncludeObject {
  CaseClarityUserProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CaseClarityUserProfile.t;
}

class CaseClarityUserProfileIncludeList extends _is.IncludeList {
  CaseClarityUserProfileIncludeList._({
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CaseClarityUserProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CaseClarityUserProfile.t;
}

class CaseClarityUserProfileRepository {
  const CaseClarityUserProfileRepository._();

  /// Returns a list of [CaseClarityUserProfile]s matching the given query parameters.
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
  Future<List<CaseClarityUserProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseClarityUserProfileTable>? orderBy,
    _is.OrderByListBuilder<CaseClarityUserProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CaseClarityUserProfile>(
      where: where?.call(CaseClarityUserProfile.t),
      orderBy: orderBy?.call(CaseClarityUserProfile.t),
      orderByList: orderByList?.call(CaseClarityUserProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CaseClarityUserProfile]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CaseClarityUserProfile.t`.
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
  _ida.Stream<List<CaseClarityUserProfile>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseClarityUserProfileTable>? orderBy,
    _is.OrderByListBuilder<CaseClarityUserProfileTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CaseClarityUserProfile>(
      where: where?.call(CaseClarityUserProfile.t),
      orderBy: orderBy?.call(CaseClarityUserProfile.t),
      orderByList: orderByList?.call(CaseClarityUserProfile.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CaseClarityUserProfile] matching the given query parameters.
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
  Future<CaseClarityUserProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<CaseClarityUserProfileTable>? orderBy,
    _is.OrderByListBuilder<CaseClarityUserProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CaseClarityUserProfile>(
      where: where?.call(CaseClarityUserProfile.t),
      orderBy: orderBy?.call(CaseClarityUserProfile.t),
      orderByList: orderByList?.call(CaseClarityUserProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CaseClarityUserProfile] by its [id] or null if no such row exists.
  Future<CaseClarityUserProfile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CaseClarityUserProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CaseClarityUserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [CaseClarityUserProfile]s will have their `id` fields set.
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
  Future<List<CaseClarityUserProfile>> insert(
    _is.DatabaseSession session,
    List<CaseClarityUserProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CaseClarityUserProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CaseClarityUserProfile] and returns the inserted row.
  ///
  /// The returned [CaseClarityUserProfile] will have its `id` field set.
  Future<CaseClarityUserProfile> insertRow(
    _is.DatabaseSession session,
    CaseClarityUserProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CaseClarityUserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CaseClarityUserProfile]s in the list and returns the resulting rows.
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
  /// The returned [CaseClarityUserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseClarityUserProfile>> upsert(
    _is.DatabaseSession session,
    List<CaseClarityUserProfile> rows, {
    required _is.ColumnSelections<CaseClarityUserProfileTable> conflictColumns,
    _is.ColumnSelections<CaseClarityUserProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CaseClarityUserProfile>(
      rows,
      conflictColumns: conflictColumns(CaseClarityUserProfile.t),
      updateColumns: updateColumns?.call(CaseClarityUserProfile.t),
      updateWhere: updateWhere?.call(CaseClarityUserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CaseClarityUserProfile] and returns the resulting row.
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
  /// The returned [CaseClarityUserProfile] will have its `id` field set.
  Future<CaseClarityUserProfile?> upsertRow(
    _is.DatabaseSession session,
    CaseClarityUserProfile row, {
    required _is.ColumnSelections<CaseClarityUserProfileTable> conflictColumns,
    _is.ColumnSelections<CaseClarityUserProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CaseClarityUserProfile>(
      row,
      conflictColumns: conflictColumns(CaseClarityUserProfile.t),
      updateColumns: updateColumns?.call(CaseClarityUserProfile.t),
      updateWhere: updateWhere?.call(CaseClarityUserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [CaseClarityUserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseClarityUserProfile>> update(
    _is.DatabaseSession session,
    List<CaseClarityUserProfile> rows, {
    _is.ColumnSelections<CaseClarityUserProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CaseClarityUserProfile>(
      rows,
      columns: columns?.call(CaseClarityUserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CaseClarityUserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CaseClarityUserProfile> updateRow(
    _is.DatabaseSession session,
    CaseClarityUserProfile row, {
    _is.ColumnSelections<CaseClarityUserProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CaseClarityUserProfile>(
      row,
      columns: columns?.call(CaseClarityUserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CaseClarityUserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CaseClarityUserProfile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CaseClarityUserProfileUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CaseClarityUserProfile>(
      id,
      columnValues: columnValues(CaseClarityUserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CaseClarityUserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseClarityUserProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CaseClarityUserProfileUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CaseClarityUserProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseClarityUserProfileTable>? orderBy,
    _is.OrderByListBuilder<CaseClarityUserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CaseClarityUserProfile>(
      columnValues: columnValues(CaseClarityUserProfile.t.updateTable),
      where: where(CaseClarityUserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseClarityUserProfile.t),
      orderByList: orderByList?.call(CaseClarityUserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CaseClarityUserProfile]s in the list and returns the deleted rows.
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
  Future<List<CaseClarityUserProfile>> delete(
    _is.DatabaseSession session,
    List<CaseClarityUserProfile> rows, {
    _is.OrderByBuilder<CaseClarityUserProfileTable>? orderBy,
    _is.OrderByListBuilder<CaseClarityUserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CaseClarityUserProfile>(
      rows,
      orderBy: orderBy?.call(CaseClarityUserProfile.t),
      orderByList: orderByList?.call(CaseClarityUserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CaseClarityUserProfile].
  Future<CaseClarityUserProfile> deleteRow(
    _is.DatabaseSession session,
    CaseClarityUserProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CaseClarityUserProfile>(
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
  Future<List<CaseClarityUserProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseClarityUserProfileTable> where,
    _is.OrderByBuilder<CaseClarityUserProfileTable>? orderBy,
    _is.OrderByListBuilder<CaseClarityUserProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CaseClarityUserProfile>(
      where: where(CaseClarityUserProfile.t),
      orderBy: orderBy?.call(CaseClarityUserProfile.t),
      orderByList: orderByList?.call(CaseClarityUserProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseClarityUserProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CaseClarityUserProfile>(
      where: where?.call(CaseClarityUserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CaseClarityUserProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseClarityUserProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CaseClarityUserProfile>(
      where: where(CaseClarityUserProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
