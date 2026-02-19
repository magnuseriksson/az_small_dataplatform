
## Deploy with terraform 

To deploy with terraform you need to have terraform installed and configured with the necessary permissions. 
Follow these steps to deploy the terraform template:
1. 
2. Authenticate with Azure CLI. 
   ```
   az login
   ```
   #### If you have multiple subscriptions, set the correct one
    ```
    az account set --subscription "YOUR_SUBSCRIPTION_ID"
    ```
3. Initialize Terraform (downloads providers and sets up state)
   ```
   terraform init
   ```
4. Check if the configuration is syntactically correct and internally consistent
   ```
   terraform validate
   ```   
5. Create an execution plan and save it to a file (optional but recommended)
    ```
    terraform plan -out=main.tfplan
    ```
6.  Apply the changes to Azure
    # If you created a plan file, use it:
    ```
    terraform apply main.tf
    ```
    OR, run it directly (it will ask for confirmation unless you use -auto-approve)
    terraform apply