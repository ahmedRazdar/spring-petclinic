# How to Pull Docker Image from GitHub Container Registry

## Step 1: Authenticate with GitHub Container Registry

First, you need to create a Personal Access Token (PAT) with `read:packages` permission:

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Give it a name like "Docker Pull"
4. Select scope: `read:packages`
5. Click "Generate token"
6. Copy the token (you won't see it again!)

## Step 2: Login to GitHub Container Registry

```powershell
# Replace YOUR_TOKEN with the token you just created
echo YOUR_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

Or on Windows PowerShell:
```powershell
$token = "YOUR_TOKEN"
echo $token | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

## Step 3: Pull the Image

```powershell
# Pull the latest image
docker pull ghcr.io/ahmedrazdar/spring-petclinic:latest

# Or pull by branch name
docker pull ghcr.io/ahmedrazdar/spring-petclinic:main
```

## Step 4: Verify the Image

```powershell
# List images
docker images | findstr spring-petclinic

# You should see:
# ghcr.io/ahmedrazdar/spring-petclinic   latest   ...   ...   ...
```

## Step 5: Run the Image Locally

```powershell
docker run -d -p 8080:8080 --name petclinic-app ghcr.io/ahmedrazdar/spring-petclinic:latest
```

## Alternative: Make Image Public

If you want to pull without authentication, make the package public:

1. Go to: https://github.com/ahmedRazdar/spring-petclinic/pkgs
2. Click on the `spring-petclinic` package
3. Click "Package settings"
4. Scroll down to "Danger Zone"
5. Click "Change visibility" → "Make public"

Then you can pull without authentication:
```powershell
docker pull ghcr.io/ahmedrazdar/spring-petclinic:latest
```

