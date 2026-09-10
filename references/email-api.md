# Email API Reference — cbventures.co@gmail.com

**Account:** cbventures  
**Provider:** Gmail (App Password)  
**Mechanism:** Himalaya CLI (IMAP/SMTP)

## Account config

```
Location: ~/.config/himalaya/config.toml
Account name: cbventures
```

## Common commands

### Read inbox
```bash
himalaya -a cbventures envelope list --page-size 10
```

### Search
```bash
himalaya -a cbventures envelope list from sender@example.com subject "meeting"
```

### Read a message
```bash
himalaya -a cbventures message read 357
```

### Reply (pipe via stdin)
```bash
himalaya -a cbventures template reply 357 | sed 's/^$/Your reply\n/' | himalaya -a cbventures template send
```

### Compose new
```bash
cat << 'EOF' | himalaya -a cbventures message write
From: Chuck Blackmon <cbventures.co@gmail.com>
To: recipient@example.com
Subject: Test
Body text here
EOF
```

### Move/copy/delete
```bash
himalaya -a cbventures message move "Archive" 357
himalaya -a cbventures message copy "Important" 357
himalaya -a cbventures message delete 357
```

### Attachments
```bash
himalaya -a cbventures attachment download 357
```

## Folders

| Alias | Gmail folder |
|-------|-------------|
| inbox | INBOX |
| sent | [Gmail]/Sent Mail |
| drafts | [Gmail]/Drafts |
| trash | [Gmail]/Trash |

## Auth

- Gmail App Password (16 chars, no spaces)
- Stored in config as `imap.sasl.plain.password.raw` and `smtp.sasl.plain.password.raw`
- Last verified: 2026-09-08
