# KASM Kali Image - Docker Desktop Guide

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
4. Set Dockerfile path to: `kali/Dockerfile`
5. Name the image: `kasm-kali-test:latest`
6. Click "Build"

### Option 2: Using Terminal (Recommended)

```bash
cd /Users/johnmortensen/open/kasm-platform-fork/workspace
docker build -f kali/Dockerfile -t kasm-kali-test:latest .
```

### Option 3: Clean Rebuild (Force rebuild without cache)

```bash
# Clean up existing images and containers first
docker stop kasm-kali-test-container 2>/dev/null || true
docker rm kasm-kali-test-container 2>/dev/null || true

# Clean build without cache
cd /Users/johnmortensen/open/kasm-platform-fork/workspace
docker build --no-cache -f kali/Dockerfile -t kasm-kali-test:latest .
```

### Option 4: Deep Clean + Rebuild (Free up maximum space)

```bash
# Stop and remove all containers using KASM images
docker stop $(docker ps -q --filter ancestor=kasm-kali-test:latest) 2>/dev/null || true
docker rm $(docker ps -aq --filter ancestor=kasm-kali-test:latest) 2>/dev/null || true

# Remove KASM images
docker rmi kasm-kali-test:latest 2>/dev/null || true

# Clean Docker system (removes unused containers, networks, images)
docker system prune -f

# Clean build cache
docker builder prune -f

# Rebuild from scratch
cd /Users/johnmortensen/open/kasm-platform-fork/workspace
docker build --no-cache --pull -f kali/Dockerfile -t kasm-kali-test:latest .
```

## 🚀 Running the Container

### Via Docker Desktop UI:

1. Go to "Images" tab
2. Find `kasm-kali-test:latest`
3. Click "Run" button
4. Configure ports:
   - Host Port 6902 → Container Port 6901 (Web/VNC)
5. Set environment variable: `VNC_PW=password`
6. Set shared memory: `--shm-size=512m`
7. Click "Run"

### Via Terminal:

**Minimal Command (recommended):**

```bash
docker run -d --name kasm-kali-test-container -p 6902:6901 --shm-size=512m -e VNC_PW=password kasm-kali-test:latest
```

**If you get "container name already in use" error:**

```bash
# Stop and remove the existing container first
docker stop kasm-kali-test-container 2>/dev/null || true
docker rm kasm-kali-test-container 2>/dev/null || true

# Then run the container again
docker run -d --name kasm-kali-test-container -p 6902:6901 --shm-size=512m -e VNC_PW=password kasm-kali-test:latest
```

**Full Command (with optional features):**

```bash
docker run -d \
  --name kasm-kali-test-container \
  -p 6902:6901 \
  --shm-size=512m \
  -e VNC_PW=password \
  kasm-kali-test:latest
```

**Interactive Command (for debugging):**

```bash
docker run -it --rm -p 6902:6901 --shm-size=512m -e VNC_PW=password kasm-kali-test:latest
```

## 🌐 Accessing Your KASM Workspace

Once the container is running:

- **Web Access**: https://localhost:6902
- **VNC Access**: localhost:6902
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

# Test Kali-specific tools
nmap --version
burpsuite --version 2>/dev/null || echo "Burp Suite available in GUI"

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

### 🔒 Kali-Specific Testing

Test Kali Linux security tools:

```bash
# Test network tools
netstat --version

# Test security frameworks
msfconsole -v

# Test web testing tools
sqlmap --version
```

This test validates:

- ✅ Git operations work correctly
- ✅ Python virtual environment (`pagesenv`) activates properly
- ✅ Ruby gems and bundler are pre-installed and functional
- ✅ Jekyll development server starts without issues
- ✅ Kali Linux security tools are available
- ✅ No startup delays for development environments

## 🛑 Stopping and Managing Containers

### Stop the Container

**Via Docker Desktop UI:**

1. Go to "Containers" tab
2. Find your running `kasm-kali-test-container`
3. Click "Stop" button

**Via Terminal:**

```bash
# Stop by container name
docker stop kasm-kali-test-container

# Or stop by image (stops all containers using this image)
docker stop $(docker ps -q --filter ancestor=kasm-kali-test:latest)
```

### Remove the Container

**Via Docker Desktop UI:**

1. After stopping, click "Delete" button

**Via Terminal:**

```bash
# Remove by container name
docker rm kasm-kali-test-container

# Or remove all stopped containers
docker container prune -f
```

### Free Up Port 6902

If you get "port already in use" errors:

```bash
# Find what's using port 6902
lsof -i :6902

# Kill any process using port 6902 (macOS/Linux)
sudo lsof -ti:6902 | xargs kill -9

# Or stop all KASM containers
docker stop $(docker ps -q --filter ancestor=kasm-kali-test:latest)
```

## 🍪 Clearing Login Cookies

If you need to clear your login session or troubleshoot authentication:

### Method 1: Browser Developer Tools

1. Open your browser's Developer Tools (F12)
2. Go to "Application" or "Storage" tab
3. Find "Cookies" → `https://localhost:6902`
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

## 📋 Container Management in Docker Desktop

1. **View Logs**: Go to "Containers" tab → Click your container → "Logs" tab
2. **Shell Access**: Click "CLI" button or "Exec" tab
3. **Stop Container**: Click "Stop" button
4. **Remove Container**: Click "Delete" button

## 🔧 Troubleshooting

If build fails:

1. Check Docker Desktop is running
2. Ensure you're in the correct directory
3. Check Dockerfile syntax
4. Try building with Docker Desktop UI instead of CLI

## 📊 Expected Build Time

- Initial build: 15-25 minutes (downloading Kali base image + installing tools)
- Subsequent builds: 5-10 minutes (using cache)

## ✅ Success Indicators

- Container shows "Running" status in Docker Desktop
- Web interface accessible at localhost:6902
- All virtual environments and gems are pre-installed
- Kali Linux security tools are available
- No startup delays for development environments
