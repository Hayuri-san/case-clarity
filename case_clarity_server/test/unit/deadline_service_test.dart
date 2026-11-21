import 'package:case_clarity_server/src/generated/deadline_status.dart';
import 'package:case_clarity_server/src/services/deadline_service.dart';
import 'package:test/test.dart';

DateTime day(int year, int month, int date) => DateTime.utc(year, month, date);

void main() {
  group('Section 138 deterministic deadlines', () {
    test('dishonour notice deadline is exactly 30 days after intimation', () {
      final due = dishonourNoticeDeadline(day(2025, 1, 1));
      expect(due, day(2025, 1, 31));
      expect(deadlineStatus(day(2025, 1, 30), due), DeadlineStatus.dueSoon);
      expect(deadlineStatus(due, due), DeadlineStatus.dueSoon);
      expect(deadlineStatus(day(2025, 2, 1), due), DeadlineStatus.passed);
    });

    test('15 days excludes notice receipt day', () {
      expect(
        paymentDeadlineAfterNoticeReceipt(day(2025, 1, 1)),
        day(2025, 1, 16),
      );
    });

    test('calendar month addition clamps month end and leap years', () {
      expect(addMonthsClamped(day(2023, 1, 31), 1), day(2023, 2, 28));
      expect(addMonthsClamped(day(2024, 1, 31), 1), day(2024, 2, 29));
      expect(addMonthsClamped(day(2024, 2, 29), 12), day(2025, 2, 28));
      expect(addMonthsClamped(day(2024, 11, 30), 3), day(2025, 2, 28));
    });

    test('cheque presentation uses an earlier confirmed validity date', () {
      expect(
        chequePresentationDeadline(
          day(2025, 1, 15),
          chequeValidityDate: day(2025, 2, 10),
        ),
        day(2025, 2, 10),
      );
      expect(
        chequePresentationDeadline(day(2025, 1, 31)),
        day(2025, 4, 30),
      );
    });

    test('missing notice receipt leaves payment and filing deadlines unknown', () {
      final result = calculateSection138Deadlines(
        today: day(2025, 1, 1),
        chequeDate: day(2024, 12, 1),
        chequePresentedDate: day(2024, 12, 2),
        dishonourIntimationDate: day(2024, 12, 3),
      );
      expect(result.items[1].dueDate, day(2025, 1, 2));
      expect(result.items[1].basis, contains('No notice-sent date'));
      expect(result.items[2].status, DeadlineStatus.notYetComputable);
      expect(result.items[2].dueDate, isNull);
      expect(result.items[3].status, DeadlineStatus.notYetComputable);
      expect(result.disclaimer, section138Disclaimer);
    });

    test('complaint deadline clamps month end after payment window', () {
      final paymentEnds = paymentDeadlineAfterNoticeReceipt(day(2025, 1, 17));
      expect(paymentEnds, day(2025, 2, 1));
      expect(
        complaintFilingDeadlineAfterPaymentWindow(paymentEnds),
        day(2025, 3, 1),
      );
      expect(
        complaintFilingDeadlineAfterPaymentWindow(day(2025, 1, 31)),
        day(2025, 2, 28),
      );
      expect(
        complaintFilingDeadlineAfterPaymentWindow(day(2025, 3, 1)),
        day(2025, 3, 31),
      );
    });

    test('dates out of order and non-UTC date values are rejected clearly', () {
      expect(
        () => calculateSection138Deadlines(
          today: day(2025, 1, 1),
          chequeDate: day(2025, 1, 2),
          chequePresentedDate: day(2025, 1, 1),
          dishonourIntimationDate: day(2025, 1, 3),
        ),
        throwsA(isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          contains('chequePresentedDate must be on or after chequeDate'),
        )),
      );
      expect(
        () => calculateSection138Deadlines(
          today: DateTime(2025, 1, 1),
          chequeDate: day(2024, 12, 1),
          chequePresentedDate: day(2024, 12, 2),
          dishonourIntimationDate: day(2024, 12, 3),
        ),
        throwsA(isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          contains('today must be a UTC date at midnight'),
        )),
      );
    });
  });
}
