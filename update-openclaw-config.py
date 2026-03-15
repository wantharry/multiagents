#!/usr/bin/env python3
import json
import shutil
from datetime import datetime
from pathlib import Path

# Paths
config_path = Path("/home/openclaw/.openclaw/openclaw.json")
backup_path = Path(f"/home/openclaw/.openclaw/openclaw.json.backup-{datetime.now().strftime('%Y%m%d-%H%M%S')}")

# Backup existing config
shutil.copy(config_path, backup_path)
print(f"Backed up config to: {backup_path}")

# Load existing config
with open(config_path, 'r') as f:
    config = json.load(f)

# Define agents
agents_list = [
    {
        "id": "master",
        "name": "Master Orchestrator",
        "workspace": "~/.openclaw/workspace-master",
        "agentDir": "~/.openclaw/agents/master/agent",
        "model": {
            "primary": "ollama/llama3.1:8b",
            "fallbacks": ["ollama/gpt-oss:20b"]
        },
        "default": True
    },
    {
        "id": "planner",
        "name": "Planner",
        "workspace": "~/.openclaw/workspace-planner",
        "agentDir": "~/.openclaw/agents/planner/agent",
        "model": {
            "primary": "ollama/llama3.1:8b"
        }
    },
    {
        "id": "architect",
        "name": "Architect",
        "workspace": "~/.openclaw/workspace-architect",
        "agentDir": "~/.openclaw/agents/architect/agent",
        "model": {
            "primary": "ollama/llama3.1:8b"
        }
    },
    {
        "id": "devops",
        "name": "DevOps",
        "workspace": "~/.openclaw/workspace-devops",
        "agentDir": "~/.openclaw/agents/devops/agent",
        "model": {
            "primary": "ollama/llama3.2:3b-fast"
        }
    },
    {
        "id": "developer",
        "name": "Developer",
        "workspace": "~/.openclaw/workspace-developer",
        "agentDir": "~/.openclaw/agents/developer/agent",
        "model": {
            "primary": "ollama/llama3.1:8b"
        }
    },
    {
        "id": "tester",
        "name": "Tester",
        "workspace": "~/.openclaw/workspace-tester",
        "agentDir": "~/.openclaw/agents/tester/agent",
        "model": {
            "primary": "ollama/llama3.2:3b-fast"
        }
    },
    {
        "id": "committer",
        "name": "Committer",
        "workspace": "~/.openclaw/workspace-committer",
        "agentDir": "~/.openclaw/agents/committer/agent",
        "model": {
            "primary": "ollama/llama3.2:3b-fast"
        }
    }
]

# Define bindings - Route Telegram to Master agent
bindings = [
    {
        "agentId": "master",
        "match": {
            "channel": "telegram"
        }
    }
]

# Update config
if "agents" not in config:
    config["agents"] = {}

config["agents"]["list"] = agents_list

if "bindings" not in config:
    config["bindings"] = []

# Add bindings if not already present
for binding in bindings:
    if binding not in config["bindings"]:
        config["bindings"].append(binding)

# Enable sessions tools for inter-agent communication
if "tools" not in config:
    config["tools"] = {}

# Ensure sessions tools are available
if "sessions" not in config["tools"]:
    config["tools"]["sessions"] = {}

config["tools"]["sessions"]["visibility"] = "tree"  # Allow spawned agents to see parent

# Create projects directory
import subprocess
subprocess.run(["mkdir", "-p", "/home/openclaw/projects"], check=False)

# Write updated config
with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)

print("✅ OpenClaw configuration updated successfully!")
print(f"✅ Added {len(agents_list)} agents")
print(f"✅ Added {len(bindings)} bindings")
print("✅ Created /home/openclaw/projects directory")
print("\nAgents configured:")
for agent in agents_list:
    print(f"  - {agent['id']}: {agent['name']} (model: {agent['model']['primary']})")

print("\nBindings configured:")
for binding in bindings:
    print(f"  - Channel '{binding['match']['channel']}' → Agent '{binding['agentId']}'")

print("\n🚀 Next steps:")
print("1. Restart OpenClaw gateway: wsl openclaw gateway restart")
print("2. Check agent status: wsl openclaw agents list")
print("3. Send a test message via Telegram")
