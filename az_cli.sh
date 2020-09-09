#!/bin/bash

RG1=autoscale
RG2=autoscale_ne
LOC1=westeurope
LOC2=northeurope

#
# Create web vm instance, and an image from it
#

VMWEBRG=autoscale

az deployment group create --resource-group $VMWEBRG \
  --template-file /mnt/c/GitHub/flask_note_jam/arm_vmweb_template.json \
  --parameters /mnt/c/GitHub/flask_note_jam/arm_vmweb_template.parameters.json

az sig image-version create \
   --resource-group $RG1 \
   --gallery-name notejam_gallery \
   --gallery-image-definition notejam_vm \
   --gallery-image-version 2.0.0 \
   --target-regions "westeurope=1" "northeurope=1" "uksouth=1" \
   --managed-image "/subscriptions/41418fe7-80f5-4492-baab-123b3af45a7d/resourceGroups/autoscale/providers/Microsoft.Compute/virtualMachines/vmweb"

#
# Create image gallery and add image from vm3buster vm
#

az group create --name $RG1 --location $LOC1

az sig create --resource-group $RG1 --gallery-name notejam_gallery

az sig image-definition create \
   --resource-group $RG1 \
   --gallery-name notejam_gallery \
   --gallery-image-definition notejam_vm \
   --publisher PyAppSolutions \
   --offer Debian \
   --sku Buster \
   --os-type Linux \
   --os-state specialized

az sig image-version create \
   --resource-group $RG1 \
   --gallery-name notejam_gallery \
   --gallery-image-definition notejam_vm \
   --gallery-image-version 1.0.0 \
   --target-regions "$LOC1=1" "$LOC2=1" \
   --managed-image "/subscriptions/41418fe7-80f5-4492-baab-123b3af45a7d/resourceGroups/autoscale/providers/Microsoft.Compute/virtualMachines/vm3buster"

#
# Create VMSS with AG in a region
#

# az group delete --name $RG2 --yes --no-wait

VNET=vnet03_ne
SS=ss03_ne

az group create --name $RG2 --location $LOC2

az deployment group create --resource-group $RG2 \
  --template-file /mnt/c/GitHub/flask_note_jam/arm_net_template.json \
  --parameters /mnt/c/GitHub/flask_note_jam/arm_net_template.parameters.json

az network vnet create -g $RG2 -n $VNET --address-prefix 10.3.0.0/16 --subnet-name ss_subnet --subnet-prefix 10.3.0.0/24

az network vnet subnet create -g $RG2 --vnet-name $VNET -n ag_subnet --address-prefixes 10.3.1.0/24

az network public-ip create -g $RG2 --location $LOC2 -n pip03_ne --allocation-method Static --sku Standard --version IPv4

az vmss create \
   --resource-group $RG2 \
   --location $LOC2 \
   --name $SS \
   --image "/subscriptions/41418fe7-80f5-4492-baab-123b3af45a7d/resourceGroups/autoscale/providers/Microsoft.Compute/galleries/notejam_gallery/images/notejam_vm/versions/1.0.0" \
   --specialized \
   --vnet-name $VNET \
   --subnet ss_subnet \
   --zones 1 2 3 \
   --instance-count 2 \
   --vm-sku Standard_B1ms \
   --app-gateway "" \
   --load-balancer "" \
   --generate-ssh-keys

#
# Create solution with ARM template
#

# create RG in a selected region
az group create --name $RG2 --location $LOC2

# create NSG, VNET, PIP, VMSS and AG
az deployment group create --resource-group $RG2 \
  --template-file /mnt/c/GitHub/flask_note_jam/arm_net_template.json \
  --parameters /mnt/c/GitHub/flask_note_jam/arm_net_template.parameters.json

# 1. Manual step - edit AG backend poll and add VMSS as a target
# 2. Manual step - upgrade VMSS instances
# 3. Manual step - update DNS to point to a new PIP of AG
# 4. Optional step - if not using currently this solution then deallocate VMSS to save money
# 5. Optional step - create VNET peering to another VNET with internet reachable VM to ensure connectivity
