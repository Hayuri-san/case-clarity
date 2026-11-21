import 'package:serverpod/serverpod.dart';

import '../generated/case_type.dart';
import '../generated/legal_guide.dart';

const legalGuideDisclaimer = 'General information, not legal advice.';

final _defaultGuides = <LegalGuide>[
  LegalGuide(
    slug: 'cheque-bounce',
    title: 'Cheque bounce',
    caseType: CaseType.chequeBounce,
    summary: 'A practical checklist for a cheque returned unpaid.',
    steps: [
      'Keep the cheque, bank return memo, and records of the payment owed.',
      'Confirm the cheque date and any shorter validity written on it.',
      'Send a written demand notice within 30 days after learning from the bank that the cheque was dishonoured.',
      'Keep proof of delivery. The drawer has 15 days after receiving the notice to pay.',
      'If payment is not made, ask a lawyer promptly about the complaint deadline and court process.',
    ],
    relevantSections: [
      'Negotiable Instruments Act, 1881, Sections 138 and 142',
    ],
    disclaimer: legalGuideDisclaimer,
    sortOrder: 1,
  ),
  LegalGuide(
    slug: 'consumer-complaint',
    title: 'Consumer complaint',
    caseType: CaseType.consumerComplaint,
    summary: 'Steps to organize a complaint about goods or services.',
    steps: [
      'Save invoices, warranty papers, messages, and proof of payment.',
      'Write to the seller or service provider and clearly state the problem and requested remedy.',
      'Keep copies of the complaint and any reply.',
      'If the issue remains unresolved, check the correct Consumer Commission and filing process or seek legal help.',
    ],
    relevantSections: [
      'Consumer Protection Act, 2019, Sections 2(7) and 35',
    ],
    disclaimer: legalGuideDisclaimer,
    sortOrder: 2,
  ),
  LegalGuide(
    slug: 'cyber-fraud',
    title: 'Cyber fraud',
    caseType: CaseType.cyberFraud,
    summary: 'Actions to take quickly after an online financial fraud.',
    steps: [
      'Contact your bank or payment provider immediately and ask them to block or trace the transaction.',
      'For financial cyber fraud in India, call 1930 as soon as possible.',
      'File a report at the National Cyber Crime Reporting Portal and save the acknowledgement.',
      'Keep transaction IDs, messages, phone numbers, URLs, and screenshots; do not delete original records.',
      'Do not share OTPs, passwords, or remote-access codes with anyone claiming they can recover money.',
    ],
    relevantSections: [
      'National Cyber Crime Reporting Portal',
      'Information Technology Act, 2000 (where applicable)',
    ],
    disclaimer: legalGuideDisclaimer,
    sortOrder: 3,
  ),
];

/// Inserts or refreshes the three built-in guides without creating duplicates.
Future<void> seedLegalGuides(Session session) async {
  for (final guide in _defaultGuides) {
    final existing = await LegalGuide.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(guide.slug),
    );
    if (existing == null) {
      await LegalGuide.db.insertRow(session, guide);
    } else {
      await LegalGuide.db.updateRow(session, guide.copyWith(id: existing.id));
    }
  }
}
