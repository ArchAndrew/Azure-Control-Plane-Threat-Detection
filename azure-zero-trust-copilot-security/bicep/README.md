# Bicep Deployment Artifact

This Bicep file provides an optional Azure-native Infrastructure-as-Code deployment for the monitoring layer of the lab.

It provisions:

- Log Analytics Workspace
- Microsoft Sentinel onboarding
- Basic tagging
- 30-day retention

The original lab was executed manually using Azure CLI to simulate real-world security operations and control-plane event validation. 
This Bicep file demonstrates how the monitoring foundation could be deployed repeatably in a production-style environment.
