docker info | grep "Docker Root Dir"

Docker reads the `Dockerfile` and build context from your current directory, then stores the resulting image in Docker's **local image store**, managed by the Docker daemon.

Where the image is stored depends on your OS:

- **Linux**
    
    ```
    /var/lib/docker/
    ```
    
    This is Docker's data root. Image layers are stored in directories such as:
    
    ```
    /var/lib/docker/overlay2//var/lib/docker/image/
    ```
    
- **Docker Desktop (Windows/macOS)**  
    The images are stored inside Docker Desktop's Linux VM, not directly on your filesystem.

You normally **should not browse or modify these directories manually**, as Docker manages them.