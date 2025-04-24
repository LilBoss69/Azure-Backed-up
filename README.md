{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vulnerabilityAssessments_Default_storageContainerPath": {
            "type": "SecureString"
        },
        "workspaces_adb_nh_project_name": {
            "defaultValue": "adb-nh-project",
            "type": "String"
        },
        "workspaces_nhproject_synapse_name": {
            "defaultValue": "nhproject-synapse",
            "type": "String"
        },
        "storageAccounts_nhdefaultsynapse_name": {
            "defaultValue": "nhdefaultsynapse",
            "type": "String"
        },
        "storageAccounts_nhstoragedatalake_name": {
            "defaultValue": "nhstoragedatalake",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Databricks/workspaces",
            "apiVersion": "2024-09-01-preview",
            "name": "[parameters('workspaces_adb_nh_project_name')]",
            "location": "eastus",
            "sku": {
                "name": "premium"
            },
            "properties": {
                "defaultCatalog": {
                    "initialType": "UnityCatalog"
                },
                "managedResourceGroupId": "/subscriptions/3c97065e-007a-420a-9699-a1d4b91d017a/resourceGroups/manage-adb-ngproject",
                "parameters": {
                    "enableNoPublicIp": {
                        "value": false
                    },
                    "natGatewayName": {
                        "value": "nat-gateway"
                    },
                    "prepareEncryption": {
                        "value": false
                    },
                    "publicIpName": {
                        "value": "nat-gw-public-ip"
                    },
                    "requireInfrastructureEncryption": {
                        "value": false
                    },
                    "storageAccountName": {
                        "value": "dbstoragepsgkqcdts26ec"
                    },
                    "storageAccountSkuName": {
                        "value": "Standard_GRS"
                    },
                    "vnetAddressPrefix": {
                        "value": "10.139"
                    }
                },
                "authorizations": [
                    {
                        "principalId": "9a74af6f-d153-4348-988a-e2672920bee9",
                        "roleDefinitionId": "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
                    }
                ],
                "createdBy": {},
                "updatedBy": {}
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2024-01-01",
            "name": "[parameters('storageAccounts_nhdefaultsynapse_name')]",
            "location": "eastus",
            "sku": {
                "name": "Standard_RAGRS",
                "tier": "Standard"
            },
            "kind": "StorageV2",
            "properties": {
                "allowCrossTenantReplication": false,
                "minimumTlsVersion": "TLS1_2",
                "allowBlobPublicAccess": false,
                "isHnsEnabled": true,
                "networkAcls": {
                    "bypass": "AzureServices",
                    "virtualNetworkRules": [],
                    "ipRules": [],
                    "defaultAction": "Allow"
                },
                "supportsHttpsTrafficOnly": true,
                "encryption": {
                    "services": {
                        "file": {
                            "keyType": "Account",
                            "enabled": true
                        },
                        "blob": {
                            "keyType": "Account",
                            "enabled": true
                        }
                    },
                    "keySource": "Microsoft.Storage"
                },
                "accessTier": "Hot"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2024-01-01",
            "name": "[parameters('storageAccounts_nhstoragedatalake_name')]",
            "location": "eastus",
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "kind": "StorageV2",
            "properties": {
                "dnsEndpointType": "Standard",
                "defaultToOAuthAuthentication": false,
                "publicNetworkAccess": "Enabled",
                "allowCrossTenantReplication": false,
                "isSftpEnabled": false,
                "minimumTlsVersion": "TLS1_2",
                "allowBlobPublicAccess": false,
                "allowSharedKeyAccess": true,
                "largeFileSharesState": "Enabled",
                "isHnsEnabled": true,
                "networkAcls": {
                    "bypass": "AzureServices",
                    "virtualNetworkRules": [],
                    "ipRules": [],
                    "defaultAction": "Allow"
                },
                "supportsHttpsTrafficOnly": true,
                "encryption": {
                    "requireInfrastructureEncryption": false,
                    "services": {
                        "file": {
                            "keyType": "Account",
                            "enabled": true
                        },
                        "blob": {
                            "keyType": "Account",
                            "enabled": true
                        }
                    },
                    "keySource": "Microsoft.Storage"
                },
                "accessTier": "Hot"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhdefaultsynapse_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhdefaultsynapse_name'))]"
            ],
            "sku": {
                "name": "Standard_RAGRS",
                "tier": "Standard"
            },
            "properties": {
                "cors": {
                    "corsRules": []
                },
                "deleteRetentionPolicy": {
                    "allowPermanentDelete": false,
                    "enabled": false
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "properties": {
                "containerDeleteRetentionPolicy": {
                    "enabled": true,
                    "days": 7
                },
                "cors": {
                    "corsRules": []
                },
                "deleteRetentionPolicy": {
                    "allowPermanentDelete": false,
                    "enabled": true,
                    "days": 7
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/fileServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhdefaultsynapse_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhdefaultsynapse_name'))]"
            ],
            "sku": {
                "name": "Standard_RAGRS",
                "tier": "Standard"
            },
            "properties": {
                "protocolSettings": {},
                "cors": {
                    "corsRules": []
                },
                "shareDeleteRetentionPolicy": {
                    "enabled": true,
                    "days": 7
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/fileServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "properties": {
                "protocolSettings": {},
                "cors": {
                    "corsRules": []
                },
                "shareDeleteRetentionPolicy": {
                    "enabled": true,
                    "days": 7
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/queueServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhdefaultsynapse_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhdefaultsynapse_name'))]"
            ],
            "properties": {
                "cors": {
                    "corsRules": []
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/queueServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "properties": {
                "cors": {
                    "corsRules": []
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/tableServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhdefaultsynapse_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhdefaultsynapse_name'))]"
            ],
            "properties": {
                "cors": {
                    "corsRules": []
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/tableServices",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "properties": {
                "cors": {
                    "corsRules": []
                }
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces",
            "apiVersion": "2021-06-01",
            "name": "[parameters('workspaces_nhproject_synapse_name')]",
            "location": "eastus",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhdefaultsynapse_name'))]"
            ],
            "identity": {
                "type": "SystemAssigned"
            },
            "properties": {
                "defaultDataLakeStorage": {
                    "resourceId": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhdefaultsynapse_name'))]",
                    "createManagedPrivateEndpoint": false,
                    "accountUrl": "https://nhdefaultsynapse.dfs.core.windows.net",
                    "filesystem": "nhdefaultfilesystem"
                },
                "encryption": {},
                "managedResourceGroupName": "[concat('rg-manage-', parameters('workspaces_nhproject_synapse_name'))]",
                "sqlAdministratorLogin": "sqladminuser",
                "privateEndpointConnections": [],
                "publicNetworkAccess": "Enabled",
                "cspWorkspaceAdminProperties": {
                    "initialWorkspaceAdminObjectId": "1c02279c-07f4-4bd1-8706-8cc00343e333"
                },
                "azureADOnlyAuthentication": false,
                "trustedServiceBypassEnabled": false
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/auditingSettings",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/Default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "retentionDays": 0,
                "auditActionsAndGroups": [],
                "isStorageSecondaryKeyInUse": false,
                "isAzureMonitorTargetEnabled": false,
                "state": "Disabled",
                "storageAccountSubscriptionId": "00000000-0000-0000-0000-000000000000"
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/azureADOnlyAuthentications",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "azureADOnlyAuthentication": false
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/dedicatedSQLminimalTlsSettings",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/default')]",
            "location": "eastus",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "minimalTlsVersion": "1.2"
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/extendedAuditingSettings",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/Default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "retentionDays": 0,
                "auditActionsAndGroups": [],
                "isStorageSecondaryKeyInUse": false,
                "isAzureMonitorTargetEnabled": false,
                "state": "Disabled",
                "storageAccountSubscriptionId": "00000000-0000-0000-0000-000000000000"
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/firewallRules",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/allowAll')]",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "startIpAddress": "0.0.0.0",
                "endIpAddress": "255.255.255.255"
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/integrationruntimes",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/AutoResolveIntegrationRuntime')]",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "type": "Managed",
                "typeProperties": {
                    "computeProperties": {
                        "location": "AutoResolve"
                    }
                }
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/securityAlertPolicies",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/Default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "state": "Enabled",
                "disabledAlerts": [
                    ""
                ],
                "emailAddresses": [
                    ""
                ],
                "emailAccountAdmins": false,
                "retentionDays": 0
            }
        },
        {
            "type": "Microsoft.Synapse/workspaces/vulnerabilityAssessments",
            "apiVersion": "2021-06-01",
            "name": "[concat(parameters('workspaces_nhproject_synapse_name'), '/Default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Synapse/workspaces', parameters('workspaces_nhproject_synapse_name'))]"
            ],
            "properties": {
                "recurringScans": {
                    "isEnabled": false,
                    "emailSubscriptionAdmins": true
                },
                "storageContainerPath": "[parameters('vulnerabilityAssessments_Default_storageContainerPath')]"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default/bronze')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_nhstoragedatalake_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "properties": {
                "immutableStorageWithVersioning": {
                    "enabled": false
                },
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": false,
                "publicAccess": "None"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default/gold')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_nhstoragedatalake_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "properties": {
                "immutableStorageWithVersioning": {
                    "enabled": false
                },
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": false,
                "publicAccess": "None"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhdefaultsynapse_name'), '/default/nhdefaultfilesystem')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_nhdefaultsynapse_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhdefaultsynapse_name'))]"
            ],
            "properties": {
                "immutableStorageWithVersioning": {
                    "enabled": false
                },
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": false,
                "publicAccess": "None"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default/parameter')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_nhstoragedatalake_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "properties": {
                "immutableStorageWithVersioning": {
                    "enabled": false
                },
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": false,
                "publicAccess": "None"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2024-01-01",
            "name": "[concat(parameters('storageAccounts_nhstoragedatalake_name'), '/default/silver')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_nhstoragedatalake_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_nhstoragedatalake_name'))]"
            ],
            "properties": {
                "immutableStorageWithVersioning": {
                    "enabled": false
                },
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": false,
                "publicAccess": "None"
            }
        }
    ]
}
