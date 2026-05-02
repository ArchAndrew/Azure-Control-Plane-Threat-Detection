# Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations

## TL;DR

I built a Zero Trust, identity-centric detection pipeline in Azure that:

- Detects RBAC privilege escalation events in real time
- Correlates identity, IP, and role assignment activity
- Uses Microsoft Sentinel for detection and investigation
- Leverages AI (Copilot) to accelerate security analysis

This project simulates a real-world cloud attack scenario and demonstrates how I design detection systems, not just deploy infrastructure.

## 🚨 Here's the problem 

In cloud environments, identity is the primary attack surface. 

A compromised identity with sufficient privileges can:
- Assign roles to itself or others
- Escalate privileges silently
- Gain persistent access to critical resources

Traditional monitoring often misses these control-plane changes.

This project simulates and detects a realistic cloud privilege escalation attack path:
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

### Detection Objective

Identify **privilege escalation risk** by detecting successful RBAC role assignments across the Azure control plane.

### Detection Signal

- Operation: roleAssignments/write
- Status: Success
- Actor: Caller identity
- Source: Caller IP address
- Context: RoleDefinitionId from Properties

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

A compromised identity with role assignment permissions can grant itself elevated access without triggering traditional alerts.

This detection surfaces that behavior.

---

# 📸 7. Proof of Execution 

### RBAC Role Assignment Event Triggered

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_role_assignment_write_event2.png style="width:1000px;">

### Activity Log Event Captured

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_Activity%20Log%20Event%20Captured.png style="width:1000px;">

### Logs Ingested into Log Analytics

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_Activity%20Log%20Event%20Captured%20(2).png style="width:1000px;">

### KQL Detection Query Results

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_role_assignments_KQL4.png style="width:1000px;">

### Expanded Event Details (Deep Inspection)

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_Deep_inspection.png style="width:1000px;">

### AI-Assisted Analysis (Copilot)
<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/AI-Assisted_3.png style="width:700px;">


## ⚠️ Security Scenario: Privilege Escalation Detection

1. A user performs a role assignment in Azure
2. The action is logged in Azure Activity Logs
3. “Control-plane telemetry is streamed to Log Analytics for centralized detection
4. Microsoft Sentinel queries detect the event
5. The event is analyzed for:
   - Caller identity
   - Source IP address
   - Role assigned
6. AI-assisted analysis accelerates triage and reduces investigation time

## Operational Insights

During testing, several important behaviors were observed:

- Azure Activity Logs are not immediately available in Log Analytics (ingestion delay ~2–5 minutes)
- RBAC events generate both "Start" and "Success" states
- External IP visibility enables detection of non-corporate access
- Diagnostic settings must be configured at the subscription level for full coverage

These observations reflect real-world SOC challenges in cloud environments.

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
Cloud Security Architect | CISSP | DevSecOps | Zero Trust Architecture

thee_architect_was_here
