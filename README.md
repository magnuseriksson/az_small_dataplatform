# adp_databricks

#### This is a playground and an example of a dataplatform i Azure. 
#### Its fully functional with examples of deployscripts both i Bicep and Terraform. 
#### That are deployed using Github Actions.
#### Ive also included some examples of notebooks using Data live table to build nice pipelines.
#### And also included a working eventhub and stream analytics job to show how data can be streamed to a Datawarehouse.

## Azure Services used in this example

### Core Services

-  **Databricks**
   #### The most important component of our data platform is Databricks, Where we will be running our jobs for analytics and data engineering. 
   #### In Databricks we also have the Unity Catalog , our warehouse that we use to serve data to our BI tools. 
   #### Databricks is here deployed in a private virtual network for better security, but this is optional and databricks can be deployed without it.
   #### Databricks then creates its own virtual network.

- **Event Hub** 
   #### One way to get data into our data platform is through Event Hubs. 
   #### There is then several options to save the data to our datalake 
      - Capture events and save to storage as avro direct to storage 
      - Capture events and save to storage as delta or parquet using Stream analytics job       
      - Databricks Delta Live Tables and stream directly to our warehouse.

- **Stream Analytics Job** 
   #### Stream analytics job is used to save the data from Event Hubs to our warehouse in Delta format.


### Access and security
    #### All of the services uses managed identities to access other services.
    #### Data
. **Databricks Access Connector** (`Microsoft.Databricks/accessConnectors`)
   - System-assigned managed identity
   - RBAC permissions to Storage Account

6. **Virtual Network** (`Microsoft.Network/virtualNetworks`)
   - Address space: `10.0.0.0/18`
   - Public subnet: `10.0.0.0/20` (delegated to Databricks)
   - Private subnet: `10.0.32.0/20` (delegated to Databricks)

7. **Network Security Groups** (`Microsoft.Network/networkSecurityGroups`)
   - Public NSG with outbound rules for Databricks connectivity
   - Private NSG with outbound rules for Databricks connectivity
   - Rules for Storage, Event Hub, SQL access

### RBAC Assignments

- Storage Blob Data Contributor: Data Factory → Storage Account
- Storage Blob Data Contributor: Databricks Access Connector → Storage Account
- Event Hubs Data Receiver: Data Factory → Event Hub Namespace

