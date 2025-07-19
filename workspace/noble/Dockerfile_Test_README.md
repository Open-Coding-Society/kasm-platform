# KASM Noble Image - Docker Desktop Guide

## 📥 Prerequisites - Install Docker Desktop

### For macOS:

1. **Download Docker Desktop for Mac**:
   - Visit: https://www.docker.com/products/docker-desktop/
   - Click "Download for Mac" (choose Apple Silicon or Intel based on your Mac)
   - Open the downloaded `.dmg` file
   - Drag Docker to Applications folder

2. **Launch Docker Desktop**:
   - Open Docker Desktop from Applications
   - Complete the initial setup and sign in (optional)
   - Wait for Docker to start (you'll see the whale icon in the menu bar)
   - Verify installation: Open Terminal and run `docker --version`

### For Windows with WSL2:

1. **Enable WSL2**:
   - Open PowerShell as Administrator
   - Run: `wsl --install`
   - Restart your computer

2. **Download Docker Desktop for Windows**:
   - Visit: https://www.docker.com/products/docker-desktop/
   - Click "Download for Windows"
   - Run the installer and enable WSL2 integration
   - Restart when prompted

3. **Configure WSL2 Integration**:
   - Open Docker Desktop Settings
   - Go to "Resources" → "WSL Integration"
   - Enable integration with your WSL2 distributions
   - Apply & Restart

## 🏗️ Building the Image

**Prerequisites**: Ensure Docker Desktop is installed and running from the steps above.

### Option 1: Using Docker Desktop UI

1. Go to the "Images" tab
2. Click "Build an image"
3. Set build context to: `/Users/johnmortensen/open/kasm-platform-fork/workspace`
4. Set Dockerfile path to: `noble/Dockerfile`
5. Name the image: `kasm-noble-test:latest`
6. Click "Build"

### Option 2: Using Terminal (Recommended)

```bash
cd /Users/johnmortensen/open/kasm-platform-fork/workspace
docker build -f noble/Dockerfile -t kasm-noble-test:latest .
```

### Option 3: Clean Rebuild (Force rebuild without cache)

```bash
# Clean up existing images and containers first
docker stop kasm-noble-test-container 2>/dev/null || true
docker rm kasm-noble-test-container 2>/dev/null || true

# Clean build without cache
cd /Users/johnmortensen/open/kasm-platform-fork/workspace
docker build --no-cache -f noble/Dockerfile -t kasm-noble-test:latest .
```

### Option 4: Deep Clean + Rebuild (Free up maximum space)

```bash
# Stop and remove all containers using KASM images
docker stop $(docker ps -q --filter ancestor=kasm-noble-test:latest) 2>/dev/null || true
docker rm $(docker ps -aq --filter ancestor=kasm-noble-test:latest) 2>/dev/null || true

# Remove KASM images
docker rmi kasm-noble-test:latest 2>/dev/null || true

# Clean Docker system (removes unused containers, networks, images)
docker system prune -f

# Clean build cache
docker builder prune -f

# Rebuild from scratch
cd /Users/johnmortensen/open/kasm-platform-fork/workspace
docker build --no-cache --pull -f noble/Dockerfile -t kasm-noble-test:latest .
```

## 🚀 Running the Container

### Via Docker Desktop UI:

1. Go to "Images" tab
2. Find `kasm-noble-test:latest`
3. Click "Run" button
4. Configure ports:
   - Host Port 6901 → Container Port 6901 (Web/VNC)
5. Set environment variable: `VNC_PW=password`
6. Set shared memory: `--shm-size=512m`
7. Click "Run"

### Via Terminal:

**Minimal Command (recommended):**

```bash
docker run -d --name kasm-noble-test-container -p 6901:6901 --shm-size=512m -e VNC_PW=password kasm-noble-test:latest
```

**If you get "container name already in use" error:**
```bash
# Stop and remove the existing container first
docker stop kasm-noble-test-container 2>/dev/null || true
docker rm kasm-noble-test-container 2>/dev/null || true

# Then run the container again
docker run -d --name kasm-noble-test-container -p 6901:6901 --shm-size=512m -e VNC_PW=password kasm-noble-test:latest
```

**Full Command (with optional features):**

```bash
docker run -d \
  --name kasm-noble-test-container \
  -p 6901:6901 \
  --shm-size=512m \
  -e VNC_PW=password \
  kasm-noble-test:latest
```

**Interactive Command (for debugging):**

```bash
docker run -it --rm -p 6901:6901 --shm-size=512m -e VNC_PW=password kasm-noble-test:latest
```

## 🌐 Accessing Your KASM Workspace

Once the container is running:

- **Web Access**: https://localhost:6901
- **VNC Access**: localhost:6901
- **Username**: `kasm_user` (note: underscore, not hyphen)
- **Password**: `password`

## 🧪 Testing Your Enhanced Tools

After accessing the workspace, test:

```bash
# Test virtual environments
flaskenv  # Should activate Flask environment
pagesenv  # Should activate Pages environment

# Test Ruby gems
jekyll --version
bundle --version

# Test VS Code
code --version

# Check environment
echo $GEM_HOME
echo $PATH
```

### 🚀 Real-World Test: GitHub Pages Development

Test the complete development workflow:

```bash
mkdir open
cd open
git clone https://github.com/Open-Coding-Society/pages.git
cd pages
pagesenv
bundle install
make
```

**Expected Result:**

```text
Server started in 12 seconds
    Server address: http://127.0.0.1:4500/
```

This test validates:

- ✅ Git operations work correctly
- ✅ Python virtual environment (`pagesenv`) activates properly
- ✅ Ruby gems and bundler are pre-installed and functional
- ✅ Jekyll development server starts without issues
- ✅ No startup delays for development environments

## 🛑 Stopping and Managing Containers

### Stop the Container

**Via Docker Desktop UI:**
1. Go to "Containers" tab
2. Find your running `kasm-noble-test-container`
3. Click "Stop" button

**Via Terminal:**
```bash
# Stop by container name:
docker stop kasm-noble-test-container

# Or stop by image (stops all containers using this image):
docker stop $(docker ps -q --filter ancestor=kasm-noble-test:latest)
```

### Remove the Container

**Via Docker Desktop UI:**
1. After stopping, click "Delete" button

**Via Terminal:**
```bash
# Remove by container name:
docker rm kasm-noble-test-container

# Or remove all stopped containers:
docker container prune -f
```

### Free Up Port 6901

If you get "port already in use" errors:
```bash
# Find what's using port 6901
lsof -i :6901

# Kill any process using port 6901 (macOS/Linux)
sudo lsof -ti:6901 | xargs kill -9

# Or stop all KASM containers
docker stop $(docker ps -q --filter ancestor=kasm-noble-test:latest)
```

## 🍪 Clearing Login Cookies

If you need to clear your login session or troubleshoot authentication:

### Method 1: Browser Developer Tools
1. Open your browser's Developer Tools (F12)
2. Go to "Application" or "Storage" tab
3. Find "Cookies" → "https://localhost:6901"
4. Delete all cookies for this domain

### Method 2: Browser Settings
1. Go to browser settings/preferences
2. Navigate to Privacy/Security settings
3. Click "Clear browsing data" or "Clear cookies"
4. Select "Cookies and site data"
5. Choose time range and clear

### Method 3: Incognito/Private Mode
- Use browser's incognito/private mode for a fresh session
- No cookies are stored, so each session starts clean

### Method 4: Different Browser
- Switch to a different browser for testing
- Useful for comparing behavior across browsers

**When to Clear Cookies:**
- Authentication issues or login loops
- Testing different user scenarios
- Switching between different KASM containers
- Troubleshooting session-related problems
