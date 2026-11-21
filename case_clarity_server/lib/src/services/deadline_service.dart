import '../generated/deadline_item.dart';
import '../generated/deadline_status.dart';
import '../generated/section138_deadline_result.dart';

const section138Disclaimer =
    'Calculated from the dates you confirmed; not legal advice; courts can condone delay; confirm with a lawyer.';

DateTime _dateOnly(DateTime date) => DateTime.utc(date.year, date.month, date.day);

void _requireDateOnlyUtc(DateTime date, String name) {
  if (!date.isUtc || date.hour != 0 || date.minute != 0 || date.second != 0 ||
      date.millisecond != 0 || date.microsecond != 0) {
    throw ArgumentError('$name must be a UTC date at midnight.');
  }
}

DateTime addCalendarDays(DateTime date, int days) {
  _requireDateOnlyUtc(date, 'date');
  return _dateOnly(date).add(Duration(days: days));
}

/// Adds whole calendar months, clamping an unavailable day to month end.
DateTime addMonthsClamped(DateTime date, int months) {
  _requireDateOnlyUtc(date, 'date');
  final source = _dateOnly(date);
  final zeroBasedMonth = source.month - 1 + months;
  final year = source.year + zeroBasedMonth ~/ 12;
  final month = zeroBasedMonth % 12 + 1;
  final lastDay = DateTime.utc(year, month + 1, 0).day;
  return DateTime.utc(year, month, source.day.clamp(1, lastDay).toInt());
}

DateTime chequePresentationDeadline(
  DateTime chequeDate, {
  DateTime? chequeValidityDate,
}) {
  _requireDateOnlyUtc(chequeDate, 'chequeDate');
  if (chequeValidityDate != null) {
    _requireDateOnlyUtc(chequeValidityDate, 'chequeValidityDate');
  }
  final threeMonthDeadline = addMonthsClamped(chequeDate, 3);
  if (chequeValidityDate == null ||
      !chequeValidityDate.isBefore(threeMonthDeadline)) {
    return threeMonthDeadline;
  }
  return _dateOnly(chequeValidityDate);
}

DateTime dishonourNoticeDeadline(DateTime dishonourIntimationDate) =>
    addCalendarDays(dishonourIntimationDate, 30);

DateTime paymentDeadlineAfterNoticeReceipt(DateTime noticeReceivedDate) =>
    addCalendarDays(noticeReceivedDate, 15);

DateTime complaintFilingDeadlineAfterPaymentWindow(
  DateTime paymentDeadline,
) {
  final calendarMonthDeadline = addMonthsClamped(paymentDeadline, 1);
  final thirtyDayDeadline = addCalendarDays(paymentDeadline, 30);
  return calendarMonthDeadline.isBefore(thirtyDayDeadline)
      ? calendarMonthDeadline
      : thirtyDayDeadline;
}

DeadlineStatus deadlineStatus(DateTime today, DateTime dueDate) {
  _requireDateOnlyUtc(today, 'today');
  _requireDateOnlyUtc(dueDate, 'dueDate');
  final remainingDays = _dateOnly(dueDate).difference(_dateOnly(today)).inDays;
  if (remainingDays < 0) return DeadlineStatus.passed;
  if (remainingDays <= 7) return DeadlineStatus.dueSoon;
  return DeadlineStatus.upcoming;
}

void _validateDateOrder({
  required DateTime chequeDate,
  required DateTime chequePresentedDate,
  required DateTime dishonourIntimationDate,
  DateTime? chequeValidityDate,
  DateTime? noticeSentDate,
  DateTime? noticeReceivedDate,
}) {
  final dates = <(String, DateTime)>[
    ('chequeDate', chequeDate),
    ('chequePresentedDate', chequePresentedDate),
    ('dishonourIntimationDate', dishonourIntimationDate),
    if (noticeSentDate != null) ('noticeSentDate', noticeSentDate),
    if (noticeReceivedDate != null) ('noticeReceivedDate', noticeReceivedDate),
  ];
  for (final (name, date) in dates) {
    _requireDateOnlyUtc(date, name);
  }
  if (chequeValidityDate != null) {
    _requireDateOnlyUtc(chequeValidityDate, 'chequeValidityDate');
    if (chequeValidityDate.isBefore(chequeDate)) {
      throw ArgumentError('chequeValidityDate must be on or after chequeDate.');
    }
  }
  for (var i = 1; i < dates.length; i++) {
    if (dates[i].$2.isBefore(dates[i - 1].$2)) {
      throw ArgumentError(
        '${dates[i].$1} must be on or after ${dates[i - 1].$1}.',
      );
    }
  }
}

Section138DeadlineResult calculateSection138Deadlines({
  required DateTime today,
  required DateTime chequeDate,
  required DateTime chequePresentedDate,
  required DateTime dishonourIntimationDate,
  DateTime? chequeValidityDate,
  DateTime? noticeSentDate,
  DateTime? noticeReceivedDate,
}) {
  _requireDateOnlyUtc(today, 'today');
  _validateDateOrder(
    chequeDate: chequeDate,
    chequePresentedDate: chequePresentedDate,
    dishonourIntimationDate: dishonourIntimationDate,
    chequeValidityDate: chequeValidityDate,
    noticeSentDate: noticeSentDate,
    noticeReceivedDate: noticeReceivedDate,
  );

  final presentationDeadline = chequePresentationDeadline(
    chequeDate,
    chequeValidityDate: chequeValidityDate,
  );
  final noticeDeadline = dishonourNoticeDeadline(dishonourIntimationDate);
  final presentationOutcome = chequePresentedDate.isAfter(presentationDeadline)
      ? 'Cheque was presented after this deadline.'
      : 'Cheque was presented on or before this deadline.';
  final noticeRecord = noticeSentDate == null
      ? ' No notice-sent date has been recorded.'
      : noticeSentDate.isAfter(noticeDeadline)
      ? ' The recorded notice-sent date is after the deadline.'
      : ' The recorded notice-sent date is on or before the deadline.';

  final items = <DeadlineItem>[
    DeadlineItem(
      label: 'Present cheque',
      dueDate: presentationDeadline,
      basis: 'Within three calendar months from the cheque date, or earlier validity if supplied. $presentationOutcome',
      status: deadlineStatus(today, presentationDeadline),
    ),
    DeadlineItem(
      label: 'Send demand notice',
      dueDate: noticeDeadline,
      basis: 'Within 30 days after dishonour information from the bank.$noticeRecord',
      status: deadlineStatus(today, noticeDeadline),
    ),
  ];

  if (noticeReceivedDate == null) {
    items.addAll([
      DeadlineItem(
        label: 'Drawer payment period ends',
        dueDate: null,
        basis: 'Cannot calculate until the notice receipt date is confirmed.',
        status: DeadlineStatus.notYetComputable,
      ),
      DeadlineItem(
        label: 'Complaint filing deadline',
        dueDate: null,
        basis: 'Cannot calculate until the notice receipt date and resulting payment deadline are known.',
        status: DeadlineStatus.notYetComputable,
      ),
    ]);
  } else {
    final paymentDeadline = paymentDeadlineAfterNoticeReceipt(noticeReceivedDate);
    final complaintDeadline = complaintFilingDeadlineAfterPaymentWindow(
      paymentDeadline,
    );
    items.addAll([
      DeadlineItem(
        label: 'Drawer payment period ends',
        dueDate: paymentDeadline,
        basis: '15 days after receipt of the demand notice; receipt day is excluded.',
        status: deadlineStatus(today, paymentDeadline),
      ),
      DeadlineItem(
        label: 'Complaint filing deadline',
        dueDate: complaintDeadline,
        basis: 'One month after the 15-day payment period ends, using the earlier of a calendar month and 30 days.',
        status: deadlineStatus(today, complaintDeadline),
      ),
    ]);
  }

  return Section138DeadlineResult(
    items: items,
    assumptions: [
      'The dates are user-confirmed UTC calendar dates. The triggering day is excluded from each day count.',
      if (chequeValidityDate == null)
        'No shorter cheque validity date was supplied; confirm the cheque validity with the bank or a lawyer.',
      'Calendar-month deadlines clamp to the last day of the target month. The complaint limit uses the earlier of a calendar month or 30 days.',
      'Status is based on today: dueSoon means the deadline is today or within the next seven calendar days.',
    ],
    disclaimer: section138Disclaimer,
  );
}
