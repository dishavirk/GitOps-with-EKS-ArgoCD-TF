## **Part 2: Automating Docker Image Deployment with GitHub Actions**

In this second installment of our GitOps series, we delve into the heart of automation using GitHub Actions. Our objective is simple yet impactful: to build a Docker image from our Python Flask app, push it to DockerHub, and automatically update the image tag in our Kubernetes deployment. We achieve this through a single workflow: `build-push-update.yaml`. Let's break down this process into easily digestible bullet points for better understanding.

### **Overview of Workflow: `build-push-update.yaml`**


![Drag Racing](./../../Downloads/Blank%20diagram%20(3).png)

- #### **Trigger Mechanism**: 
  - The workflow is triggered on two occasions:  
</br> 
    1. **Manual Trigger** (`workflow_dispatch`): This allows us to initiate the process at our convenience directly from GitHub's UI.
    2. **Push to Master Branch**:
       - The workflow automatically triggers when a push is made to the `master` branch. This ensures that the Docker image is built and deployed whenever there are new changes in the main line of development.
  
</br> 

- #### **Jobs in the Workflow**:
</br>

  1. **Build and Push Docker Image**:
     - **Environment Setup**:
       - **Runs on**: Ubuntu latest version.
       - **Environment Variables**: 
         - `DOCKER_IMAGE_NAME`: Combines the repository owner's name with `/celsius-to-fahrenheit`.
         - `DOCKER_IMAGE_TAG_BUILD`: Uses the GitHub run number as the Docker image tag.
     - **Steps**:
       1. **Checkout Repository**: Grabs the latest code from the repository.
       2. **Set up Python**: Installs Python 3.8.
       3. **Check for `requirements.txt`**: Verifies the existence of the requirements file.
       4. **Install Dependencies**: If `requirements.txt` exists, installs the necessary Python packages.
       5. **Build Docker Image**: Creates a Docker image with the tag specified in the environment variable.
       6. **Log in to Docker Hub**: Uses GitHub secrets for Docker Hub credentials.
       7. **Push to Docker Hub**: Uploads the built Docker image to Docker Hub.

  2. **Update Deployment in Kubernetes**:
     - **Dependency**: Waits for the 'Build and Push Docker Image' job to complete.
     - **Environment Setup**:
       - **Runs on**: Ubuntu latest version.
       - **Environment Variables**:
         - `DOCKER_IMAGE_NAME`: Same as in the first job.
     - **Steps**:
       1. **Checkout Repository**: Grabs the repository's code.
       2. **Update Deployment YAML**: Replaces the image tag in `deployment.yaml` with the new Docker image tag.
       3. **Commit and Push Changes**: Commits the updated `deployment.yaml` and pushes it to the repository.

#### **Simplifying the Technicalities**

1. **Initiation**: You manually start the workflow, ensuring control over when the deployment process begins.

2. **Building the Image**: 
   - The code is first synchronized with the GitHub repository.
   - Next, it sets up the necessary Python environment.
   - It checks for the presence of a `requirements.txt` file and installs any dependencies listed there.
   - The Docker image is then created using the latest application code.

3. **Pushing to Docker Hub**: 
   - Securely logs into Docker Hub using credentials stored in GitHub secrets.
   - The newly built Docker image is then pushed to Docker Hub, making it available for deployment.

4. **Updating Kubernetes Deployment**:
   - The workflow then fetches the code again to ensure it has the latest version.
   - It updates the Kubernetes deployment file (`deployment.yaml`) with the new Docker image tag.
   - Finally, it commits and pushes these changes back to the GitHub repository.

5. **Result**: 
   - The Kubernetes deployment will now use the updated Docker image, ensuring that the latest version of the app is running.

6. **Automation and Efficiency**:
   - This workflow automates a crucial part of the CI/CD pipeline. It eliminates manual errors and saves time.
   - Every time you trigger this workflow, it ensures that your Kubernetes deployment is using the latest version of your Docker image.
   - The use of GitHub secrets for Docker Hub authentication maintains security and privacy.

#### **Conclusion**

The `build-push-update.yaml` workflow is a cornerstone in implementing GitOps using GitHub Actions. It encapsulates best practices in CI/CD and GitOps, marrying code versioning with deployment in an automated, efficient, and secure manner. By breaking down the process into distinct steps and jobs, we achieve a high level of clarity and control over our deployment process. 

Stay tuned for further parts of this series where we will explore more intricate aspects of GitOps, including managing infrastructure with Terraform and orchestrating complex workflows. This journey will not only enhance your understanding but also equip you with the tools to implement robust, automated, and efficient DevOps practices in your projects.
