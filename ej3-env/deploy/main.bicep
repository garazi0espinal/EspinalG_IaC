@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('Indicates whether to deploy the storage account for toy manuals.')
param deployToyManualsStorageAccount bool = true

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

@description('The URL to the product review API.')
param reviewApiUrl string

@secure()
@description('The API key to use when accessing the product review API.')
param reviewApiKey string

var appServiceAppName = 'toy-website-${resourceNameSuffix}'
var appServicePlanName = 'toy-website'
var applicationInsightsInstanceName = 'toywebsite'
var storageAccountName = 'mystorage${resourceNameSuffix}'

// Define the SKUs for each component based on the environment type.
var environmentConfigurationMap = {
  nonprod: {
    appServiceApp: {
      alwaysOn: false
    }
    appServicePlan: {
      sku: {
        name: 'F1'
        capacity: 1
      }
    }
    toyManualsStorageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
    }
  }
  prod: {
    appServiceApp: {
      alwaysOn: true
    }
    appServicePlan: {
      sku: {
        name: 'S1'
        capacity: 2
      }
    }
    toyManualsStorageAccount: {
      sku: {
        name: 'Standard_ZRS'
      }
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: environmentConfigurationMap[environmentType].appServicePlan.sku.name
    capacity: environmentConfigurationMap[environmentType].appServicePlan.sku.capacity
  }
}

resource applicationInsightsInstance 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: applicationInsightsInstanceName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsInstance.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsInstance.properties.ConnectionString
        }
        {
          name: 'ReviewApiUrl'
          value: reviewApiUrl
        }
        {
          name: 'ReviewApiKey'
          value: reviewApiKey
        }
      ]
    }
  }
}

resource toyManualsStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = if (deployToyManualsStorageAccount) {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: environmentConfigurationMap[environmentType].toyManualsStorageAccount.sku.name
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
