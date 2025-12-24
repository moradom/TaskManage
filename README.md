# Task Manager Application

A full-stack task management application built with Angular, Python FastAPI, and PostgreSQL.

## Features

- Create, Read, Update, and Delete tasks
- Mark tasks as completed
- Edit task details
- Beautiful and responsive UI
- RESTful API backend
- PostgreSQL database

## Tech Stack

- **Frontend**: Angular 17 (standalone components)
- **Backend**: Python FastAPI
- **Database**: PostgreSQL 17
- **Containerization**: Docker
- **CI/CD**: GitHub Actions

## Project Structure

```
TaskManage/
├── backend/              # Python FastAPI backend
│   ├── main.py          # FastAPI application
│   ├── models.py        # SQLAlchemy models
│   ├── schemas.py       # Pydantic schemas
│   ├── database.py      # Database configuration
│   ├── requirements.txt # Python dependencies
│   └── Dockerfile       # Backend Docker image
├── frontend/            # Angular frontend
│   ├── src/
│   │   ├── app/        # Angular components and services
│   │   └── environments/ # Environment configurations
│   ├── nginx.conf      # Nginx configuration
│   └── Dockerfile      # Frontend Docker image
├── .github/workflows/  # GitHub Actions CI/CD
└── docker-compose.yml  # Local development setup
```

## Local Development

### Prerequisites

- Docker and Docker Compose installed
- Git

### Running Locally

1. Clone the repository:
```bash
git clone <repository-url>
cd TaskManage
```

2. Start the application using Docker Compose:
```bash
docker-compose up --build
```

3. Access the application:
   - Frontend: http://localhost
   - Backend API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs

4. To stop the application:
```bash
docker-compose down
```

## API Endpoints

- `GET /api/tasks` - Get all tasks
- `GET /api/tasks/{id}` - Get a specific task
- `POST /api/tasks` - Create a new task
- `PUT /api/tasks/{id}` - Update a task
- `DELETE /api/tasks/{id}` - Delete a task

## Docker Images

The GitHub Actions workflow automatically builds and pushes Docker images to GitHub Container Registry on each commit:

- Backend: `ghcr.io/<username>/taskmanage/backend:latest`
- Frontend: `ghcr.io/<username>/taskmanage/frontend:latest`

## Deployment Options

### Option 1: Deploy to Railway (Recommended)

1. Fork this repository
2. Go to [Railway.app](https://railway.app)
3. Create a new project from GitHub repository
4. Add PostgreSQL service
5. Deploy backend and frontend services
6. Set environment variables:
   - `DATABASE_URL` (automatically set by Railway for PostgreSQL)

### Option 2: Deploy to Render

1. Fork this repository
2. Go to [Render.com](https://render.com)
3. Create a new Web Service for the backend
4. Create a new Static Site for the frontend
5. Add PostgreSQL database
6. Configure environment variables

### Option 3: Deploy to Any VPS

1. Install Docker and Docker Compose on your server
2. Set environment variables:
```bash
export GITHUB_REPOSITORY=<username>/taskmanage
export POSTGRES_USER=taskuser
export POSTGRES_PASSWORD=<secure-password>
export POSTGRES_DB=taskmanager
export PORT=80
```

3. Pull and run using the production compose file:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Option 4: Deploy to Azure Container Instances

1. Install Azure CLI
2. Login to Azure:
```bash
az login
```

3. Create resource group:
```bash
az group create --name taskmanager-rg --location eastus
```

4. Deploy containers:
```bash
az container create --resource-group taskmanager-rg \
  --name taskmanager-app \
  --image ghcr.io/<username>/taskmanage/frontend:latest \
  --dns-name-label taskmanager-app \
  --ports 80
```

### Option 5: Deploy to Google Cloud Run

1. Install Google Cloud SDK
2. Authenticate:
```bash
gcloud auth login
```

3. Deploy frontend:
```bash
gcloud run deploy taskmanager-frontend \
  --image ghcr.io/<username>/taskmanage/frontend:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

4. Deploy backend:
```bash
gcloud run deploy taskmanager-backend \
  --image ghcr.io/<username>/taskmanage/backend:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

## Environment Variables

### Backend
- `DATABASE_URL`: PostgreSQL connection string (format: `postgresql://user:password@host:port/database`)

### Frontend (Build time)
- API URL is configured in `src/environments/environment.prod.ts`

## CI/CD

The project uses GitHub Actions to automatically:
1. Build Docker images for frontend and backend
2. Push images to GitHub Container Registry
3. Tag images with branch name and commit SHA

Workflow triggers on:
- Push to `main` branch
- Push to branches starting with `claude/`
- Pull requests to `main`

## Database Schema

### Tasks Table
- `id` (Integer, Primary Key)
- `title` (String, Required)
- `description` (String, Optional)
- `completed` (Boolean, Default: false)
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

## License

MIT License

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
