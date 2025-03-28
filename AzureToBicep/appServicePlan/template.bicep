param serverfarms_WestUS2Plan_name string = 'WestUS2Plan'

resource serverfarms_WestUS2Plan_name_resource 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: serverfarms_WestUS2Plan_name
  location: 'West US 2'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}
