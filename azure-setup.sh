# Päivitä az tarvittaessa: https://docs.microsoft.com/en-us/cli/azure/update-azure-cli
az extension add --name datafactory

az group create --name geodatalake-fi-rg --location westeurope
az storage account create --name geodatalake --resource-group geodatalake-fi-rg --location westeurope --kind StorageV2 --sku Standard_LRS --enable-hierarchical-namespace true
az storage container create --name main --account-name geodatalake --resource-group geodatalake-fi-rg
az datafactory create --resource-group geodatalake-fi-rg --name geodatafactorymkoivi --location westeurope

$adlkey = az storage account show-connection-string --name geodatalake --resource-group geodatalake-fi-rg --key primary | ConvertFrom-Json
$lsconfig = gc "datalake_linkedservice.json"
$lsconfig = ($lsconfig).Replace("[connstring]", $adlkey.connectionString) 
az datafactory linked-service create --resource-group geodatalake-fi-rg --factory-name geodatafactorymkoivi --linked-service-name geoadlLinkedService  --properties @datalake_linkedservice.json 

# create pipeline
# ingest data


az vm create --resource-group geodatalake-fi-rg --name geodb-vm --image UbuntuLTS --size Standard_L16s_v2 --admin-username azureuser --generate-ssh-keys

# setup db

# setup geo tools

# setup databricks


