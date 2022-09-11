# Setting up envriontment

1. After pulling the repository navigate to ${LOCAL_PATH}/fep-terraform-infrastructure/terraform_container

2. Here we open the README.md file and follow the instructions accordingly to the comments. 
NOTES:
    - "docker build" command must be executed only the first time, to create the container image. Afterwards "docker-compose up" and "docker exec" commands are enough.
    - if the build fails then make sure you are not connected to the VPN since it blocks all the requests made to get packages from repos

3. After executing the exec command we should be inside the container as root. Now, we need to login to Azure.
    - run "az login". The command will prompt a link E.g "https://microsoft.com/devicelogin".
    - we open it the browser then we copy the code inside the web page prompt. We select out azure account and then we can close the page and return to the terminal. The command should have completed.

4. Make sure we select the right subscription(pick one of them):
    - run az account set --subscription "Non Production Env" 
    - run az account set --subscription "Pre Production Env" 
    - run az account set --subscription "Core Infrastructure Env" 
    - run az account set --subscription "Production Env" 

5. Browse to the terraform_infrastructure folder. The Host machine folder has been mounted on /opt/terraform_infrastructure.
    - run "cd /opt/terraform_infrastructure"

6. When creating new resources select the "dev" environment not the "development" after the latest updates
(this comes after running terraform init)
    - "terraform workspace select dev"
    - if the environment does not exist create it first - "terraform workspace new dev"