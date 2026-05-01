# Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations
AZ-104 aligned secure Azure architecture with Microsoft Sentinel + Copilot-driven investigation workflow.
This project demonstrates how identity-based attacks (RBAC privilege escalation) can be detected, analyzed, and investigated using Azure-native tooling.

## 🚨 Here's the problem 

In cloud environments, identity is the primary attack surface. 

A compromised identity with sufficient privileges can:
- Assign roles to itself or others
- Escalate privileges silently
- Gain persistent access to critical resources

Traditional monitoring often misses these control-plane changes.

This project simulates and detects:
> Unauthorized RBAC role assignment (privilege escalation scenario)

## 🏗️ Architecture Overview

This solution implements a control-plane detection pipeline:

1. Identity performs RBAC action (Entra ID)
2. Activity logs capture the event
3. Logs are streamed to Log Analytics
4. Microsoft Sentinel analyzes activity
5. KQL detection identifies suspicious role assignments
6. AI-assisted analysis (Copilot) explains impact

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/diagrams/ZTLZ_Architecture_diagram.png style="width:1000px;">


## 🔐 Key Security Design Decisions

- No public IPs on workloads (private-only VM)
- Bastion used for secure administrative access
- RBAC enforced via least privilege principles
- Centralized logging at subscription level
- Detection focused on identity-based threats

## 🌐 Network Architecture

The environment uses a hub-and-spoke topology:

- Hub VNet: shared services (Bastion, management)
- Spoke VNet: application workloads
- NSGs restrict traffic by default
- No direct inbound internet exposure

This design reduces blast radius and enforces segmentation.

## 🔍 Detection Logic

The following KQL query was developed and validated to detect RBAC role assignment activity:

```kql
AzureActivity
| where OperationNameValue has "roleAssignments"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, CallerIpAddress, OperationNameValue, ActivityStatusValue, Properties
| order by TimeGenerated desc
```

What this detects:
Successful RBAC role assignments
Who performed the action
From where (IP address)
What role change occurred

Why it matters:

RBAC changes can indicate privilege escalation or unauthorized access.

---

# 📸 7. Proof of Execution 

### RBAC Role Assignment Event Triggered
![Insert screenshot of Azure CLI role assignment command output here]

### Activity Log Event Captured
![Insert screenshot of Azure Activity Log showing roleAssignments/write event]

### Logs Ingested into Log Analytics
![Insert screenshot of Log Analytics workspace receiving AzureActivity logs]

### KQL Detection Query Results
![Insert screenshot of successful query results showing role assignment events]

### Expanded Event Details (Deep Inspection)
![Insert screenshot showing Properties, Caller, IP, RoleDefinitionId]

### AI-Assisted Analysis (Copilot)
![Insert screenshot of Copilot explanation of RBAC event]

## ⚠️ Security Scenario: Privilege Escalation Detection

1. A user performs a role assignment in Azure
2. The action is logged in Azure Activity Logs
3. Logs are streamed to Log Analytics via Diagnostic Settings
4. Microsoft Sentinel queries detect the event
5. The event is analyzed for:
   - Caller identity
   - Source IP address
   - Role assigned
6. AI-assisted analysis explains the security impact

### Outcome:
Full visibility into control-plane RBAC changes and ability to detect potential privilege escalation.

## 🧰 Azure Services Used

- Microsoft Entra ID (Azure AD)
- Azure Virtual Network (Hub-Spoke)
- Azure Bastion
- Azure Key Vault
- Azure Monitor (Activity Logs)
- Log Analytics Workspace
- Microsoft Sentinel
- Azure CLI

## 🧠 What This Demonstrates

- Zero Trust architecture design
- Identity-centric security strategy
- Control plane monitoring and detection
- KQL-based threat detection
- SIEM integration with Microsoft Sentinel
- Security event investigation workflows
- AI-assisted security analysis

## 📈 Real-World Impact

This type of detection is critical in real environments to:

- Detect privilege escalation attempts
- Identify unauthorized access
- Monitor administrative actions
- Support SOC investigations

These patterns are commonly used in enterprise cloud security operations.

## 🚀 Future Enhancements

- Alert rule creation for automated detection
- Integration with incident response workflows
- External IP anomaly detection
- Role sensitivity classification (Owner vs Reader)
- Automation via Logic Apps / SOAR


---

**Built by Arch_Andrew**  
Cloud Security | DevSecOps | Zero Trust Architecture

"thee_architect_was_here"
