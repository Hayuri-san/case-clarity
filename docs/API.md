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
| `greeting.hello` | `name: String` | `Greeting` (`message`, `author`, `timestamp`) | Any caller | Standard Serverpod request errors may apply |

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
