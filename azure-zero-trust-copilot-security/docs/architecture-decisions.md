## 📄 Architecture Decisions

This document outlines the key architectural decisions made in designing the Azure Zero Trust Landing Zone, along with the reasoning behind each choice.

---

##  🔐 Identity

### RBAC over access keys

Role-Based Access Control (RBAC) is used instead of access keys to enforce identity-based access.

- Access keys are static, difficult to rotate, and increase risk if exposed
- RBAC ties access to identities (users, groups, managed identities)
- Provides auditability through Azure Activity Logs

Decision:
Use RBAC to ensure all access is identity-driven, traceable, and centrally managed.

---

### Least privilege

All roles are scoped to the minimum permissions required.

- Reduces blast radius in case of compromise
- Prevents unnecessary access to sensitive resources
- Aligns with Zero Trust principles

Decision:
Users and services are only granted permissions necessary for their function.

### Break-glass account

A break-glass account is defined for emergency access.

- Used when normal authentication methods fail
- Typically excluded from Conditional Access policies
- Strictly monitored and rarely used

Decision:
Maintain a controlled emergency access path to prevent lockout scenarios.

---

### 🌐 Network

Hub-and-spoke architecture

A hub-and-spoke model is used to separate shared services from workloads.

- Hub contains shared services (Bastion, future firewall, logging)
- Spoke contains application workloads
- Enables centralized control and segmentation

Decision:
Use hub-and-spoke to reduce lateral movement and improve manageability.

### No public IPs

No workload resources are exposed directly to the internet.

### Reduces attack surface
Eliminates direct external access to VMs
Forces controlled access paths

Decision:
All administrative and service access must occur through controlled, private channels.

### Bastion for administrative access

Azure Bastion is used for secure VM access.

- Eliminates need for open SSH/RDP ports
- Uses browser-based access through Azure Portal
- Keeps management traffic within Azure

Decision:
Use Bastion to enforce secure, centralized administrative access.

--- 

## 🛡️ Security

Key Vault for secrets

Azure Key Vault is used for storing secrets and sensitive data.

- Centralized secret management
- Supports auditing and access control
- Eliminates hardcoded credentials

Decision:
All sensitive values are stored in Key Vault instead of application code or configs.

### Managed identity over credentials

Managed identities are used instead of storing credentials.

- Removes need for secret storage in applications
- Automatically managed by Azure
- Integrates with RBAC and Key Vault

Decision:
Use managed identities to enable secure, passwordless authentication.

### Sentinel for monitoring and detection

Microsoft Sentinel is used for centralized logging and threat detection.

- Aggregates logs from multiple services
- Enables detection through KQL queries
- Supports incident investigation workflows

Decision:
Use Sentinel to provide visibility into security events and enable detection of suspicious activity.

## Governance

Azure Policy

Azure Policy is used to enforce compliance and prevent misconfigurations.

- Prevents creation of insecure resources (e.g., public IPs)
- Ensures consistent configurations across environments
- Supports audit and compliance requirements

Decision:
Use policy-driven enforcement to reduce reliance on manual oversight.

## Tagging strategy

Tags are applied to all resources for organization and cost tracking.

- Enables cost allocation
- Identifies resource ownership
- Supports automation and reporting

Decision:
Use standardized tags across all resources to improve visibility and governance.

These decisions align with Zero Trust principles, emphasizing identity-based access, reduced attack surface, centralized control, and continuous monitoring.
