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
import 'document_ocr_status.dart' as _igofstph;

abstract class CaseDocument
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CaseDocument._({
    this.id,
    required this.caseId,
    required this.uploaderId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.storagePath,
    _igofstph.DocumentOcrStatus? ocrStatus,
    this.extractedText,
    this.candidateDates,
    this.errorMessage,
    DateTime? createdAt,
  }) : ocrStatus = ocrStatus ?? _igofstph.DocumentOcrStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory CaseDocument({
    int? id,
    required int caseId,
    required _is.UuidValue uploaderId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? storagePath,
    _igofstph.DocumentOcrStatus? ocrStatus,
    String? extractedText,
    List<String>? candidateDates,
    String? errorMessage,
    DateTime? createdAt,
  }) = _CaseDocumentImpl;

  factory CaseDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return CaseDocument(
      id: jsonSerialization['id'] as int?,
      caseId: jsonSerialization['caseId'] as int,
      uploaderId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['uploaderId'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      storagePath: jsonSerialization['storagePath'] as String?,
      ocrStatus: jsonSerialization['ocrStatus'] == null
          ? null
          : _igofstph.DocumentOcrStatus.fromJson(
              (jsonSerialization['ocrStatus'] as String),
            ),
      extractedText: jsonSerialization['extractedText'] as String?,
      candidateDates: jsonSerialization['candidateDates'] == null
          ? null
          : _i794f3qj.Protocol().deserialize<List<String>>(
              jsonSerialization['candidateDates'],
            ),
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = CaseDocumentTable();

  static const db = CaseDocumentRepository._();

  @override
  int? id;

  int caseId;

  _is.UuidValue uploaderId;

  String fileName;

  String mimeType;

  int sizeBytes;

  String? storagePath;

  _igofstph.DocumentOcrStatus ocrStatus;

  String? extractedText;

  List<String>? candidateDates;

  String? errorMessage;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CaseDocument]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CaseDocument copyWith({
    int? id,
    int? caseId,
    _is.UuidValue? uploaderId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? storagePath,
    _igofstph.DocumentOcrStatus? ocrStatus,
    String? extractedText,
    List<String>? candidateDates = const _is.$UndefinedList<String>(),
    String? errorMessage,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CaseDocument',
      if (id != null) 'id': id,
      'caseId': caseId,
      'uploaderId': uploaderId.toJson(),
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (storagePath != null) 'storagePath': storagePath,
      'ocrStatus': ocrStatus.toJson(),
      if (extractedText != null) 'extractedText': extractedText,
      if (candidateDates != null) 'candidateDates': candidateDates?.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CaseDocument',
      if (id != null) 'id': id,
      'caseId': caseId,
      'uploaderId': uploaderId.toJson(),
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'ocrStatus': ocrStatus.toJson(),
      if (extractedText != null) 'extractedText': extractedText,
      if (candidateDates != null) 'candidateDates': candidateDates?.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
    };
  }

  static CaseDocumentInclude include() {
    return CaseDocumentInclude._();
  }

  static CaseDocumentIncludeList includeList({
    _is.WhereExpressionBuilder<CaseDocumentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseDocumentTable>? orderBy,
    _is.OrderByListBuilder<CaseDocumentTable>? orderByList,
    CaseDocumentInclude? include,
  }) {
    return CaseDocumentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseDocument.t),
      orderByList: orderByList?.call(CaseDocument.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CaseDocumentImpl extends CaseDocument {
  _CaseDocumentImpl({
    int? id,
    required int caseId,
    required _is.UuidValue uploaderId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? storagePath,
    _igofstph.DocumentOcrStatus? ocrStatus,
    String? extractedText,
    List<String>? candidateDates,
    String? errorMessage,
    DateTime? createdAt,
  }) : super._(
         id: id,
         caseId: caseId,
         uploaderId: uploaderId,
         fileName: fileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         storagePath: storagePath,
         ocrStatus: ocrStatus,
         extractedText: extractedText,
         candidateDates: candidateDates,
         errorMessage: errorMessage,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CaseDocument]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CaseDocument copyWith({
    Object? id = _Undefined,
    int? caseId,
    _is.UuidValue? uploaderId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    Object? storagePath = _Undefined,
    _igofstph.DocumentOcrStatus? ocrStatus,
    Object? extractedText = _Undefined,
    List<String>? candidateDates = const _is.$UndefinedList<String>(),
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
  }) {
    return CaseDocument(
      id: id is int? ? id : this.id,
      caseId: caseId ?? this.caseId,
      uploaderId: uploaderId ?? this.uploaderId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      storagePath: storagePath is String? ? storagePath : this.storagePath,
      ocrStatus: ocrStatus ?? this.ocrStatus,
      extractedText: extractedText is String?
          ? extractedText
          : this.extractedText,
      candidateDates: candidateDates is _is.UndefinedSentinel
          ? this.candidateDates?.map((e0) => e0).toList()
          : candidateDates,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CaseDocumentUpdateTable extends _is.UpdateTable<CaseDocumentTable> {
  CaseDocumentUpdateTable(super.table);

  _is.ColumnValue<int, int> caseId(int value) => _is.ColumnValue(
    table.caseId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uploaderId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uploaderId,
    value,
  );

  _is.ColumnValue<String, String> fileName(String value) => _is.ColumnValue(
    table.fileName,
    value,
  );

  _is.ColumnValue<String, String> mimeType(String value) => _is.ColumnValue(
    table.mimeType,
    value,
  );

  _is.ColumnValue<int, int> sizeBytes(int value) => _is.ColumnValue(
    table.sizeBytes,
    value,
  );

  _is.ColumnValue<String, String> storagePath(String? value) => _is.ColumnValue(
    table.storagePath,
    value,
  );

  _is.ColumnValue<_igofstph.DocumentOcrStatus, _igofstph.DocumentOcrStatus>
  ocrStatus(_igofstph.DocumentOcrStatus value) => _is.ColumnValue(
    table.ocrStatus,
    value,
  );

  _is.ColumnValue<String, String> extractedText(String? value) =>
      _is.ColumnValue(
        table.extractedText,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> candidateDates(
    List<String>? value,
  ) => _is.ColumnValue(
    table.candidateDates,
    value,
  );

  _is.ColumnValue<String, String> errorMessage(String? value) =>
      _is.ColumnValue(
        table.errorMessage,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CaseDocumentTable extends _is.Table<int?> {
  CaseDocumentTable({super.tableRelation}) : super(tableName: 'case_document') {
    updateTable = CaseDocumentUpdateTable(this);
    caseId = _is.ColumnInt(
      'caseId',
      this,
    );
    uploaderId = _is.ColumnUuid(
      'uploaderId',
      this,
    );
    fileName = _is.ColumnString(
      'fileName',
      this,
    );
    mimeType = _is.ColumnString(
      'mimeType',
      this,
    );
    sizeBytes = _is.ColumnInt(
      'sizeBytes',
      this,
    );
    storagePath = _is.ColumnString(
      'storagePath',
      this,
    );
    ocrStatus = _is.ColumnEnum(
      'ocrStatus',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    extractedText = _is.ColumnString(
      'extractedText',
      this,
    );
    candidateDates = _is.ColumnSerializable<List<String>>(
      'candidateDates',
      this,
    );
    errorMessage = _is.ColumnString(
      'errorMessage',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final CaseDocumentUpdateTable updateTable;

  late final _is.ColumnInt caseId;

  late final _is.ColumnUuid uploaderId;

  late final _is.ColumnString fileName;

  late final _is.ColumnString mimeType;

  late final _is.ColumnInt sizeBytes;

  late final _is.ColumnString storagePath;

  late final _is.ColumnEnum<_igofstph.DocumentOcrStatus> ocrStatus;

  late final _is.ColumnString extractedText;

  late final _is.ColumnSerializable<List<String>> candidateDates;

  late final _is.ColumnString errorMessage;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    caseId,
    uploaderId,
    fileName,
    mimeType,
    sizeBytes,
    storagePath,
    ocrStatus,
    extractedText,
    candidateDates,
    errorMessage,
    createdAt,
  ];
}

class CaseDocumentInclude extends _is.IncludeObject {
  CaseDocumentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CaseDocument.t;
}

class CaseDocumentIncludeList extends _is.IncludeList {
  CaseDocumentIncludeList._({
    _is.WhereExpressionBuilder<CaseDocumentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CaseDocument.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CaseDocument.t;
}

class CaseDocumentRepository {
  const CaseDocumentRepository._();

  /// Returns a list of [CaseDocument]s matching the given query parameters.
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
  Future<List<CaseDocument>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseDocumentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseDocumentTable>? orderBy,
    _is.OrderByListBuilder<CaseDocumentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CaseDocument>(
      where: where?.call(CaseDocument.t),
      orderBy: orderBy?.call(CaseDocument.t),
      orderByList: orderByList?.call(CaseDocument.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CaseDocument]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CaseDocument.t`.
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
  _ida.Stream<List<CaseDocument>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseDocumentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseDocumentTable>? orderBy,
    _is.OrderByListBuilder<CaseDocumentTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CaseDocument>(
      where: where?.call(CaseDocument.t),
      orderBy: orderBy?.call(CaseDocument.t),
      orderByList: orderByList?.call(CaseDocument.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CaseDocument] matching the given query parameters.
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
  Future<CaseDocument?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseDocumentTable>? where,
    int? offset,
    _is.OrderByBuilder<CaseDocumentTable>? orderBy,
    _is.OrderByListBuilder<CaseDocumentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CaseDocument>(
      where: where?.call(CaseDocument.t),
      orderBy: orderBy?.call(CaseDocument.t),
      orderByList: orderByList?.call(CaseDocument.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CaseDocument] by its [id] or null if no such row exists.
  Future<CaseDocument?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CaseDocument>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CaseDocument]s in the list and returns the inserted rows.
  ///
  /// The returned [CaseDocument]s will have their `id` fields set.
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
  Future<List<CaseDocument>> insert(
    _is.DatabaseSession session,
    List<CaseDocument> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CaseDocument>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CaseDocument] and returns the inserted row.
  ///
  /// The returned [CaseDocument] will have its `id` field set.
  Future<CaseDocument> insertRow(
    _is.DatabaseSession session,
    CaseDocument row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CaseDocument>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CaseDocument]s in the list and returns the resulting rows.
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
  /// The returned [CaseDocument]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseDocument>> upsert(
    _is.DatabaseSession session,
    List<CaseDocument> rows, {
    required _is.ColumnSelections<CaseDocumentTable> conflictColumns,
    _is.ColumnSelections<CaseDocumentTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseDocumentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CaseDocument>(
      rows,
      conflictColumns: conflictColumns(CaseDocument.t),
      updateColumns: updateColumns?.call(CaseDocument.t),
      updateWhere: updateWhere?.call(CaseDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CaseDocument] and returns the resulting row.
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
  /// The returned [CaseDocument] will have its `id` field set.
  Future<CaseDocument?> upsertRow(
    _is.DatabaseSession session,
    CaseDocument row, {
    required _is.ColumnSelections<CaseDocumentTable> conflictColumns,
    _is.ColumnSelections<CaseDocumentTable>? updateColumns,
    _is.WhereExpressionBuilder<CaseDocumentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CaseDocument>(
      row,
      conflictColumns: conflictColumns(CaseDocument.t),
      updateColumns: updateColumns?.call(CaseDocument.t),
      updateWhere: updateWhere?.call(CaseDocument.t),
      transaction: transaction,
    );
  }

  /// Updates all [CaseDocument]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseDocument>> update(
    _is.DatabaseSession session,
    List<CaseDocument> rows, {
    _is.ColumnSelections<CaseDocumentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CaseDocument>(
      rows,
      columns: columns?.call(CaseDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CaseDocument]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CaseDocument> updateRow(
    _is.DatabaseSession session,
    CaseDocument row, {
    _is.ColumnSelections<CaseDocumentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CaseDocument>(
      row,
      columns: columns?.call(CaseDocument.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CaseDocument] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CaseDocument?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CaseDocumentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CaseDocument>(
      id,
      columnValues: columnValues(CaseDocument.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CaseDocument]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CaseDocument>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CaseDocumentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CaseDocumentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CaseDocumentTable>? orderBy,
    _is.OrderByListBuilder<CaseDocumentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CaseDocument>(
      columnValues: columnValues(CaseDocument.t.updateTable),
      where: where(CaseDocument.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CaseDocument.t),
      orderByList: orderByList?.call(CaseDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CaseDocument]s in the list and returns the deleted rows.
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
  Future<List<CaseDocument>> delete(
    _is.DatabaseSession session,
    List<CaseDocument> rows, {
    _is.OrderByBuilder<CaseDocumentTable>? orderBy,
    _is.OrderByListBuilder<CaseDocumentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CaseDocument>(
      rows,
      orderBy: orderBy?.call(CaseDocument.t),
      orderByList: orderByList?.call(CaseDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CaseDocument].
  Future<CaseDocument> deleteRow(
    _is.DatabaseSession session,
    CaseDocument row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CaseDocument>(
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
  Future<List<CaseDocument>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseDocumentTable> where,
    _is.OrderByBuilder<CaseDocumentTable>? orderBy,
    _is.OrderByListBuilder<CaseDocumentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CaseDocument>(
      where: where(CaseDocument.t),
      orderBy: orderBy?.call(CaseDocument.t),
      orderByList: orderByList?.call(CaseDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CaseDocumentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CaseDocument>(
      where: where?.call(CaseDocument.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CaseDocument] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CaseDocumentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CaseDocument>(
      where: where(CaseDocument.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
