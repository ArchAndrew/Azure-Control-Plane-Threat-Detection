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

This screenshot shows a successful Azure RBAC role assignment performed via Azure CLI.
The role was assigned at the subscription scope, demonstrating how identity-based access changes can impact the entire environment.

While the assigned role in this lab is Reader (least privilege), the same mechanism can be abused to grant Owner or Contributor, leading to full privilege escalation.
This event is captured in Azure Activity Logs and forms the basis for detection in Microsoft Sentinel.
In production environments, this type of event is high-risk because attackers commonly escalate privileges by assigning roles to compromised identities.

⚠️ Note: RoleDefinitionId is shown instead of role name due to raw CLI output. In practice, this maps to the Reader role.

### Activity Log Event Captured

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_Activity%20Log%20Event%20Captured.png style="width:1000px;">

This screenshot shows an Azure Activity Log event captured in Log Analytics for a successful RBAC role assignment (`roleAssignments/write`).

The event lifecycle is visible, including both the initiation (`Start`) and completion (`Success`) stages. This confirms that a control-plane permission change was successfully executed.

Key fields highlighted:

- OperationNameValue → identifies the RBAC role assignment action
- ActivityStatusValue → confirms the outcome (Success)
- TimeGenerated → shows when the change occurred

This type of event is critical for detecting potential privilege escalation, as attackers may assign elevated roles to gain persistent access.

### Logs Ingested into Log Analytics

**Querying AzureActivity table (control-plane logs):**

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_logs_ingested_query.png style="width:1000px;">

**Expanded RBAC event captured in Log Analytics:**

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_logs_ingested.png style="width:1000px;">


### KQL Detection Query Results

**Detecting RBAC role assignment events (control-plane changes):**

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_role_assignments_KQL4.png style="width:1000px;">

### Expanded Event Details (Deep Inspection)

This view shows the **expanded AzureActivity log event**, allowing full inspection of the control-plane operation responsible for the RBAC change.

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/Annotated_Deep_inspection.png style="width:1000px;">

- **Caller / Identity**
  - The authenticated identity that performed the action is visible in the `Claims` and `Caller` fields.
  - This enables attribution of the RBAC change to a specific user or service principal.

- **Source of Request**
  - `clientIpAddress` identifies where the request originated from.
  - Useful for detecting suspicious or non-corporate access patterns.

- **Role Assigned**
  - The `roleDefinitionId` inside the `Properties` payload identifies the exact RBAC role granted.
  - This is critical for determining privilege level (e.g., Reader vs Contributor vs Owner).

- **Scope of Access**
  - The `Authorization` field shows the scope (`subscription`, `resource group`, etc.).
  - This defines the **blast radius** of the permission change.

- **Operation Performed**
  - `MICROSOFT.AUTHORIZATION/ROLEASSIGNMENTS/WRITE` indicates a control-plane RBAC modification.

#### Security Relevance

RBAC role assignments are high-impact control-plane actions.  
Improper or malicious assignments can lead to:

- Privilege escalation  
- Unauthorized access to sensitive resources  
- Persistence mechanisms for attackers  

This inspection bridges detection and investigation, enabling validation of identity, scope, and privilege impact for RBAC changes.


### AI-Assisted Analysis (Copilot)
<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/screenshots/AI-Assisted_3.png style="width:500px;">

Microsoft Copilot was used to interpret the RBAC role assignment event and provide a high-level security assessment.

The analysis highlights:

- The importance of monitoring control-plane changes
- Increased risk when actions originate from external IP addresses
- The need to validate that access is granted only to authorized identities

This demonstrates how AI can assist analysts by translating raw log data into actionable security insights, improving response time and decision-making.

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
