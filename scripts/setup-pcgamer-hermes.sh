#!/bin/bash
# setup-pcgamer-hermes.sh — Set up pcgamer Hermes instance as a test case
# This script configures a Hermes profile that uses the shared data on TrueNAS
# and the Telegram bot token stored in the Obsidian vault (also on TrueNAS)

TRUENAS_DIR="/mnt/public/AIS-OS"
OBSIDIAN_VAULT="/home/chuck/Documents/Obsidian Vault/Workspaces/Chuck"
HERMES_HOME="/home/chuck/.hermes"
PROFILE_NAME="pcgamer"

echo "🔧 Setting up pcgamer Hermes instance..."

# 1. Create profile directory if needed
PROFILE_DIR="$HERMES_HOME/profiles/$PROFILE_NAME"
if [ ! -d "$PROFILE_DIR" ]; then
  mkdir -p "$PROFILE_DIR"
  echo "   📁 Created profile directory: $PROFILE_DIR"
fi

# 2. Copy shared AIS-OS data to profile (symlink to TrueNAS source)
if [ ! -L "$PROFILE_DIR/AIS-OS" ]; then
  ln -sf "$TRUENAS_DIR" "$PROFILE_DIR/AIS-OS"
  echo "   🔗 Symlinked AIS-OS → TrueNAS shared repo"
else
  echo "   ✓ AIS-OS already linked to TrueNAS"
fi

# 3. Copy Telegram bot token from Obsidian vault to profile config
TOKEN_FILE="$OBSIDIAN_Vault/telegram-bot-token-pcgamer.md"
if [ -f "$TOKEN_FILE" ]; then
  # Extract the token
  TOKEN=$(grep -o '8798513629:[^`]*' "$TOKEN_FILE" | tr -d '`')
  CONFIG_FILE="$PROFILE_DIR/config.yaml"
  
  # Create Hermes config that references the token
  cat > "$CONFIG_FILE" << EOF
# pcgamer Hermes profile configuration
# Telegram bot token sourced from Obsidian vault on TrueNAS
model:
  provider: omniroute
  default: MoA-Free
  base_url: http://100.110.220.50:20128/v1
  api_key: "${TOKEN}"
  key_env: HERMES_CUSTOM_OMNIROUTE_API_KEY

providers:
  omniroute:
    name: omniroute
    base_url: http://pcgamer:20128/v1
    api_key: "${TOKEN}"
    discover_models: true

browser:
  allow_private_urls: true
  use_real_profile: true

tts:
  provider: fish
  providers:
    fish:
      api_key: sk-fis...YaEk
      command: python3 $HOME/.hermes/scripts/voicebox_tts.py --provider fish \
        --text-file {input_path} --out {output_path} --fish-label kitt
      output_format: wav
      provider_label: Fish Audio (hosted)

checkpoints:
  enabled: true

display:
  message_reactions: true

onboarding:
  seen:
    tool_progress_prompt: true

security:
  allow_private_urls: true
EOF
  echo "   📝 Created profile config with Telegram bot token"
else
  echo "   ⚠️  Token file not found at $TOKEN_FILE"
fi

# 4. Ensure profile can access shared data scripts
SCRIPTS_DIR="$PROFILE_DIR/scripts"
if [ ! -d "$SCRIPTS_DIR" ]; then
  mkdir -p "$SCRIPTS_DIR"
  # Copy shared scripts from AIS-OS
  cp /home/chuck/AIS-OS/scripts/load-shared-data.sh "$SCRIPTS_DIR/" 2>/dev/null || true
  cp /home/chuck/AIS-OS/scripts/sync-to-truenas.sh "$SCRIPTS_DIR/" 2>/dev/null || true
  echo "   📋 Copied shared scripts to profile"
else
  echo "   ✓ Scripts directory already exists"
fi

# 5. Create profile-specific onboard answers if needed
ONBOARD_ANSWERS="$PROFILE_DIR/onboard-answers.md"
if [ ! -f "$ONBOARD_ANSWERS" ]; then
  cat > "$ONBOARD_ANSWERS" << 'ONBOARD_EOF'
# pcgamer Hermes Onboard Answers (Test Case)

# Q1: Who are you?
I am a Hermes test instance used to verify multi-profile, multi-machine AIS-OS sync.

# Q2: What am I building?
Multiple AI autonomous workflow businesses through Hermes, Codex, jAntigravity, Groqbot.

# Q3: What's documented?
GitHub repos and Obsidian vault. I sell to subscribers interested in newsletters or paying customers.

# Q4: Revenue model?
Not collecting yet. Intend to use Stripe for collection and save to personal bank account.

# Q5: Email usage?
Gmail (chuckatbcs@gmail.com), Outlook (cblack2@outlook.com), Business (cbventures.co@gmail.com).

# Q6: Knowledge management?
Obsidian or email — Obsidian vault is primary (shared via TrueNAS).

# Q7: Friction points?
Getting AI tools to work reliably. Building tool capabilities.

ONBOARD_EOF
  echo "   📝 Created onboard answers file"
fi

echo ""
echo "✅ pcgamer Hermes instance setup complete!"
echo "   Profile: $PROFILE_NAME"
echo "   Data source: TrueNAS ($TRUENAS_DIR)"
echo "   Bot token: Obsidian vault ($OBSIDIAN_VAULT/telegram-bot-token-pcgamer.md)"
echo "   All harnesses can access via: /home/chuck/.hermes/profiles/$PROFILE_NAME"
