# Platform Event Monitoring LWC

A Salesforce DX Unmanaged Package to deploy a Lightning Web Component that helps to Monitor Subscriptions to Platform Events.

## Dev -- Deploy to Scratch Org

Create a default scratch org for this project and deploy all of the source to it.

sfdx force:org:create -f config/project-scratch-def.json -s -a MyScratchOrg
sfdx force:source:push 

## Dev -- Deploy to Sandbox 
sfdx force:source:convert -d temp/ --packagename PEMonitor
sfdx force:mdapi:deploy -d temp/ -u "sandbox_username" -l RunSpecifiedTests -r PlatformEventMonitoringController_Test 

## Issues