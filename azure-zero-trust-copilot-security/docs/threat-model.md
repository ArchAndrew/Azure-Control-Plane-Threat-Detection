# 🛡️ Threat Model

## Azure RBAC Privilege Escalation Detection (Zero Trust Pipeline)

---

## 🟦 1. Overview

This project models and detects **identity-driven privilege escalation** in Azure through **RBAC role assignment abuse**.

The focus is on **control-plane activity**, where attackers leverage legitimate APIs (`roleAssignments/write`) to escalate access without deploying malware.

This reflects a core Zero Trust principle:

> **Assume identity is the primary attack surface.**

---

## 🟦 2. Assets

| Asset                                   | Description                                       |
| --------------------------------------- | ------------------------------------------------- |
| Azure Subscription                      | Control-plane boundary                            |
| RBAC Roles                              | Define access levels (Reader, Contributor, Owner) |
| Identities (Users / Service Principals) | Authentication and authorization entities         |
| Azure Resources                         | Compute, storage, secrets, networking             |
| Azure Activity Logs                     | Source of control-plane telemetry                 |
| Log Analytics Workspace                 | Centralized log ingestion                         |
| Microsoft Sentinel                      | Detection and investigation platform              |

---

## 🟦 3. Threat Actors

| Actor                         | Description                                   |
| ----------------------------- | --------------------------------------------- |
| External Attacker             | Gains access via phishing or credential theft |
| Insider Threat                | Misuses legitimate permissions                |
| Compromised Service Principal | Used for automation-based abuse               |
| Red Team                      | Simulated adversary behavior                  |

---

## 🟦 4. Attack Surface

* Azure RBAC API (`Microsoft.Authorization/roleAssignments/write`)
* Azure CLI / PowerShell
* Azure Portal
* Service principal credentials
* External IP-based access

---

## 🟦 5. Primary Attack Scenario

### 🎯 RBAC Privilege Escalation

1. Attacker compromises an identity
2. Identity has permission (or misconfiguration) to assign roles
3. Attacker executes:

   ```bash
   az role assignment create ...
   ```
4. Assigns elevated role:

   * Contributor
   * Owner
5. Gains expanded access across subscription/resources

---

## 🟦 6. STRIDE Analysis

| Category               | Example                                            |
| ---------------------- | -------------------------------------------------- |
| Spoofing               | Use of stolen credentials                          |
| Tampering              | Unauthorized RBAC role assignment                  |
| Repudiation            | Lack of monitoring or audit visibility             |
| Information Disclosure | Access to sensitive resources (Key Vault, storage) |
| Denial of Service      | Resource disruption via elevated permissions       |
| Elevation of Privilege | Core threat (RBAC abuse)                           |

---

## 🟦 7. MITRE ATT&CK Mapping (Cloud)

| Tactic               | Technique                        | ID            | Description                               |
| -------------------- | -------------------------------- | ------------- | ----------------------------------------- |
| Initial Access       | Valid Accounts                   | T1078         | Attacker uses compromised credentials     |
| Persistence          | Account Manipulation             | T1098         | Role assignment enables persistent access |
| Privilege Escalation | Account Manipulation             | T1098         | Elevating privileges via RBAC             |
| Defense Evasion      | Valid Accounts                   | T1078         | Legitimate API usage avoids detection     |
| Discovery            | Cloud Infrastructure Discovery   | T1580         | Identify roles and permissions            |
| Impact               | Resource Hijacking / Data Access | T1496 / T1530 | Abuse access to resources                 |

> 📌 Note: Azure RBAC abuse primarily maps to **T1098 (Account Manipulation)** in cloud environments.

---

## 🟦 8. Detection Strategy

This project implements **control-plane detection** using Azure Activity Logs.

### 🔍 Detection Signal

* Operation: `roleAssignments/write`
* Status: `Success`
* Actor: `Caller`
* Source: `CallerIpAddress`
* Context: `RoleDefinitionId` (from Properties)

### 🧠 Detection Logic

```kql
AzureActivity
| where OperationNameValue has "roleAssignments"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, CallerIpAddress, OperationNameValue, Properties
| order by TimeGenerated desc
```

---

## 🟦 9. Indicators of Suspicious Activity

* Role assignments from external IP addresses
* Unusual or new geographic login locations
* High-privilege roles assigned (Owner / Contributor)
* Unexpected identity performing assignment
* Activity outside normal business hours

---

## 🟦 10. Mitigations & Controls

### 🛡️ Preventive Controls

* Least privilege RBAC design
* Privileged Identity Management (PIM)
* MFA enforcement
* Conditional Access policies
* Restrict role assignment permissions

### 🔍 Detective Controls

* Azure Activity Log monitoring
* Microsoft Sentinel analytics rules
* External IP anomaly detection
* Identity behavior analytics

### ⚙️ Corrective Controls

* Role revocation
* Identity disablement
* Incident response workflows
* Forensic log analysis

---

## 🟦 11. Assumptions

* Activity Logs enabled at subscription level
* Logs ingested into Log Analytics
* Microsoft Sentinel configured
* Identity authentication is functioning normally

---

## 🟦 12. Limitations

* Detection is **post-event**
* Dependent on log ingestion latency (~2–5 minutes)
* Does not capture failed role assignment attempts
* Requires correct diagnostic settings

---

## 🟦 13. Residual Risk

* Short detection window before response
* Insider threats may appear legitimate
* External IP detection may generate false positives (VPN, remote work)

---

## 🟦 14. Future Enhancements

* Sentinel Analytics Rule for alerting
* SOAR automation (Logic Apps)
* Role sensitivity classification
* UEBA (User & Entity Behavior Analytics)
* Correlation with:

  * Sign-in Logs
  * Identity Protection risk signals

---

## 🟦 15. Key Takeaway

RBAC role assignments are **high-impact control-plane actions**.

A compromised identity can:

* Escalate privileges
* Persist access
* Impact entire subscriptions

👉 Detection must focus on:

* Identity
* Source (IP)
* Role context
* Scope of access

---

thee_architect_was_here

