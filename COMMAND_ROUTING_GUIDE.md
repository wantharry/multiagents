# Command Routing System - User Guide

## Overview

Your OpenClaw multi-agent system now supports **command-based routing** with two main workflows:

1. **App Building** - Coordinates 6 specialized agents to build complete applications
2. **Code Analysis** - Uses the Analyzer agent to review code quality, security, and performance

The Master agent automatically detects your intent and routes to the appropriate workflow.

---

## How to Use via Telegram

### App Building Commands

Use any of these formats to trigger app building:

**Explicit Commands:**
```
/makeapp simple calculator with GUI
/build todo list with REST API
/create note-taking app with tags
```

**Natural Language:**
```
create an app for task management
build me a weather dashboard
make a simple blog platform
```

The Master agent will:
1. Create a project directory in `/home/openclaw/projects/`
2. Spawn Planner → get project plan
3. Spawn Architect → design system architecture
4. Spawn DevOps → verify environment
5. Loop through tasks: Developer → Tester → Committer
6. Report "done ✅" when complete

---

### Code Analysis Commands

Use these formats to trigger code analysis:

**Explicit Commands:**
```
/analysis full /home/openclaw/projects/my-app
/analysis security /home/openclaw/projects/todo-app
/analysis performance /home/openclaw/projects/calculator
/analysis quality /home/openclaw/projects/blog
```

**Natural Language:**
```
analyze my todo app
check code quality in calculator project
review my blog app for security issues
scan task-management-app for bugs
```

The Master agent will:
1. Parse your request to extract analysis type and target path
2. Spawn Analyzer agent with specific instructions
3. Wait for comprehensive analysis report
4. Send formatted summary to Telegram

**Analysis Types:**
- `security` - Check for vulnerabilities, hardcoded secrets, injection risks
- `performance` - Identify bottlenecks, inefficient code, resource issues
- `quality` - Review code style, maintainability, documentation
- `full` - Complete analysis covering all aspects (default)

---

### Help Command

```
/help
```

Displays available commands and usage examples.

---

## Example Workflows

### Example 1: Build a Task Management App

**You send to Telegram:**
```
/makeapp task management app with user authentication
```

**Master agent does:**
```
📋 Planning complete... (1/6)
🏗️ Architecture designed... (2/6)
🔧 Environment ready... (3/6)
💻 Developing features... (4/6)
✅ Testing passed... (5/6)
📝 Changes committed... (6/6)
done ✅

Project: task-management-app
Location: /home/openclaw/projects/task-management-app/
```

---

### Example 2: Analyze Existing Project

**You send to Telegram:**
```
/analysis security /home/openclaw/projects/task-management-app
```

**Master agent does:**
```
🔍 Starting security analysis on task-management-app...
⏳ Analyzing... (this may take a few minutes)

🔍 Analysis Complete: task-management-app

🔴 Critical Issues: 2
🟡 Warnings: 5
🔵 Info: 8

Top Issues:
1. SQL injection vulnerability in database.py:45
2. Hardcoded API key in config.py:12

Top Warnings:
1. Missing input validation in api/routes.py:78
2. Weak password hashing in auth.py:23
3. No rate limiting on API endpoints

Full report: /home/openclaw/projects/task-management-app/ANALYSIS_REPORT.md
```

---

### Example 3: Build Then Analyze

**Step 1 - Build:**
```
create a simple blog platform
```

**Wait for "done ✅"**

**Step 2 - Analyze:**
```
/analysis quality /home/openclaw/projects/simple-blog-platform
```

---

## Behind the Scenes: Agent Architecture

### Master Agent (Your Router)

- **Role**: Intelligent routing and orchestration
- **Model**: llama3.1:8b (can switch to 3b-fast or 20b based on complexity)
- **Workflow**: 
  1. Detect intent from message (app building vs analysis vs help)
  2. Route to appropriate workflow
  3. Coordinate specialized agents
  4. Track progress and report status

### App Building Agents (6 agents)

1. **Planner** - Creates detailed project plan
   - Model: llama3.1:8b
   - Output: PLAN.md

2. **Architect** - Designs system architecture
   - Model: llama3.1:8b
   - Output: ARCHITECTURE.md

3. **DevOps** - Verifies/sets up environment
   - Model: llama3.2:3b-fast (speed optimized)
   - Output: ENVIRONMENT.md

4. **Developer** - Implements features
   - Model: llama3.1:8b
   - Output: Source code in src/

5. **Tester** - Validates implementations
   - Model: llama3.2:3b-fast
   - Output: PASS/FAIL reports

6. **Committer** - Creates git commits
   - Model: llama3.2:3b-fast
   - Output: Clean commit history

### Analysis Agent (1 agent)

7. **Analyzer** - Code quality, security, performance analysis
   - Model: llama3.1:8b
   - Output: ANALYSIS_REPORT.md

---

## Project Structure

After building an app, you'll find:

```
/home/openclaw/projects/<project-name>/
├── PLAN.md                  # Project plan from Planner
├── ARCHITECTURE.md          # System design from Architect
├── ENVIRONMENT.md           # Environment setup from DevOps
├── PROJECT_STATE.json       # Progress tracking (Master)
├── src/                     # Source code from Developer
│   ├── main.py
│   ├── api/
│   └── ...
├── tests/                   # Tests created by Developer
└── ANALYSIS_REPORT.md       # Analysis report (if you run /analysis)
```

---

## Advanced Usage

### Specify Project Location

If you want to analyze a specific project:
```
/analysis full /path/to/your/project
```

### Combine Analysis Types

Currently, you specify one type per command. To get multiple analyses, run multiple commands:
```
/analysis security /home/openclaw/projects/my-app
/analysis performance /home/openclaw/projects/my-app
```

Or use `full` for comprehensive analysis:
```
/analysis full /home/openclaw/projects/my-app
```

---

## Troubleshooting

### "Project not found" error

Make sure you use the full path:
```
/analysis full /home/openclaw/projects/task-management-app
```

NOT:
```
/analysis full task-management-app
```

### Agent takes too long

The Master agent automatically switches to faster models (llama3.2:3b-fast) for simple tasks or larger models (gpt-oss:20b) for complex tasks if performance is slow.

### Want to re-build a project

Delete the old project directory first:
```
rm -rf /home/openclaw/projects/old-project-name
```

Then send a new `/makeapp` command.

---

## Command Reference

### App Building

| Command | Description | Example |
|---------|-------------|---------|
| `/makeapp <desc>` | Build a complete app | `/makeapp todo list` |
| `/build <desc>` | Same as /makeapp | `/build calculator` |
| `/create <desc>` | Same as /makeapp | `/create blog` |
| Natural language | No command needed | `create a task manager` |

### Code Analysis

| Command | Description | Example |
|---------|-------------|---------|
| `/analysis full <path>` | Complete analysis | `/analysis full /home/openclaw/projects/app` |
| `/analysis security <path>` | Security scan | `/analysis security /home/openclaw/projects/app` |
| `/analysis performance <path>` | Performance check | `/analysis performance /home/openclaw/projects/app` |
| `/analysis quality <path>` | Code quality review | `/analysis quality /home/openclaw/projects/app` |
| Natural language | Understands intent | `analyze my todo app` |

### Help

| Command | Description |
|---------|-------------|
| `/help` | Show all commands |

---

## System Status

To check if OpenClaw is running:
```bash
~/.local/bin/openclaw status
```

To view configured agents:
```bash
~/.local/bin/openclaw agents list
```

To restart OpenClaw (if needed):
```bash
~/.local/bin/openclaw stop
~/.local/bin/openclaw start
```

---

## Next Steps

1. **Test app building**: Send `/makeapp simple calculator` to Telegram
2. **Wait for completion**: Master will report "done ✅"
3. **Test analysis**: Send `/analysis full /home/openclaw/projects/simple-calculator`
4. **Review results**: Check the project directory for all generated files

---

## Questions?

All commands flow through the **Master agent**, which intelligently routes your request:
- App building requests → Coordinates Planner, Architect, DevOps, Developer, Tester, Committer
- Analysis requests → Spawns Analyzer agent
- Help requests → Responds directly with command list

Your multi-agent system is ready to build and analyze applications! 🚀
