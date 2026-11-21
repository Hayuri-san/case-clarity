import 'package:serverpod/serverpod.dart';

import '../generated/section138_deadline_result.dart';
import '../services/authorization.dart';
import '../services/deadline_service.dart';

class DeadlineEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Section138DeadlineResult> calculateSection138(
    Session session, {
    required DateTime chequeDate,
    required DateTime chequePresentedDate,
    required DateTime dishonourIntimationDate,
    DateTime? chequeValidityDate,
    DateTime? noticeSentDate,
    DateTime? noticeReceivedDate,
  }) async {
    Authorization.requireSignedInUserId(session);
    final now = DateTime.now().toUtc();
    return calculateSection138Deadlines(
      today: DateTime.utc(now.year, now.month, now.day),
      chequeDate: chequeDate,
      chequePresentedDate: chequePresentedDate,
      dishonourIntimationDate: dishonourIntimationDate,
      chequeValidityDate: chequeValidityDate,
      noticeSentDate: noticeSentDate,
      noticeReceivedDate: noticeReceivedDate,
    );
  }
}
