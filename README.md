Open load balanced port 80 on all VMs of a recovery plan group
==============================================================

            

 

This script can be used to add a load balanced endpoint on a recovery plan group.

Create a ASR recovery plan for your application. If your web tier is a farm that has multiple frontend virtual machines all serving on port 80, you can use this script to create a load balanced endpoint on the cloud service. This
 script uses the default probe to check which front end VM is running an ready to serve. Place this script after a group to enable endpoint on all VMs of that group.

This is just a sample script. After importing the script into your Azure Automation account you cvan change the script and its variables to suit your needs.

        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
