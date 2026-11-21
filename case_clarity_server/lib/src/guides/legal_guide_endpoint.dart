import 'package:serverpod/serverpod.dart';

import '../generated/legal_guide.dart';
import '../services/authorization.dart';

class LegalGuideEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<LegalGuide>> listGuides(Session session) async {
    Authorization.requireSignedInUserId(session);
    return LegalGuide.db.find(
      session,
      orderByList: (t) => [t.sortOrder.asc(), t.slug.asc()],
    );
  }

  Future<LegalGuide> getGuide(Session session, String slug) async {
    Authorization.requireSignedInUserId(session);
    final normalizedSlug = slug.trim();
    final guide = await LegalGuide.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(normalizedSlug),
    );
    if (guide == null) throw Exception('Guide not found.');
    return guide;
  }
}
