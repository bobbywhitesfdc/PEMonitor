# Platform Event Monitoring LWC

A Salesforce DX Unmanaged Package to deploy a Lightning Web Component that helps to Monitor Subscriptions to Platform Events.

## Dev -- Deploy to Scratch Org

Create a default scratch org for this project and deploy all of the source to it.
<br/>
<code>sfdx force:org:create -f config/project-scratch-def.json -s -a MyScratchOrg</code><br/>
<code>sfdx force:source:push</code>
<br/>

## Dev -- Deploy to Sandbox 

First, if you have not already authenticated to your Sandbox using the SFDX CLI, you'll want to do this first.  Once you enter the command, a browser window will appear and you'll need to enter your username and password.  Once authenticated, you will be asked to Authorize SFDX CLI to use it.
<br/>
<code>
  sfdx force:auth:web:login -a <emp>sandbox_username</emp> -r https://test.salesforce.com
  <br/>
</code>
<br/>
Next you convert the SFDX source code to package format and deploy it to your Sandbox!
<br/>
<code>
sfdx force:source:convert -d temp/ --packagename PEMonitor
  <br/>
  sfdx force:mdapi:deploy -d temp/ -u <emp>sandbox_username</emp> -l RunSpecifiedTests -r PlatformEventMonitoringController_Test
  <br/>
</code>

## Post Deployment Steps

<ol>
  <li>In Setup, Add the platformEventMonitorTable LWC to a new or existing Lightning Page</li>
  <li>Assign the 'Monitor Platform Events' permission set to any users</li>
</ol>

## Issues
