<#
.SYNOPSIS
    Runbook to add a load balanced endpoint on a cloud service. 
    This script needs to be used along with recovery plans in Azure Site Recovery.

.DESCRIPTION
    This runbook provides you a way to open a load balanced endpoint on all VMs of a recovery plan group.
    Create a ASR recovery plan for your application. 
    If you web tier is a farm that has multiple frontend virtual machines all serving on
    port 80, you can use this script to create a load balanced endpoint on the cloud service.
    This script uses the default probe to check which front end VM is running and ready to serve.
    
    Place this script after a group to enable endpoint on all VMs of the group.
   
.PARAMETER Name
    RecoveryPlanContext is the only parameter you need to define.
    This parameter gets the failover context from the recovery plan. 

.NOTES
	Author: Ruturaj M. Dhekane - ruturajd@microsoft.com 
	Last Updated: 28/04/2015   
#>

workflow OpenLoadBalancedPort80
{
    param (
        [Object]$RecoveryPlanContext
    )

    $Cred = Get-AutomationPSCredential -Name 'AzureCredential'

    # Connect to Azure
    $AzureAccount = Add-AzureAccount -Credential $Cred
    $AzureSubscriptionName = Get-AutomationVariable –Name ‘AzureSubscriptionName’
    Select-AzureSubscription -SubscriptionName $AzureSubscriptionName

    # Specify the parameters to be used by the script
    # Specify the load balanced port endpoint protocol
    # LBELocalPort will be same for all VMs
    # LBEPublicPort will be opened on the cloud service as a load balanced port
    
    $LBEProtocol = "TCP"
    $LBELocalPort = 80
    $LBEPublicPort = 80
    $LBEName = "Port 80 for HTTP"
    $VMEName = "Port 80"
    
    # Loop through every VM in the VmMap
    $vmMap = $RecoveryPlanContext.VmMap.PsObject.Properties
    
    foreach($VMProperty in $vmMap)
    {
        $VM = $VMProperty.Value
        Write-Output "Processing for " + $VM.RoleName
        
        # Invoke pipeline commands within an InlineScript

        InlineScript {
            # Invoke the necessary pipeline commands to add a Azure Endpoint to a specified Virtual Machine
            # This set of commands includes: Get-AzureVM | Add-AzureEndpoint | Update-AzureVM (including necessary parameters)
            
            $Status = Get-AzureVM -ServiceName $Using:VM.CloudServiceName -Name $Using:VM.RoleName | `
                Add-AzureEndpoint -Name $Using:VMEName -Protocol $Using:LBEProtocol `
                    -PublicPort $Using:LBEPublicPort -LocalPort $Using:LBELocalPort `
                    -DefaultProbe -LBSetName $Using:LBEName | `
                    Update-AzureVM
            Write-Output $Status
        }
    }
    
  }