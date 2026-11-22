# Case Clarity API

Endpoint documentation for the Flutter app and local development tools.

All endpoints under `profile`, `cases`, and `caseUpdate` require an authenticated
user with a Case Clarity profile. The server reads the caller's ID from
Serverpod authentication. Clients cannot choose profile roles.

`cases.createCase` auto-assigns the earliest-created lawyer profile only in
development. Set `DEMO_AUTO_ASSIGN=false` in the server environment to disable
that behavior.

| Endpoint | Parameters | Return type | Who may call | Errors |
|---|---|---|---|---|
| `profile.getMyProfile` | none | `CaseClarityUserProfile?` | Any signed-in user | Authentication required |
| `profile.createOrUpdateMyProfile` | `fullName: String` | `CaseClarityUserProfile` | Any signed-in user | Authentication required; full name must be 1–120 characters |
| `cases.createCase` | `title: String`, `caseType: CaseType`, `description: String` | `LegalCase` | Citizen | Authentication/profile required; title must be 1–120 characters; description at most 2000 characters |
| `cases.listMyCases` | none | `List<LegalCase>` | Citizen (created cases) or lawyer (assigned cases) | Authentication/profile required |
| `cases.getCase` | `id: int` | `LegalCase` | Case's creating citizen or assigned lawyer | `Case not found or access denied.` for missing or inaccessible cases |
| `cases.updateCaseInfo` | `id: int`, `title: String`, `description: String` | `LegalCase` | Creating citizen only | `Case not found or access denied.` for missing or non-creator; title and description limits as above. Stage and assignment are not changed |
| `caseUpdate.addUpdate` | `caseId: int`, `title: String`, `description: String` | `CaseUpdate` | The case's assigned lawyer | Authentication/profile required; inaccessible cases return `Case not found or access denied.`; title and description limits as above |
| `caseUpdate.changeStage` | `caseId: int`, `stage: CaseStage` | `LegalCase` | The case's assigned lawyer | Authentication/profile required; inaccessible cases return `Case not found or access denied.`; writes a `stageChange` update entry |
| `caseUpdate.listUpdates` | `caseId: int` | `List<CaseUpdate>` (oldest first) | Case's creating citizen or assigned lawyer | Authentication/profile required; inaccessible cases return `Case not found or access denied.` |
| `legalGuide.listGuides` | none | `List<LegalGuide>` sorted by `sortOrder` | Any signed-in user | Authentication required |
| `legalGuide.getGuide` | `slug: String` | `LegalGuide` | Any signed-in user | Authentication required; `Guide not found.` |
| `deadline.calculateSection138` | `chequeDate: DateTime`, `chequePresentedDate: DateTime`, `dishonourIntimationDate: DateTime`, optional `chequeValidityDate`, `noticeSentDate`, `noticeReceivedDate` | `Section138DeadlineResult` (`items`, `assumptions`, `disclaimer`) | Any signed-in user | Authentication required; dates must be UTC midnight and in event order |
| `document.startUpload` | `caseId: int`, `fileName: String`, `mimeType: String`, `sizeBytes: int` | `DocumentUploadTicket` (`documentId`, `uploadDescription`) | Case's creating citizen | Authentication required; file must be PDF/JPG/PNG and no more than 5 MiB; case access uses `Case not found or access denied.` |
| `document.finishUpload` | `documentId: int` | `CaseDocument` (initially `processing`) | Uploading citizen | Authentication required; verifies upload, size, and magic bytes; same generic case error for unavailable documents |
| `document.listDocuments` | `caseId: int` | `List<CaseDocument>` (newest first) | Case's creating citizen or assigned lawyer | Authentication required; unavailable cases use `Case not found or access denied.` |
| `document.getDocument` | `id: int` | `CaseDocument` (includes extracted text and suggested dates) | Case's creating citizen or assigned lawyer | Authentication required; `Case not found or access denied.` for missing or inaccessible documents |
| `greeting.hello` | `name: String` | `Greeting` (`message`, `author`, `timestamp`) | Any caller | Standard Serverpod request errors may apply |

`deadline.calculateSection138` returns date-only UTC deadlines for cheque
presentation, demand notice, the 15-day payment period, and complaint filing.
The server supplies today's date; clients supply only confirmed event dates.
An optional shorter cheque validity date can lower the presentation deadline.
The day of each triggering event is excluded from day counts, month additions
clamp to month end, and `dueSoon` means today through the next seven days.
Missing notice receipt leaves the payment and complaint deadlines
`notYetComputable`. If no notice-sent date is supplied, the 30-day deadline is
still shown and its basis notes that no notice is recorded. Results include
the assumptions and disclaimer in the typed return value.

Legal guide content is informational. The cheque guide points readers to the
Negotiable Instruments Act, 1881, Sections 138 and 142; statutory periods and
court interpretations can depend on the facts, so users should confirm dates
with a lawyer.

Documents use Serverpod's private storage. Uploads are limited by
`maxDocumentSizeBytes` (5 MiB) and `maxRequestSize` is set to the same size in
each run-mode config so local database-backed uploads are accepted. The server
checks the stored file size and PDF/JPG/PNG magic bytes before accepting it.
OCR uses the offline `MockOcrProvider`; `finishUpload` queues background work
and returns while the document is `processing`. Clients can poll
`document.getDocument` for `completed` or `failed`. Candidate dates are
suggestions for the citizen to confirm. `storagePath` is server-only and
document text is never logged.

## Which call does each screen use

| Screen | Calls |
|---|---|
| Sign-in | `EmailOtpSignInWidget(client: client)` for the email code flow; call `client.auth.initialize()` at app startup and observe `client.auth.authInfoListenable`. |
| Profile | `profile.getMyProfile`; submit the name with `profile.createOrUpdateMyProfile(fullName)`. |
| Home dashboard | `cases.listMyCases`; the returned cases are limited to cases created by the citizen or assigned to the lawyer. |
| Guides | `legalGuide.listGuides`; open a guide with `legalGuide.getGuide(slug)`. |
| Create case | `cases.createCase(title, caseType, description)`. |
| My cases | `cases.listMyCases`. |
| Case detail | `cases.getCase(id)`; citizen edits use `cases.updateCaseInfo(id, title, description)`. |
| Timeline | `caseUpdate.listUpdates(caseId)`; the server returns oldest first. |
| Upload document | `document.startUpload(caseId, fileName, mimeType, sizeBytes)`, then upload bytes using the returned Serverpod upload description, then `document.finishUpload(documentId)`. |
| Poll document | Poll `document.getDocument(id)` until `ocrStatus` is `completed` or `failed`; `document.listDocuments(caseId)` lists case documents. |
| Deadline calculator | `deadline.calculateSection138(...)` with citizen-confirmed dates; keep the returned assumptions and disclaimer visible. |
| Lawyer dashboard | `cases.listMyCases`; open a case with `cases.getCase(id)` and its documents with `document.listDocuments(caseId)`. |
| Change stage | `caseUpdate.changeStage(caseId, stage)`. |
| Post update | `caseUpdate.addUpdate(caseId, title, description)`. |

The auth module owns the sign-in request and response types; do not implement a
separate email or token flow in the app. The widget is provided by
`serverpod_auth_idp_flutter`.

## Local development only

`dev.promoteToLawyer(email)` returns a `CaseClarityUserProfile`. It promotes the
signed-up account matching the email. `dev.seedDemoData(citizenEmail,
lawyerEmail)` returns a `LegalCase`, creates the citizen profile if needed, and
adds a sample case with two updates. Both methods refuse calls unless the
server run mode is `development`.

Run the helper from `case_clarity_server` with:

```powershell
dart run tool/dev_setup.dart <citizen-email> <lawyer-email> [server-url]
```

The default server URL is `http://localhost:8080/`; pass the API URL printed by
the runner if it selected another port. These development endpoints and the
`tool/dev_setup.dart` script must be disabled or removed before deployment.
