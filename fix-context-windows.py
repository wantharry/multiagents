#!/usr/bin/env python3
"""
Update OpenClaw agent models to use larger context window variants
"""

import json
import os
from datetime import datetime

CONFIG_PATH = "/home/openclaw/.openclaw/openclaw.json"

# Backup the config
backup_path = f"{CONFIG_PATH}.backup-context-fix-{datetime.now().strftime('%Y%m%d-%H%M%S')}"

with open(CONFIG_PATH, 'r') as f:
    config = json.load(f)

# Save backup
with open(backup_path, 'w') as f:
    json.dump(config, f, indent=2)

print(f"Backed up config to: {backup_path}")

# Model mapping: old -> new (with larger context)
MODEL_UPDATES = {
    "ollama/llama3.1:8b": "ollama/llama3.1:8b-32k",
    "ollama/llama3.2:3b-fast": "ollama/llama3.2:3b-16k",
    "ollama/gpt-oss:20b": "ollama/gpt-oss:20b-32k"
}

# Update agent models
updated_count = 0
for agent in config.get("agents", {}).get("list", []):
    old_model = agent.get("model", "")
    if old_model in MODEL_UPDATES:
        new_model = MODEL_UPDATES[old_model]
        agent["model"] = new_model
        print(f"✅ Updated {agent['label']}: {old_model} → {new_model}")
        updated_count += 1

# Save updated config
with open(CONFIG_PATH, 'w') as f:
    json.dump(config, f, indent=2)

print(f"\n✅ Updated {updated_count} agent models with larger context windows")
print(f"✅ Configuration saved to: {CONFIG_PATH}")
print("\n📝 New models:")
print("  - llama3.1:8b-32k (32K context)")
print("  - llama3.2:3b-16k (16K context)")  
print("  - gpt-oss:20b-32k (32K context)")
print("\n🔄 Restart OpenClaw to apply changes:")
print("  openclaw stop && openclaw start")
