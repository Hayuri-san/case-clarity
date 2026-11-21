import 'dart:io';

import 'package:case_clarity_client/case_clarity_client.dart';

void main(List<String> args) async {
  if (args.length < 2 || args.length > 3) {
    stderr.writeln(
      'Usage: dart run tool/dev_setup.dart <citizen-email> <lawyer-email> [server-url]',
    );
    exitCode = 64;
    return;
  }

  final citizenEmail = args[0];
  final lawyerEmail = args[1];
  final serverUrl = args.length == 3 ? args[2] : 'http://localhost:8080/';
  final client = Client(serverUrl);
  try {
    final lawyer = await client.dev.promoteToLawyer(lawyerEmail);
    final legalCase = await client.dev.seedDemoData(citizenEmail, lawyerEmail);
    stdout.writeln('Promoted ${lawyer.fullName} to lawyer.');
    stdout.writeln('Seeded case ${legalCase.id}: ${legalCase.title}');
  } finally {
    client.close();
  }
}
