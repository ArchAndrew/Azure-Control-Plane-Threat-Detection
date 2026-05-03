@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Log Analytics workspace name')
param workspaceName string = 'law-ztlz-dev'

@description('Sentinel onboarding solution name')
param sentinelSolutionName string = 'SecurityInsights'

@description('Log retention in days')
param retentionInDays int = 30

@description('Tags applied to resources')
param tags object = {
  Project: 'Azure-Zero-Trust-Copilot'
  Environment: 'Dev'
  Purpose: 'RBAC-Detection-Lab'
  Owner: 'Arch_Andrew'
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource sentinelOnboarding 'Microsoft.SecurityInsights/onboardingStates@2023-02-01' = {
  name: 'default'
  scope: logAnalytics
  properties: {}
}

output workspaceId string = logAnalytics.id
output workspaceCustomerId string = logAnalytics.properties.customerId
output sentinelStatus string = 'Microsoft Sentinel onboarding configured for this Log Analytics workspace.'
