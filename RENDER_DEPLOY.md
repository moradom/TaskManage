# 🚀 Deploy to Render (FREE)

This guide will help you deploy your Task Manager app to Render's free tier.

## 📋 Prerequisites

- GitHub account with this repository
- Render account (sign up at [render.com](https://render.com))

## 🎯 Deployment Steps

### Method 1: Automatic Deployment (Using render.yaml)

1. **Push this code to GitHub** (if not already done)
   ```bash
   git push origin claude/task-manager-full-stack-QSw8o
   ```

2. **Go to Render Dashboard**
   - Visit https://dashboard.render.com
   - Click **"New +"** → **"Blueprint"**

3. **Connect Repository**
   - Select your GitHub repository: `moradom/TaskManage`
   - Select branch: `claude/task-manager-full-stack-QSw8o`
   - Render will detect the `render.yaml` file

4. **Review Services**
   Render will create:
   - ✅ PostgreSQL Database (free tier)
   - ✅ Backend API service (free tier)
   - ✅ Frontend service (free tier)

5. **Deploy**
   - Click **"Apply"**
   - Wait 5-10 minutes for deployment
   - Services will spin down after 15 minutes of inactivity (free tier limitation)

6. **Get Your URLs**
   - Backend: `https://taskmanager-backend.onrender.com`
   - Frontend: `https://taskmanager-frontend.onrender.com`

---

### Method 2: Manual Deployment (Step-by-Step)

If the Blueprint method doesn't work, deploy manually:

#### Step 1: Create PostgreSQL Database

1. Click **"New +"** → **"PostgreSQL"**
2. Settings:
   - **Name**: `taskmanager-db`
   - **Database**: `taskmanager`
   - **User**: `taskuser`
   - **Region**: Oregon (or closest to you)
   - **Plan**: **Free**
3. Click **"Create Database"**
4. ⚠️ Save the **Internal Database URL** (you'll need it)

#### Step 2: Deploy Backend

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Settings:
   - **Name**: `taskmanager-backend`
   - **Region**: Oregon (same as database)
   - **Branch**: `claude/task-manager-full-stack-QSw8o`
   - **Runtime**: **Docker**
   - **Dockerfile Path**: `./backend/Dockerfile`
   - **Docker Build Context**: `./backend`
   - **Plan**: **Free**
4. **Environment Variables**:
   - Key: `DATABASE_URL`
   - Value: [Paste the Internal Database URL from Step 1]
5. Click **"Create Web Service"**
6. Wait for deployment (~3-5 minutes)
7. ✅ Save your backend URL (e.g., `https://taskmanager-backend.onrender.com`)

#### Step 3: Deploy Frontend

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Settings:
   - **Name**: `taskmanager-frontend`
   - **Region**: Oregon
   - **Branch**: `claude/task-manager-full-stack-QSw8o`
   - **Runtime**: **Docker**
   - **Dockerfile Path**: `./frontend/Dockerfile`
   - **Docker Build Context**: `./frontend`
   - **Plan**: **Free**
4. Click **"Create Web Service"**
5. Wait for deployment (~5-7 minutes)

---

## ⚠️ Important: Connect Frontend to Backend

After deployment, you need to configure the frontend to connect to your backend:

### Option A: Update nginx.conf (Recommended)

1. Edit `frontend/nginx.conf`
2. Change line 12 from:
   ```nginx
   proxy_pass http://backend:8000/api;
   ```
   To:
   ```nginx
   proxy_pass https://taskmanager-backend.onrender.com/api;
   ```
3. Commit and push - Render will auto-redeploy

### Option B: Update Angular Environment (Alternative)

1. Edit `frontend/src/app/task.service.ts`
2. Change line 11 from:
   ```typescript
   private apiUrl = '/api';
   ```
   To:
   ```typescript
   private apiUrl = 'https://taskmanager-backend.onrender.com/api';
   ```
3. Commit and push - Render will auto-redeploy

---

## ✅ Test Your Deployment

1. Visit your frontend URL: `https://taskmanager-frontend.onrender.com`
2. The app should load (may take 30-60 seconds on first visit due to cold start)
3. Try creating a task
4. Try editing and deleting tasks

---

## 🐌 Free Tier Limitations

- **Cold Starts**: Services spin down after 15 minutes of inactivity
- **Wake-up Time**: 30-60 seconds when accessing after sleep
- **Database**: Free PostgreSQL expires after 90 days (manual renewal required)
- **Traffic**: Limited bandwidth

---

## 💰 Upgrade Options

If you want to eliminate cold starts:

- **Backend**: Upgrade to Starter plan ($7/month) for always-on
- **Frontend**: Upgrade to Starter plan ($7/month) for always-on
- **Database**: Paid plans start at $7/month for persistent storage

---

## 🔧 Troubleshooting

### Frontend can't connect to Backend

**Error**: API calls fail with CORS errors

**Solution**: Make sure backend URL is correctly configured in nginx.conf or task.service.ts

### Database connection fails

**Error**: Backend shows database connection errors

**Solution**:
1. Check DATABASE_URL environment variable in backend service
2. Ensure it's the **Internal Database URL** from PostgreSQL service
3. Format: `postgresql://user:password@host:port/database`

### Services won't start

**Error**: Build fails or service crashes

**Solution**:
1. Check build logs in Render dashboard
2. Ensure Docker images build successfully
3. Verify all environment variables are set

---

## 📊 Monitoring

- View logs: Render Dashboard → Service → Logs tab
- Check metrics: Render Dashboard → Service → Metrics tab
- Health checks: Render automatically monitors service health

---

## 🎉 You're Done!

Your Task Manager is now deployed on Render's free tier!

**Share your app**: Give others your frontend URL to test

**Need help?** Check Render's documentation at https://render.com/docs
