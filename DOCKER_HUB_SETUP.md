# Docker Hub Setup for CI/CD

## Step 1: Create Docker Hub Account (if you don't have one)

1. Go to: https://hub.docker.com/
2. Click "Sign Up" and create an account
3. Verify your email address

## Step 2: Create Docker Hub Access Token

1. Log in to Docker Hub: https://hub.docker.com/
2. Click on your username (top right) → **Account Settings**
3. Go to **Security** tab (left sidebar)
4. Click **New Access Token**
5. Give it a description: "GitHub Actions CI/CD"
6. Set permissions to **Read & Write** (or just **Write** if you prefer)
7. Click **Generate**
8. **IMPORTANT**: Copy the token immediately - you won't see it again!
   - It will look like: `dckr_pat_xxxxxxxxxxxxxxxxxxxx`

## Step 3: Add Secrets to GitHub Repository

1. Go to your repository: https://github.com/ahmedRazdar/spring-petclinic
2. Click **Settings** (top menu)
3. Click **Secrets and variables** → **Actions** (left sidebar)
4. Click **New repository secret**

### Add DOCKERHUB_USERNAME:
- **Name**: `DOCKERHUB_USERNAME`
- **Value**: Your Docker Hub username
- Click **Add secret**

### Add DOCKERHUB_TOKEN:
- **Name**: `DOCKERHUB_TOKEN`
- **Value**: The access token you created in Step 2
- Click **Add secret**

## Step 4: Verify Setup

After adding the secrets, push a commit to the `main` branch. The workflow will:
1. Build your Maven project
2. Build your Docker image
3. Push it to Docker Hub at: `YOUR_USERNAME/spring-petclinic:latest`

## Step 5: Check Your Image on Docker Hub

1. Go to: https://hub.docker.com/r/YOUR_USERNAME/spring-petclinic
2. You should see your image with tags like:
   - `latest` (for main branch)
   - `main` (branch name)
   - `main-<commit-sha>` (with commit SHA)

## Pull the Image Locally

Once the image is on Docker Hub, you can pull it:

```powershell
docker pull YOUR_USERNAME/spring-petclinic:latest
```

## Troubleshooting

### If the workflow fails with "authentication required":
- Double-check that `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets are set correctly
- Make sure the token has write permissions
- Verify the token hasn't expired

### If you see "repository does not exist":
- Docker Hub will automatically create the repository on first push
- Make sure your Docker Hub username matches the secret exactly

