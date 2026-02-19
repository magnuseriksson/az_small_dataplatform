## Bicep deploy

To use Bicep, you need to have Azure CLI installed and configured with the necessary permissions. Follow these steps to deploy the Bicep template:

1. Authenticate with Azure CLI. 
   ```
   az login
   ```   
2. Validate 
   ```
   az deployment sub validate --location northeurope --template-file main.bicep 
   ```
3. Run the following command to deploy the Bicep template:
   ```
   az deployment sub create --location norteurope --template-file main.bicep --parameters @parameters.json
   ```
4. Optional provide the necessary parameters in the `parameters.json` file.