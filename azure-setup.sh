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

Install-Module -Name Az.Databricks -AllowPrerelease
Register-AzResourceProvider -ProviderNamespace Microsoft.Databricks
New-AzDatabricksWorkspace -Name geodatabricks -ResourceGroupName geodatalake-fi-rg -Location westeurope -ManagedResourceGroupName databricks-group -Sku standard

Get-AzDatabricksWorkspace -Name geodatabricks -ResourceGroupName geodatalake-fi-rg |
  Select-Object -Property Name, SkuName, Location, ProvisioningState

pip install databricks-cli --upgrade

#add vnet peering from databricks to geodb-vm (at databricks side)
#https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/vnet-peering#step-1-add-remote-virtual-network-peering-to-the-azure-databricks-virtual-network

# add peering at vnet side
# https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/vnet-peering#step-2-add-the-azure-databricks-virtual-network-peer-to-the-remote-virtual-network