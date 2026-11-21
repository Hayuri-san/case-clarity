# Case Clarity API

Endpoint documentation for the Flutter app.

| Endpoint | Params | Returns | Allowed roles | Errors |
|---|---|---|---|---|
| `greeting.hello` | `name: String` | `Greeting` (`message`, `author`, `timestamp`) | Any caller; no role check | No endpoint-specific errors; standard Serverpod request errors may apply |
