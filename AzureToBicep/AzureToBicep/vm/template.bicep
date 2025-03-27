param virtualMachines_az104_05_vm0_name string = 'az104-05-vm0'
param disks_az104_05_vm0_disk1_9eb110b06ae94bce95aa596e607bdb01_externalid string = '/subscriptions/a16a92cf-c00b-46af-9178-bce05dd8438d/resourceGroups/rg-mazneu-cor-a-sandbox-espinalg-001/providers/Microsoft.Compute/disks/az104-05-vm0_disk1_9eb110b06ae94bce95aa596e607bdb01'
param networkInterfaces_az104_05_nic0_externalid string = '/subscriptions/a16a92cf-c00b-46af-9178-bce05dd8438d/resourceGroups/rg-mazneu-cor-a-sandbox-espinalg-001/providers/Microsoft.Network/networkInterfaces/az104-05-nic0'

resource virtualMachines_az104_05_vm0_name_resource 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: virtualMachines_az104_05_vm0_name
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
        name: '${virtualMachines_az104_05_vm0_name}_disk1_9eb110b06ae94bce95aa596e607bdb01'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: disks_az104_05_vm0_disk1_9eb110b06ae94bce95aa596e607bdb01_externalid
        }
        deleteOption: 'Detach'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az104_05_vm0_name
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
          id: networkInterfaces_az104_05_nic0_externalid
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}
