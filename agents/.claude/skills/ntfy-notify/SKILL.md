---
name: ntfy-notify
description: Use when the user says "notify me", "send me a notification", "ping me", "alert me", or "let me know" — sends a push notification to the user's ntfy topic via the ntfy.sh service.
---

# ntfy Notify

Send a push notification to the user's ntfy topic.

## Topic

`agents_42b81lsjfehya0jl` at `https://ntfy.sh`

## How to Send

Compose a clear, concise message from the context of what the user asked to be notified about, then run:

```bash
curl -s \
  -H "Title: Claude Code" \
  -d "YOUR MESSAGE HERE" \
  https://ntfy.sh/agents_42b81lsjfehya0jl
```

Use `-H "Priority: high"` for urgent notifications. Add `-H "Tags: white_check_mark"` for success, `-H "Tags: warning"` for errors.

## Message Guidelines

- One sentence, plain English
- State what happened or what's ready
- No jargon or internal variable names

## Example

User says: "notify me when the build finishes"

```bash
curl -s \
  -H "Title: Claude Code" \
  -H "Tags: white_check_mark" \
  -d "Build finished successfully." \
  https://ntfy.sh/agents_42b81lsjfehya0jl
```

After sending, confirm to the user that the notification was sent.
