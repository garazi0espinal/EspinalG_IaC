param virtualMachines string
param disks_externalid string 
param nic_externalid string

resource virtualMachines_az104_05_vm0_name_resource 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: virtualMachines
  location: 'eastus'
  tags: {
    'cor-ctx-environment': 'sandbox/testing'
    'cor-ctx-owner': 'Infra & Com'
    'cor-ctx-projectcode': 'PoC.IaC'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines}_disk1_9eb110b06ae94bce95aa596e607bdb01'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Detach'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines
      adminUsername: 'Student'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic_externalid
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource newNetworkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${virtualMachines}-nic'
  location: 'eastus'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[0].id //CREAR VIRTUALNETWORK!!!!!!!!!!!!!
          }
        }
      }
    ]
  }
}
