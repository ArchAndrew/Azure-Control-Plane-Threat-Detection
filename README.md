# Azure-Zero-Trust-Landing-Zone-with-AI-Assisted-Security-Operations
AZ-104 aligned secure Azure architecture with Microsoft Sentinel + Copilot-driven investigation workflow.

## Network Architecture

The project uses a hub-and-spoke network design. Shared services and administrative access are placed in the hub network, while application workloads reside in the spoke network. This design supports segmentation, centralized control, and reduced blast radius.

No workload subnet is designed for direct public administrative access.
