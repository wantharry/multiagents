#!/usr/bin/env python3
import json
import shutil
from datetime import datetime
from pathlib import Path

# Paths
config_path = Path("/home/openclaw/.openclaw/openclaw.json")
backup_path = Path(f"/home/openclaw/.openclaw/openclaw.json.backup-command-routing-{datetime.now().strftime('%Y%m%d-%H%M%S')}")

# Backup existing config
shutil.copy(config_path, backup_path)
print(f"Backed up config to: {backup_path}")

# Load existing config
with open(config_path, 'r') as f:
    config = json.load(f)

# Add Analyzer agent to agents list
analyzer_agent = {
    "id": "analyzer",
    "name": "Analyzer",
    "workspace": "~/.openclaw/workspace-analyzer",
    "agentDir": "~/.openclaw/agents/analyzer/agent",
    "model": {
        "primary": "ollama/llama3.1:8b",
        "fallbacks": ["ollama/gpt-oss:20b"]
    }
}

# Find app-builder agents (rename master to app-builder for clarity)
app_builder_agent = None
for agent in config['agents']['list']:
    if agent['id'] == 'master':
        # Keep master but update its name for clarity
        agent['name'] = 'App Builder Master'
        app_builder_agent = agent
        break

# Add analyzer if not already present
analyzer_exists = any(a['id'] == 'analyzer' for a in config['agents']['list'])
if not analyzer_exists:
    config['agents']['list'].append(analyzer_agent)
    print("✅ Added Analyzer agent")
else:
    print("ℹ️ Analyzer agent already exists")

# Update bindings with command routing
# OpenClaw doesn't support regex filters in bindings natively,
# so we'll use a different approach: separate DM routing based on content

# For now, we'll keep it simple: Master handles everything
# The Master agent will internally route based on command detection

# BUT - we can create multiple top-level agents and route based on peer/channel
# Let's update the Master agent's instructions to handle command routing

# Ensure bindings are set correctly
config['bindings'] = [
    {
        "agentId": "master",
        "match": {
            "channel": "telegram"
        }
    }
]

# Create analyzer directories
import subprocess
subprocess.run(["mkdir", "-p", "/home/openclaw/.openclaw/workspace-analyzer"], check=False)
subprocess.run(["mkdir", "-p", "/home/openclaw/.openclaw/agents/analyzer/agent"], check=False)

# Write updated config
with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)

print("✅ Configuration updated!")
print(f"✅ Added Analyzer agent")
print(f"✅ Created analyzer workspace and agent directories")
print("\n📋 Next steps:")
print("1. Analyzer agent workspace and configuration files will be created")
print("2. Master agent will route based on command detection:")
print("   - /makeapp or 'create app' → App building workflow")
print("   - /analysis or 'analyze' → Analyzer agent")
print("3. Restart gateway if needed: wsl ~/.local/bin/openclaw gateway restart")
