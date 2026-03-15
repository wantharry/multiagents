#!/usr/bin/env python3
"""
Fix OpenClaw context window issue by:
1. Adding new models with larger context windows
2. Updating agent configurations to use them 
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

# Add new models to models.providers.ollama.models
new_models = [
    {
        "id": "llama3.1:8b-32k",
        "name": "llama3.1:8b-32k",
        "input": ["text"],
        "cost": {
            "input": 0,
            "output": 0,
            "cacheRead": 0,
            "cacheWrite": 0
        },
        "contextWindow": 32768,
        "maxTokens": 327680
    },
    {
        "id": "llama3.2:3b-16k",
        "name": "llama3.2:3b-16k",
        "input": ["text"],
        "cost": {
            "input": 0,
            "output": 0,
            "cacheRead": 0,
            "cacheWrite": 0
        },
        "contextWindow": 16384,
        "maxTokens": 163840
    },
    {
        "id": "gpt-oss:20b-32k",
        "name": "gpt-oss:20b-32k",
        "input": ["text"],
        "cost": {
            "input": 0,
            "output": 0,
            "cacheRead": 0,
            "cacheWrite": 0
        },
        "contextWindow": 32768,
        "maxTokens": 327680
    }
]

# Add models to config
ollama_models = config.get("models", {}).get("providers", {}).get("ollama", {}).get("models", [])

# Remove old models and add new ones
model_ids_to_replace = ["llama3.1:8b", "llama3.2:3b-fast", "gpt-oss:20b"]
config["models"]["providers"]["ollama"]["models"] = [
    m for m in ollama_models if m["id"] not in model_ids_to_replace
] + new_models

print(f"✅ Added 3 new models with larger context windows")

# Update agent model references
model_updates = {
    "ollama/llama3.1:8b": "ollama/llama3.1:8b-32k",
    "ollama/llama3.2:3b-fast": "ollama/llama3.2:3b-16k",
    "ollama/gpt-oss:20b": "ollama/gpt-oss:20b-32k"
}

# Update agents.list
updated_count = 0
for agent in config.get("agents", {}).get("list", []):
    old_model = agent.get("model", "")
    if isinstance(old_model, str) and old_model in model_updates:
        agent["model"] = model_updates[old_model]
        print(f"✅ Updated {agent.get('label', agent.get('id'))}: {old_model} → {agent['model']}")
        updated_count += 1

# Update agents.defaults.model.primary
if "agents" in config and "defaults" in config["agents"]:
    defaults = config["agents"]["defaults"]
    if "model" in defaults and isinstance(defaults["model"], dict):
        old_primary = defaults["model"].get("primary", "")
        if old_primary in model_updates:
            defaults["model"]["primary"] = model_updates[old_primary]
            print(f"✅ Updated default primary model: {old_primary} → {defaults['model']['primary']}")
        
        # Update fallbacks
        if "fallbacks" in defaults["model"]:
            new_fallbacks = []
            for fb in defaults["model"]["fallbacks"]:
                if fb in model_updates:
                    new_fallbacks.append(model_updates[fb])
                    print(f"✅ Updated fallback: {fb} → {model_updates[fb]}")
                else:
                    new_fallbacks.append(fb)
            defaults["model"]["fallbacks"] = new_fallbacks

# Update agents.defaults.models dictionary
if "agents" in config and "defaults" in config["agents"] and "models" in config["agents"]["defaults"]:
    defaults_models = config["agents"]["defaults"]["models"]
    for old_key, new_key in model_updates.items():
        if old_key in defaults_models:
            defaults_models[new_key] = defaults_models.pop(old_key)
            print(f"✅ Updated defaults.models: {old_key} → {new_key}")

# Save updated config
with open(CONFIG_PATH, 'w') as f:
    json.dump(config, f, indent=2)

print(f"\n✅ Configuration updated successfully!")
print(f"✅ Updated {updated_count} agent model assignments")
print(f"\n📝 New models with larger context:")
print(f"  - llama3.1:8b-32k (32K context, was 4K)")
print(f"  - llama3.2:3b-16k (16K context, was 4K)")
print(f"  - gpt-oss:20b-32k (32K context, was 8K)")
print(f"\n🔄 Restart OpenClaw to apply changes:")
print(f"  ~/.local/bin/openclaw stop")
print(f"  ~/.local/bin/openclaw start")
