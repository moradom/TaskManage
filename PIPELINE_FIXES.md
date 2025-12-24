# GitHub Actions Pipeline Fixes

## Issues Fixed

### 1. ✅ Missing package-lock.json
**Problem**: npm install in CI can have inconsistent results without a lock file
**Solution**: Created `frontend/package-lock.json` to ensure consistent dependency resolution

### 2. ✅ Peer Dependency Conflicts
**Problem**: Angular 17 can have peer dependency conflicts during install
**Solution**:
- Added `.npmrc` with `legacy-peer-deps=true`
- Updated Dockerfile to use `npm ci --legacy-peer-deps` with fallback

### 3. ✅ Missing Docker Buildx
**Problem**: Advanced Docker features require buildx
**Solution**: Added `docker/setup-buildx-action@v3` step to workflow

### 4. ✅ Slow Builds Without Caching
**Problem**: Each build reinstalls all dependencies
**Solution**: Implemented registry caching:
```yaml
cache-from: type=registry,ref=ghcr.io/.../buildcache
cache-to: type=registry,ref=ghcr.io/.../buildcache,mode=max
```

### 5. ✅ Build Configuration
**Problem**: Frontend might not build with production optimizations
**Solution**: Updated Dockerfile to use `npm run build -- --configuration production`

### 6. ✅ Better Error Messages
**Problem**: Unclear what failed in the pipeline
**Solution**: Added output summary step with image tags

## How to Monitor the Pipeline

### Option 1: GitHub Web Interface
1. Go to: https://github.com/moradom/TaskManage/actions
2. Click on the latest workflow run
3. Watch the build progress in real-time

### Option 2: GitHub CLI (if installed)
```bash
# List recent runs
gh run list --limit 5

# Watch the latest run
gh run watch

# View logs
gh run view --log
```

### Option 3: Use the monitoring script
```bash
./scripts/monitor-pipeline.sh
```

## Expected Pipeline Flow

1. ✅ **Checkout repository** - Clone the code
2. ✅ **Set up Docker Buildx** - Enable advanced Docker features
3. ✅ **Login to GHCR** - Authenticate with GitHub Container Registry
4. ✅ **Extract metadata (backend)** - Generate tags and labels
5. ✅ **Extract metadata (frontend)** - Generate tags and labels
6. ⏳ **Build backend image** - ~2-3 minutes (first build), ~30s (cached)
7. ⏳ **Build frontend image** - ~5-7 minutes (first build), ~1-2 min (cached)
8. ✅ **Output summary** - Show built image tags

## Troubleshooting

### If Backend Build Fails
Check:
- Python dependencies in `backend/requirements.txt`
- Dockerfile syntax in `backend/Dockerfile`
- Database connection (not needed for build)

### If Frontend Build Fails
Check:
- Node/npm versions (using Node 20)
- Angular dependencies in `package.json`
- TypeScript compilation errors
- Build budget limits in `angular.json`

Common fixes:
```bash
# Test frontend build locally
cd frontend
npm ci --legacy-peer-deps
npm run build -- --configuration production
```

### If Push to Registry Fails
Check:
- Repository permissions (packages: write)
- GITHUB_TOKEN is valid
- Image names are lowercase

## Build Times

| Build Stage | First Build | Cached Build |
|------------|-------------|--------------|
| Backend | 2-3 minutes | 20-30 seconds |
| Frontend | 5-7 minutes | 1-2 minutes |
| **Total** | **7-10 min** | **2-3 minutes** |

## Success Indicators

✅ All steps show green checkmarks
✅ Images pushed to `ghcr.io/moradom/taskmanage/backend:latest`
✅ Images pushed to `ghcr.io/moradom/taskmanage/frontend:latest`
✅ Build summary shows correct tags

## Next Steps After Successful Build

1. **Test in Codespaces**: Create a Codespace and run `docker-compose up`
2. **Deploy to Railway**: Use the built images for production
3. **Deploy to Render**: Configure services to use GHCR images
4. **Pull locally**:
   ```bash
   docker pull ghcr.io/moradom/taskmanage/frontend:latest
   docker pull ghcr.io/moradom/taskmanage/backend:latest
   ```

## Monitoring Link

👉 **Live Pipeline Status**: https://github.com/moradom/TaskManage/actions

The latest workflow should be running now after the fixes were pushed!
