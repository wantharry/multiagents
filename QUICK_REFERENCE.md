# OpenClaw Multi-Agent App Builder - Quick Reference

## 🚀 Quick Start

### Send a Message to Telegram
```
create an app for task management
```

### The Master agent will:
1. Parse your request
2. Spawn Planner → Get project plan
3. Spawn Architect → Design architecture
4. Spawn DevOps → Setup environment
5. Loop: Developer → Tester → Committer (for each task)
6. Send "done" when complete

## 📋 Agents Overview

| Agent | Role | Model | Speed |
|-------|------|-------|-------|
| **master** | Orchestrator, coordinates all agents | llama3.1:8b | Standard |
| **planner** | Creates project plans | llama3.1:8b | Standard |
| **architect** | Designs architecture | llama3.1:8b | Standard |
| **devops** | Sets up environment | llama3.2:3b-fast | Fast |
| **developer** | Writes code | llama3.1:8b | Standard |
| **tester** | Tests code | llama3.2:3b-fast | Fast |
| **committer** | Git commits | llama3.2:3b-fast | Fast |

## 📂 Important Paths

```bash
# Configuration
/home/openclaw/.openclaw/openclaw.json

# Agent Workspaces
/home/openclaw/.openclaw/workspace-master/
/home/openclaw/.openclaw/workspace-planner/
# ... (one for each agent)

# Generated Projects
/home/openclaw/projects/

# Logs
/tmp/openclaw/openclaw-*.log
```

## 🛠️ Useful Commands

```bash
# Check agents
wsl ~/.local/bin/openclaw agents list --bindings

# Check gateway
wsl ~/.local/bin/openclaw gateway status

# Check Telegram
wsl ~/.local/bin/openclaw channels status

# View logs (live)
wsl tail -f /tmp/openclaw/openclaw-*.log

# Check Ollama models
wsl curl http://127.0.0.1:11434/api/tags

# List generated projects
wsl ls -la /home/openclaw/projects/
```

## 💬 Telegram Updates You'll See

```
🎯 Starting project: Task Manager App
📋 Planning phase complete. Moving to architecture...
🏗️ Architecture design complete. Setting up environment...
⚙️ Environment setup complete. Starting development...
🔨 Development progress: 3/10 tasks completed
✅ Testing passed for task: Create API endpoints
⚠️ Error in task 5: Missing dependency. Retrying with larger model...
✅ done - Task Manager App ready at /home/openclaw/projects/task-manager-app
```

## 📊 Project Structure (Example)

After completion, each project will have:

```
/home/openclaw/projects/task-manager-app/
├── PROJECT_STATE.json      # Status tracking
├── PLAN.md                 # Project plan
├── ARCHITECTURE.md         # Architecture doc
├── ENVIRONMENT.md          # Setup details
├── PROGRESS.md             # Progress log
├── src/                    # Source code
│   ├── models/
│   ├── routes/
│   ├── controllers/
│   └── server.js
├── tests/                  # Tests
├── package.json (or requirements.txt)
├── README.md
└── .git/                   # Git repository
```

## 🔧 Troubleshooting Quick Fixes

### Bot not responding?
```bash
wsl ~/.local/bin/openclaw gateway status
wsl ~/.local/bin/openclaw channels status
```

### Check Ollama is running:
```bash
wsl curl http://127.0.0.1:11434/api/tags
```

### View recent errors:
```bash
wsl tail -50 /tmp/openclaw/openclaw-*.log | grep -i error
```

## 🎯 Example Requests

### Simple Apps
- "create a hello world API"
- "create a note-taking app"
- "create a calculator CLI"

### Medium Complexity
- "create a todo app with REST API"
- "create a task management system"
- "create a blog backend with SQLite"

### More Complex
- "create a full-stack task manager with user authentication"
- "create an expense tracker with categories and reports"

## ⚡ Model Selection (Automatic)

The Master agent automatically chooses:

- **llama3.2:3b-fast**: DevOps, testing, commits (fast tasks)
- **llama3.1:8b**: Planning, architecture, development (standard)
- **gpt-oss:20b**: Complex problems, retries (when needed)

## 🔄 Typical Workflow Timeline

1. **Planning**: ~30-60 seconds
2. **Architecture**: ~30-60 seconds
3. **DevOps Setup**: ~15-30 seconds
4. **Per Task**:
   - Development: ~60-120 seconds
   - Testing: ~30-60 seconds
   - Commit: ~5-10 seconds
5. **Total** (for 5-task project): ~5-10 minutes

## ✅ Current Status

- ✅ All 7 agents configured
- ✅ Telegram → Master routing active
- ✅ Gateway running (127.0.0.1:18789)
- ✅ Telegram bot polling
- ✅ Ollama models ready
- ✅ Project directory created

## 🎉 You're Ready!

Send a message to your Telegram bot and watch your multi-agent system build an app! 

---

**For detailed docs**: See [SETUP_COMPLETE.md](./SETUP_COMPLETE.md)
