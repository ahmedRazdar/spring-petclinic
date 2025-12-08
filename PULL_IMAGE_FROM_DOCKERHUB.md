# Pull Docker Image from Docker Hub to Local Docker Desktop

## Why you don't see the image locally:

When CI/CD pushes an image to Docker Hub, it's stored **remotely** on Docker Hub's servers. It doesn't automatically appear in your local Docker Desktop. You need to **pull** it to your local machine.

## Step 1: Find Your Docker Hub Username

Your Docker Hub username is the one you set in the GitHub secret `DOCKERHUB_USERNAME`.

You can also check:
- Go to: https://hub.docker.com/
- Your username is shown in the top right corner

## Step 2: Pull the Image

Replace `YOUR_USERNAME` with your actual Docker Hub username:

```powershell
docker pull YOUR_USERNAME/spring-petclinic:latest
```

For example, if your username is `ahmedrazdar`:
```powershell
docker pull ahmedrazdar/spring-petclinic:latest
```

## Step 3: Verify the Image is Now Local

```powershell
# List all images
docker images

# You should see:
# YOUR_USERNAME/spring-petclinic   latest   ...   ...   ...
```

## Step 4: View in Docker Desktop

1. **Open Docker Desktop**
2. Click on **"Images"** tab (left sidebar)
3. You should now see: `YOUR_USERNAME/spring-petclinic:latest`

## Step 5: Run the Container (Optional)

```powershell
docker run -d -p 8080:8080 --name petclinic-app YOUR_USERNAME/spring-petclinic:latest
```

Then check Docker Desktop → **Containers** tab to see it running.

## Alternative: Check Image on Docker Hub First

1. Go to: https://hub.docker.com/r/YOUR_USERNAME/spring-petclinic
2. Verify the image exists and has the `latest` tag
3. Then pull it using the command above



