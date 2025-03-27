param storageAccounts_name string

resource storageAccounts 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccounts_name
  location: 'northeurope'
  tags: {
    'cor-ctx-environment': 'sandbox/testing'
  }
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource storageAccounts_blobServices 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  parent: storageAccounts
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_fileServices 'Microsoft.Storage/storageAccounts/fileServices@2024-01-01' = {
  parent: storageAccounts
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_queueServices 'Microsoft.Storage/storageAccounts/queueServices@2024-01-01' = {
  parent: storageAccounts
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource storageAccounts_tableServices 'Microsoft.Storage/storageAccounts/tableServices@2024-01-01' = {
  parent: storageAccounts
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
