# GitHub Codespaces Setup

This project is configured to run in GitHub Codespaces!

## 🚀 Quick Start in Codespaces

1. Click the green "Code" button on GitHub
2. Select "Codespaces" tab
3. Click "Create codespace on claude/task-manager-full-stack-QSw8o"
4. Wait for the environment to load

## 📦 Running the Application

Once your Codespace is ready:

```bash
# Start all services (database, backend, frontend)
docker-compose up -d

# Check the status
docker-compose ps

# View logs
docker-compose logs -f
```

## 🌐 Accessing the Application

After running `docker-compose up -d`:

1. Go to the **PORTS** tab in VS Code (bottom panel)
2. You'll see three forwarded ports:
   - **Port 80** (Frontend) - Click the globe icon to open in browser
   - **Port 8000** (Backend API) - API endpoints
   - **Port 5432** (PostgreSQL) - Database

3. Click the globe icon 🌐 next to Port 80 to open the Task Manager app

## 🔧 Development Commands

```bash
# Stop all services
docker-compose down

# Rebuild and restart
docker-compose up -d --build

# View backend logs
docker-compose logs -f backend

# View frontend logs
docker-compose logs -f frontend

# Access database
docker-compose exec db psql -U taskuser -d taskmanager
```

## 📝 Making Changes

- **Backend**: Edit files in `backend/` - restart with `docker-compose restart backend`
- **Frontend**: Edit files in `frontend/` - rebuild with `docker-compose up -d --build frontend`

## ⚠️ Important Notes

- Codespaces are for **development/testing**, not production
- Your Codespace stops when inactive (saves your work)
- Free tier: 60 hours/month for 2-core machine
- Ports are private by default (only you can access them)
- You can make ports public in the Ports tab if needed

## 🔒 Making Ports Public (for sharing)

1. Right-click on a port in the PORTS tab
2. Select "Port Visibility" → "Public"
3. Share the URL with others

## 💡 Tips

- The Codespace URL is temporary and changes each time
- For permanent hosting, use Railway, Render, or other platforms
- Codespaces auto-saves your work
- You can reconnect to existing Codespaces from GitHub
