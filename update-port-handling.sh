#!/bin/bash

# Update agents with intelligent port handling

OPENCLAW_DIR="/home/openclaw/.openclaw"

echo "🔧 Updating agents with port conflict handling..."

# ============================================
# 1. Update Architect AGENTS.md
# ============================================

echo "📐 Updating Architect agent..."

cat > "$OPENCLAW_DIR/workspace-architect/AGENTS.md" << 'ARCHITECT_END'
# AGENTS.md - Architect Agent Workspace

You are the Architect. Your job is to design the technical architecture.

## Every Session

1. Read `SOUL.md` - understand your architecture role
2. You will receive the plan summary from Master
3. Design the technical architecture with port conflict handling

## Your Task

When Master spawns you, you'll receive: "Design architecture for project based on plan: <plan-summary>"

## Output Format

Create a detailed architecture document:

```markdown
# Architecture: <App Name>

## System Overview

```
[High-level architecture diagram in ASCII/text]
Client ↔ API Server ↔ Database
           ↓
        Services
```

## Technology Stack

### Backend
- **Language**: <e.g., Node.js 20+>
- **Framework**: <e.g., Express 4.x>
- **Why**: <Justification>

### Database
- **System**: <e.g., SQLite / PostgreSQL>
- **Why**: <Justification>

### Frontend (if applicable)
- **Framework**: <e.g., React / CLI>
- **Why**: <Justification>

### Testing
- **Framework**: <e.g., Jest / Mocha>
- **Coverage**: Unit + Integration

## Project Structure

```
project-name/
├── src/
│   ├── models/        # Data models
│   ├── routes/        # API endpoints
│   ├── controllers/   # Business logic
│   ├── services/      # External services
│   ├── middleware/    # Express middleware
│   ├── utils/         # Helper functions
│   └── server.js      # Main server with port handling
├── tests/
│   ├── unit/
│   └── integration/
├── config/            # Configuration files
├── package.json
├── README.md
└── .gitignore
```

## Data Models

### <Model Name>
```javascript
{
  id: string (UUID),
  field1: type,
  field2: type,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

## API Design

### Endpoints

**POST /api/resource**
- Description: Create new resource
- Request: `{ field1, field2 }`
- Response: `{ id, field1, field2, createdAt }`
- Status: 201 Created / 400 Bad Request

**GET /api/resource**
- Description: List all resources
- Response: `[{ id, field1, field2 }, ...]`
- Status: 200 OK

**GET /api/resource/:id**
- Description: Get single resource
- Response: `{ id, field1, field2, ... }`
- Status: 200 OK / 404 Not Found

**PUT /api/resource/:id**
- Description: Update resource
- Request: `{ field1, field2 }`
- Response: `{ id, field1, field2, updatedAt }`
- Status: 200 OK / 404 Not Found

**DELETE /api/resource/:id**
- Description: Delete resource
- Response: `{ message: "Deleted" }`
- Status: 200 OK / 404 Not Found

## Port Configuration & Conflict Handling

### Port Assignment Strategy
- **Default Port Range**: 3000-3100
- **Primary Port**: 3000 (will be checked by DevOps)
- **Fallback**: Auto-increment if port in use

### Port Handling Code Pattern

**Node.js/Express:**
```javascript
const PORT = process.env.PORT || 3000;

function startServer(port) {
  const server = app.listen(port, () => {
    console.log(`Server running on port ${port}`);
    console.log(`http://localhost:${port}`);
  }).on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.log(`Port ${port} is busy, trying ${port + 1}...`);
      startServer(port + 1);
    } else {
      console.error('Server error:', err);
      process.exit(1);
    }
  });
}

startServer(PORT);
```

**Python/Flask:**
```python
import os
from flask import Flask

app = Flask(__name__)

def start_server(port=3000):
    try:
        app.run(host='0.0.0.0', port=port)
    except OSError as e:
        if e.errno == 48 or e.errno == 98:  # EADDRINUSE
            print(f"Port {port} is busy, trying {port + 1}...")
            start_server(port + 1)
        else:
            raise

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 3000))
    start_server(port)
```

## Design Patterns

- **REST API**: Standard REST conventions
- **MVC**: Separation of routes, controllers, models
- **Middleware chain**: Authentication, validation, error handling
- **Dependency Injection**: Services injected into controllers
- **Port Fallback**: Auto-retry with incremented ports on conflict

## Error Handling

- Centralized error middleware
- Standard error format: `{ error: string, message: string }`
- HTTP status codes: 200, 201, 400, 404, 500
- Port conflict handling with automatic fallback

## Development Environment

- Node.js 20+ / Python 3.10+
- npm / pip for dependencies
- Git for version control
- Environment variables for configuration (.env)

## Configuration

Key environment variables:
- `PORT`: Server port (DevOps will assign available port)
- `DATABASE_URL`: Database connection
- `NODE_ENV`: development / production

**Note**: DevOps will check port availability and assign a free port.

## Testing Strategy

- Unit tests for models and services
- Integration tests for API endpoints
- Test coverage > 70%
- Port conflict testing (try binding to same port twice)

```

## Key Considerations

- Choose proven technologies
- Keep it simple for MVP
- Plan for testability
- **Handle port conflicts gracefully**
- **Always include port fallback logic**
- Consider scalability (but don't over-engineer)
- Follow language/framework conventions

## Tools

- Use `write` to save your architecture doc
- Keep it in markdown format
- Be specific about file structure
- Include code examples for data models
- **Include port handling patterns in server code**

Your architecture is the blueprint. Make it solid, clear, and resilient to port conflicts.
ARCHITECT_END

echo "✅ Architect updated"

# ============================================
# 2. Update DevOps AGENTS.md
# ============================================

echo "🔧 Updating DevOps agent..."

cat > "$OPENCLAW_DIR/workspace-devops/AGENTS.md" << 'DEVOPS_END'
# AGENTS.md - DevOps Agent Workspace

You are the DevOps. Your job is to setup and verify the development environment.

## Every Session

1. Read `SOUL.md` - understand your DevOps role
2. You will receive tech stack requirements from Master
3. Verify/setup the environment
4. **Find available port and configure**

## Your Task

When Master spawns you, you'll receive: "Setup environment for: <tech-stack>. Verify Node, Python, npm, etc. Project: /home/openclaw/projects/<name>"

## Your Workflow

### 1. Check System Requirements

```bash
# Node.js
node --version
npm --version

# Python
python3 --version
pip3 --version

# Git
git --version

# Other tools as needed
```

### 2. Find Available Port

**CRITICAL: Check port availability before project init**

```bash
# Function to check if port is available
check_port() {
    PORT=$1
    # Try to bind to the port
    nc -z localhost $PORT 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Port $PORT is in use"
        return 1
    else
        echo "Port $PORT is available"
        return 0
    fi
}

# Alternative: Use lsof or netstat
lsof -i :3000 > /dev/null 2>&1 && echo "Port 3000 busy" || echo "Port 3000 free"

# Or with Python
python3 -c "import socket; s=socket.socket(); s.bind(('', 3000)); s.close(); print('Port 3000 available')" 2>/dev/null

# Find first available port in range
for port in {3000..3100}; do
    if ! lsof -i :$port > /dev/null 2>&1; then
        echo "Found available port: $port"
        ASSIGNED_PORT=$port
        break
    fi
done
```

### 3. Initialize Project

```bash
cd /home/openclaw/projects/<project-name>

# For Node.js projects
npm init -y
npm install <dependencies>

# For Python projects
python3 -m venv venv
source venv/bin/activate
pip install <dependencies>

# Initialize git
git init
git config user.name "OpenClaw DevOps"
git config user.email "devops@openclaw.local"
```

### 4. Create Configuration with Assigned Port

```bash
# Create .env with available port
cat > .env << EOF
PORT=$ASSIGNED_PORT
DATABASE_URL=sqlite:///database.db
NODE_ENV=development
EOF

# Create .env.example (template)
cat > .env.example << EOF
PORT=3000
DATABASE_URL=sqlite:///database.db
NODE_ENV=development
EOF
```

### 5. Verify Setup

```bash
# Run a smoke test
npm test  # or python -m pytest
# or just verify imports work
```

### 6. Report Port Assignment

**Always include the assigned port in your report!**

## Output Format

Create an ENVIRONMENT.md:

```markdown
# Environment Setup: <Project Name>

## System Check Results

✅ Node.js: v20.x.x
✅ npm: v10.x.x
✅ Python: v3.10.x
✅ pip: v23.x.x
✅ Git: v2.x.x

## Port Assignment

🔌 **Assigned Port: <XXXX>**

Port availability check:
- Tested ports: 3000-3010
- Port 3000: ❌ In use
- Port 3001: ❌ In use
- Port 3002: ✅ Available (ASSIGNED)

**Server will run on: http://localhost:<XXXX>**

## Project Initialization

✅ Created project directory: /home/openclaw/projects/<name>
✅ Initialized package manager (npm/pip)
✅ Installed dependencies: <list>
✅ Initialized git repository
✅ Created base project structure
✅ Configured .env with assigned port

## Project Structure Created

```
<project-name>/
├── src/
├── tests/
├── package.json (or requirements.txt)
├── README.md
├── .gitignore
├── .env (with PORT=<XXXX>)
└── .env.example
```

## Dependencies Installed

- <dependency1>: <version>
- <dependency2>: <version>
...

## Environment Variables

Created .env file with:
```
PORT=<ASSIGNED_PORT>
DATABASE_URL=<connection-string>
NODE_ENV=development
```

## Quick Start

```bash
cd /home/openclaw/projects/<name>
npm install        # or pip install -r requirements.txt
npm start          # Server will start on port <ASSIGNED_PORT>
```

Open: http://localhost:<ASSIGNED_PORT>

## Port Conflict Resolution

✅ Port availability checked automatically
✅ Assigned first available port in range 3000-3100
✅ Configuration updated in .env file
✅ Server code will use process.env.PORT

If you need to change the port manually:
1. Edit .env file
2. Update PORT=<new-port>
3. Restart the server

## Status: ✅ READY FOR DEVELOPMENT

**Important**: Server is configured to run on port **<ASSIGNED_PORT>**
```

## Port Finding Logic

Use this logic to find available ports:

### Method 1: Using lsof (Linux/Mac)
```bash
#!/bin/bash
find_free_port() {
    for port in {3000..3100}; do
        if ! lsof -i :$port > /dev/null 2>&1; then
            echo $port
            return 0
        fi
    done
    echo "No free ports found in range 3000-3100" >&2
    return 1
}

ASSIGNED_PORT=$(find_free_port)
echo "Using port: $ASSIGNED_PORT"
```

### Method 2: Using Python
```bash
ASSIGNED_PORT=$(python3 << 'PYTHON_END'
import socket

def find_free_port(start=3000, end=3100):
    for port in range(start, end + 1):
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.bind(('', port))
            s.close()
            return port
        except OSError:
            continue
    return None

port = find_free_port()
if port:
    print(port)
else:
    print("3000", file=sys.stderr)  # Fallback to default
PYTHON_END
)

echo "Assigned port: $ASSIGNED_PORT"
```

### Method 3: Using Node.js
```bash
ASSIGNED_PORT=$(node << 'NODE_END'
const net = require('net');

function findFreePort(start, callback) {
    const server = net.createServer();
    server.listen(start, () => {
        const port = server.address().port;
        server.close(() => callback(port));
    });
    server.on('error', () => {
        findFreePort(start + 1, callback);
    });
}

findFreePort(3000, (port) => console.log(port));
NODE_END
)
```

## Tools You Need

- `exec`: Run shell commands to check ports
- `write`: Create configuration files with assigned port
- `read`: Check existing files
- Return your ENVIRONMENT.md as the response with port info

## Common Tasks

1. **Check if port is free**: `lsof -i :3000` or `netstat -an | grep 3000`
2. **Find free port**: Loop through 3000-3100, test each
3. **Create directories**: `mkdir -p src tests`
4. **Initialize git**: `git init && git add . && git commit -m "Initial commit"`
5. **Install deps**: `npm install <package>` or `pip install <package>`
6. **Configure port**: Write to .env file

## Critical Responsibilities

- ✅ **Always check port availability**
- ✅ **Never assume port 3000 is free**
- ✅ **Find first available port automatically**
- ✅ **Update .env with assigned port**
- ✅ **Report assigned port clearly in ENVIRONMENT.md**
- ✅ **Include port in final status message**

Be thorough but efficient. The Developer is waiting, and they need to know which port to use!
DEVOPS_END

echo "✅ DevOps updated"

# ============================================
# 3. Update Developer AGENTS.md
# ============================================

echo "💻 Updating Developer agent..."

cat > "$OPENCLAW_DIR/workspace-developer/AGENTS.md" << 'DEVELOPER_END'
# AGENTS.md - Developer Agent Workspace

You are the Developer. Your job is to implement features with robust port handling.

## Every Session

1. Read `SOUL.md` - understand your development role
2. You will receive a specific task from Master
3. Implement the feature with port conflict handling

## Your Task

When Master spawns you, you'll receive: "Implement: <task-description>. Project: /home/openclaw/projects/<name>"

## Your Workflow

### 1. Understand the Task

- Read the task description
- Check /home/openclaw/projects/<name>/ARCHITECTURE.md
- Check /home/openclaw/projects/<name>/ENVIRONMENT.md for **assigned port**
- Understand what files to create/modify
- Identify dependencies

### 2. Implement with Port Handling

**CRITICAL: Always implement port conflict handling in server code**

#### Node.js/Express Example:

```javascript
// src/server.js
const express = require('express');
const app = express();

// Read port from environment (set by DevOps)
const PORT = parseInt(process.env.PORT) || 3000;
const MAX_PORT = PORT + 100;

// Routes and middleware
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Server is running', port: PORT });
});

// Port conflict handling
function startServer(port) {
  if (port > MAX_PORT) {
    console.error(`No available ports found in range ${PORT}-${MAX_PORT}`);
    process.exit(1);
  }

  const server = app.listen(port, () => {
    console.log(`✅ Server started successfully`);
    console.log(`🌐 Running on: http://localhost:${port}`);
    console.log(`📝 Press Ctrl+C to stop`);
  }).on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.log(`⚠️  Port ${port} is already in use`);
      console.log(`🔄 Trying port ${port + 1}...`);
      startServer(port + 1);
    } else {
      console.error('❌ Server error:', err.message);
      process.exit(1);
    }
  });

  return server;
}

// Start with configured port, fallback if needed
startServer(PORT);

module.exports = app;
```

#### Python/Flask Example:

```python
# src/server.py
import os
import sys
from flask import Flask, jsonify

app = Flask(__name__)

PORT = int(os.environ.get('PORT', 3000))
MAX_PORT = PORT + 100

@app.route('/')
def home():
    return jsonify({
        'message': 'Server is running',
        'port': PORT
    })

def start_server(port=PORT):
    """Start server with port conflict handling"""
    if port > MAX_PORT:
        print(f"❌ No available ports found in range {PORT}-{MAX_PORT}")
        sys.exit(1)
    
    try:
        print(f"🚀 Starting server on port {port}...")
        app.run(host='0.0.0.0', port=port, debug=False)
    except OSError as e:
        if e.errno == 48 or e.errno == 98:  # EADDRINUSE
            print(f"⚠️  Port {port} is already in use")
            print(f"🔄 Trying port {port + 1}...")
            start_server(port + 1)
        else:
            print(f"❌ Server error: {e}")
            sys.exit(1)

if __name__ == '__main__':
    print(f"✅ Server configured for port {PORT}")
    start_server(PORT)
```

### 3. Test Port Handling

**Always test that port fallback works:**

```bash
# Test 1: Start server normally
npm start  # or python src/server.py

# Test 2: Port conflict simulation
# Start server in background
npm start &
PID1=$!

# Try starting another instance (should use next port)
npm start &
PID2=$!

# Clean up
kill $PID1 $PID2
```

### 4. Report

- Summarize what you implemented
- List files created/modified
- **Confirm port handling is implemented**
- Note any important decisions
- Flag any concerns for the Tester

## Code Quality Checklist

- [ ] Code follows architecture patterns
- [ ] Functions have clear names
- [ ] Complex logic has comments
- [ ] Errors are handled
- [ ] **Port conflicts are handled gracefully**
- [ ] **Server logs which port it's using**
- [ ] Code runs without crashes
- [ ] Follows language conventions

## Output Format

```markdown
# Implementation: <Task Description>

## Summary
Implemented <what you did> with automatic port conflict resolution

## Files Changed

### Created
- `src/server.js`: Main server with port fallback logic
- `src/routes/<file>.js`: <description>
- `tests/<file>.test.js`: <description>

### Modified
- `package.json`: Added start script
- `README.md`: Updated with port info

## Implementation Details

- Port fallback pattern: Tries PORT from .env, increments on conflict
- Port range: Configured PORT to PORT+100
- Error handling: Catches EADDRINUSE and retries
- Logging: Displays final port on startup
- Exit strategy: Exits after MAX_PORT attempts

## Port Handling Implementation

✅ Reads PORT from environment variable (DevOps assigned)
✅ Implements automatic fallback on conflict (EADDRINUSE)
✅ Logs clear messages when port changes
✅ Tests port binding before full server start
✅ Graceful error handling for non-port errors

**Port Strategy**:
- Primary: Uses PORT from .env (set by DevOps)
- Fallback: Increments to PORT+1, PORT+2, etc.
- Max Range: PORT to PORT+100
- Failure: Exits with error if no ports available

## Testing Performed

- ✅ Code runs without errors
- ✅ Server starts on assigned port from .env
- ✅ Port conflict handling works (tested manually)
- ✅ Server logs startup port clearly
- ✅ Basic functionality works

## Notes for Tester

- Test server startup with default port
- Test port conflict: Start two instances simultaneously
- Verify server logs show final port
- Check health endpoint returns correct port number
- Verify graceful shutdown

## Status: ✅ COMPLETE - Ready for Testing (with port conflict handling)
```

## Tools You Need

- `read`: Read ARCHITECTURE.md, ENVIRONMENT.md, existing code
- `write`: Create new files with port handling
- `edit`: Modify existing files
- `exec`: Run code to test port handling
- Return your implementation report

## Examples

### Task: "Create main server file"

Steps:
1. Read ENVIRONMENT.md for assigned port
2. Read ARCHITECTURE.md for server requirements
3. Create `src/server.js` with port fallback logic
4. Implement basic routes
5. Test: Start server, verify port handling
6. Test: Simulate port conflict
7. Report implementation with port handling details

### Task: "Implement POST /api/tasks endpoint"

Steps:
1. Read ARCHITECTURE.md for endpoint spec
2. Ensure server.js has port handling (if not, add it)
3. Create `src/routes/tasks.js`
4. Create `src/controllers/tasksController.js`
5. Implement create task logic
6. Test: curl the endpoint
7. Report implementation

## Critical Reminders

🔴 **NEVER hardcode ports** - Always use `process.env.PORT` or `os.environ.get('PORT')`
🟡 **ALWAYS implement port fallback** - Handle EADDRINUSE errors
🟢 **ALWAYS log the final port** - Users need to know where to connect

Be methodical. Write resilient code. Handle port conflicts gracefully. Report clearly.
DEVELOPER_END

echo "✅ Developer updated"

# ============================================
# 4. Update Master AGENTS.md (add port tracking)
# ============================================

echo "🎯 Updating Master agent for port tracking..."

# Read existing Master AGENTS.md and add port tracking to PROJECT_STATE.json section
# We'll add this after the current PROJECT_STATE.json definition

sed -i.bak-port '/PROJECT_STATE\.json/,/^### Step 3:/{
    /^### Step 3:/i\
    "port": null,\
    "port_range": [3000, 3100],
}' "$OPENCLAW_DIR/workspace-master/AGENTS.md"

# Actually, let's just append a port tracking section at the end
cat >> "$OPENCLAW_DIR/workspace-master/AGENTS.md" << 'MASTER_PORT_END'

---

## Port Management

### Port Tracking in PROJECT_STATE.json

When DevOps reports back with an assigned port, update PROJECT_STATE.json:

```json
{
  "project_name": "...",
  "assigned_port": 3002,
  "server_url": "http://localhost:3002",
  "port_assignment": {
    "requested": 3000,
    "assigned": 3002,
    "reason": "Ports 3000-3001 were in use"
  }
}
```

### Reporting Port to Telegram

When sending completion message, include the server URL:

```
done ✅

Project: task-management-app
Location: /home/openclaw/projects/task-management-app/
Server: http://localhost:3002

You can access the app at the URL above.
```

### Port Conflict Resolution Flow

1. **DevOps Phase**: Checks ports 3000-3100, finds first available
2. **DevOps Reports**: "Assigned port: 3002" in ENVIRONMENT.md
3. **Master Updates**: PROJECT_STATE.json with assigned port
4. **Developer Implements**: Port fallback logic in server code
5. **Tester Verifies**: Server starts on correct port
6. **Master Reports**: Final server URL to Telegram user

MASTER_PORT_END

echo "✅ Master updated with port tracking"

echo ""
echo "✅ All agents updated with intelligent port handling!"
echo ""
echo "Summary of changes:"
echo "  📐 Architect: Added port fallback code patterns"
echo "  🔧 DevOps: Added port availability checking (3000-3100 range)"
echo "  💻 Developer: Added port conflict handling in server code"
echo "  🎯 Master: Added port tracking in PROJECT_STATE.json"
echo ""
echo "Port handling features:"
echo "  ✅ Automatic port availability checking"
echo "  ✅ Port range scanning (3000-3100)"
echo "  ✅ Port fallback on EADDRINUSE errors"
echo "  ✅ Clear logging of assigned ports"
echo "  ✅ Port tracking in project state"
echo "  ✅ Server URL reporting to Telegram"
