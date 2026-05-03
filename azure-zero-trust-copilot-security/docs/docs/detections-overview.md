# Detection Library Overview

This project includes multiple detection use cases aligned to identity-based threats in Azure:

## RBAC & Privilege Escalation
- rbac-role-assignment-changes.kql
- rbac-role-assignment-external-ip.kql
- failed-rbac-role-assignments.kql

## Identity & Access Risk
- failed-logins.kql
- conditional-access-policy-changes.kql

## Sensitive Resource Access
- keyvault-secret-access.kql
- keyvault-secret-access-anomalies.kql

## Network Exposure
- public-ip-creation.kql

---

## Detection Strategy

These detections focus on:

- Control-plane activity monitoring (AzureActivity)
- Identity-based attack paths
- External access patterns
- Privilege escalation indicators

---

## Design Philosophy

- Detect **high-impact actions**, not just noise
- Prioritize **identity-centric attack paths**
- Assume **compromised identity is the attacker entry point**
