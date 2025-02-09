targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention, the name of the resource group for your application will use this name, prefixed with rg-')
param environmentName string

@minLength(1)
@description('The location used for all deployed resources')
param location string

@description('Id of the user or app to assign application roles')
param principalId string = ''

// @secure()
// param deepseekr1ai string
// @secure()
// param deploymentname string
// @secure()
// param endpoint string
// @secure()
// param tenantid string

var tags = {
  'azd-env-name': environmentName
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  scope: rg
  name: 'resources'
  params: {
    location: location
    tags: tags
    principalId: principalId
  }
}

////////////////////////////////////////
// START DEEPSEEK MODEL DEPLOYMENT
////////////////////////////////////////
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
// var disableKeyBasedAuth = true

var aiServicesNameAndSubdomain = 'deepseekr1-${resourceToken}'
module deepseekr1 'br/public:avm/res/cognitive-services/account:0.7.2' = {
  name: 'deepseek'
  scope: rg
  params: {
    name: aiServicesNameAndSubdomain
    location: location
    tags: tags
    kind: 'AIServices'
    customSubDomainName: aiServicesNameAndSubdomain
    publicNetworkAccess: 'Enabled'
    sku:  'S0'
    deployments: [
      {
        name: 'DeepSeek-R1'
        model: {
          format: 'DeepSeek'
          name: 'DeepSeek-R1'
          version: '1'
        }
        sku: {
          name: 'GlobalStandard'
          capacity: 1
        }
      }]
    disableLocalAuth: false
    roleAssignments: [
      {
        principalId: resources.outputs.MANAGED_IDENTITY_PRINCIPAL_ID 
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'        
      }
      {
        principalId: resources.outputs.MANAGED_IDENTITY_PRINCIPAL_ID
        roleDefinitionIdOrName: 'Cognitive Services User'
      }
      {
        principalId: principalId
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'        
      }
      {
        principalId: principalId
        roleDefinitionIdOrName: 'Cognitive Services User'
      }
    ]
  }
}

// deepseek output values
output DEEPSEEKR1__CONNECTIONSTRING string = 'Endpoint=https://${deepseekr1.outputs.name}.services.ai.azure.com/'
output DEEPSEEKR1_ENDPOINT string = 'https://${deepseekr1.outputs.name}.services.ai.azure.com/models/'
output DEEPSEEKR1_DEPLOYMENT_NAME string = 'DeepSeek-R1'
output DEEPSEEKR1_TENANT_ID string = resources.outputs.MANAGED_IDENTITY_TENANT_ID

////////////////////////////////////////
// END DEEPSEEK MODEL DEPLOYMENT
////////////////////////////////////////

output MANAGED_IDENTITY_CLIENT_ID string = resources.outputs.MANAGED_IDENTITY_CLIENT_ID
output MANAGED_IDENTITY_NAME string = resources.outputs.MANAGED_IDENTITY_NAME
output AZURE_LOG_ANALYTICS_WORKSPACE_NAME string = resources.outputs.AZURE_LOG_ANALYTICS_WORKSPACE_NAME
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = resources.outputs.AZURE_CONTAINER_REGISTRY_ENDPOINT
output AZURE_CONTAINER_REGISTRY_MANAGED_IDENTITY_ID string = resources.outputs.AZURE_CONTAINER_REGISTRY_MANAGED_IDENTITY_ID
output AZURE_CONTAINER_REGISTRY_NAME string = resources.outputs.AZURE_CONTAINER_REGISTRY_NAME
output AZURE_CONTAINER_APPS_ENVIRONMENT_NAME string = resources.outputs.AZURE_CONTAINER_APPS_ENVIRONMENT_NAME
output AZURE_CONTAINER_APPS_ENVIRONMENT_ID string = resources.outputs.AZURE_CONTAINER_APPS_ENVIRONMENT_ID
output AZURE_CONTAINER_APPS_ENVIRONMENT_DEFAULT_DOMAIN string = resources.outputs.AZURE_CONTAINER_APPS_ENVIRONMENT_DEFAULT_DOMAIN
