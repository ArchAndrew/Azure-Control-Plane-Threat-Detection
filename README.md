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

## Architecture Overview

This solution implements a control-plane detection pipeline:

1. Identity performs RBAC action (Entra ID)
2. Activity logs capture the event
3. Logs are streamed to Log Analytics
4. Microsoft Sentinel analyzes activity
5. KQL detection identifies suspicious role assignments
6. AI-assisted analysis (Copilot) explains impact

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/diagrams/ZTLZ_Architecture_diagram.png style="width:1000px;">

## Network Architecture

The project uses a hub-and-spoke network design. Shared services and administrative access are placed in the hub network, while application workloads reside in the spoke network. This design supports segmentation, centralized control, and reduced blast radius.

No workload subnet is designed for direct public administrative access.
