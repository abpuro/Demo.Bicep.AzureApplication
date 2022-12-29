@description('Storage location')
param location string

@description('Storage name')
param storage_name string

@description('User assigned identity name')
param uai_name string

resource userassignedidentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: uai_name
  location: location
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storage_name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(userassignedidentity.id,storageaccount.id)
  scope: storageaccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalId: userassignedidentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}


