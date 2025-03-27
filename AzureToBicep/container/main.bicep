param registries_name string = 'registryespinalg001'

resource registries 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' = {
  name: registries_name
  location: 'northeurope'
  tags: {
    'cor-ctx-environment': 'sandbox/testing'
    'cor-ctx-owner': 'Infra & Com'
    'cor-ctx-projectcode': 'PoC.IaC'
  }
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    adminUserEnabled: false
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
      azureADAuthenticationAsArmPolicy: {
        status: 'enabled'
      }
      softDeletePolicy: {
        retentionDays: 7
        status: 'disabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
    metadataSearch: 'Disabled'
  }
}

resource registries_repositories_admin 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries
  name: '_repositories_admin'
  properties: {
    description: 'Can perform all read, write and delete operations on the registry'
    actions: [
      'repositories/*/metadata/read'
      'repositories/*/metadata/write'
      'repositories/*/content/read'
      'repositories/*/content/write'
      'repositories/*/content/delete'
    ]
  }
}

resource registries_repositories_pull 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries
  name: '_repositories_pull'
  properties: {
    description: 'Can pull any repository of the registry'
    actions: [
      'repositories/*/content/read'
    ]
  }
}

resource registries_repositories_pull_metadata_read 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries
  name: '_repositories_pull_metadata_read'
  properties: {
    description: 'Can perform all read operations on the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/metadata/read'
    ]
  }
}

resource registries_repositories_push 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries
  name: '_repositories_push'
  properties: {
    description: 'Can push to any repository of the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/content/write'
    ]
  }
}

resource registries_repositories_push_metadata_write 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries
  name: '_repositories_push_metadata_write'
  properties: {
    description: 'Can perform all read and write operations on the registry'
    actions: [
      'repositories/*/metadata/read'
      'repositories/*/metadata/write'
      'repositories/*/content/read'
      'repositories/*/content/write'
    ]
  }
}
