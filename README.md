# Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations
AZ-104 aligned secure Azure architecture with Microsoft Sentinel + Copilot-driven investigation workflow.

<img src= https://github.com/ArchAndrew/Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations/blob/main/azure-zero-trust-copilot-security/diagrams/ZTLZ_Architecture_diagram.png style="width:1000px;">

## Network Architecture

The project uses a hub-and-spoke network design. Shared services and administrative access are placed in the hub network, while application workloads reside in the spoke network. This design supports segmentation, centralized control, and reduced blast radius.

No workload subnet is designed for direct public administrative access.
