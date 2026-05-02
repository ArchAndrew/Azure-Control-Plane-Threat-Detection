# 🎤 MCT Presentation Script

## Azure Zero Trust Detection: RBAC Privilege Escalation with AI-Assisted Analysis

---

## 🟦 1. Opening (Set the Frame)

“Today, I’m going to walk you through how we detect one of the most critical attack paths in Azure — **RBAC privilege escalation** — using a Zero Trust, identity-centric detection approach.

This isn’t just about logs or queries.

This is about understanding:

* How attackers abuse identity
* How control-plane activity reveals that behavior
* And how we design detection systems to catch it in real time”

---

## 🟦 2. The Core Problem (Why This Matters)

“In cloud environments, identity is the primary attack surface.

If an attacker compromises a user or service principal, they don’t need malware.

They can simply:

* Assign roles to themselves
* Escalate privileges silently
* Gain persistent access to critical resources

The challenge is:
👉 Traditional monitoring often misses these **control-plane changes**

That’s where this detection pipeline comes in.”

---

## 🟦 3. Architecture Overview (Big Picture)

“Let’s walk through how this detection pipeline works:

1. An identity performs an RBAC action in Azure (via CLI, Portal, or API)
2. Azure Activity Logs capture the control-plane event
3. Logs are streamed into Log Analytics
4. Microsoft Sentinel queries and analyzes the activity
5. A KQL detection identifies suspicious role assignments
6. Microsoft Copilot provides AI-assisted analysis for faster investigation

This pipeline ensures:
👉 Visibility
👉 Detection
👉 Context
👉 Actionable insight”

---

## 🟦 4. Detection Logic (KQL Walkthrough)

“Now let’s look at the detection itself.

We query the AzureActivity table, which contains control-plane logs.”

```kql
AzureActivity
| where OperationNameValue has "roleAssignments"
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, CallerIpAddress, OperationNameValue, Properties
| order by TimeGenerated desc
```

“What this does is:

* Filters for RBAC role assignment operations
* Ensures the action was successful
* Extracts key investigation fields:

  * Who performed the action
  * From where (IP address)
  * What operation occurred
  * Additional context from Properties

👉 This gives us the **core detection signal**”

---

## 🟦 5. Proof of Execution (Real Event)

“At this stage, we simulate a real-world scenario:

A user assigns a role using Azure CLI.

Even if it’s a low-privilege role like Reader:
👉 The same mechanism can assign Owner or Contributor

Which makes this:
👉 A potential privilege escalation vector”

---

## 🟦 6. Deep Inspection (Expanded Event Analysis)

“Now we expand the event to perform a deeper investigation.

This is where we extract critical context:

### 🔍 Key Fields:

* **Caller / Claims**
  → Who performed the action

* **Client IP Address**
  → Where the request originated

* **RoleDefinitionId (Properties)**
  → What role was assigned

* **Authorization Scope**
  → How broad the access is (subscription, resource group, etc.)

* **OperationNameValue**
  → Confirms the RBAC action performed

👉 This step transforms raw logs into **investigative intelligence**”

---

## 🟦 7. Security Interpretation (What This Means)

“From a security perspective, this event tells us:

* An identity successfully modified access permissions
* The action occurred at a specific scope
* The request originated from a specific IP
* A role was granted that may increase privilege

If this originated from:
👉 An external IP
👉 An unusual user
👉 An unexpected time

Then we may be looking at:
⚠️ Privilege escalation
⚠️ Account compromise
⚠️ Insider misuse”

---

## 🟦 8. AI-Assisted Analysis (Copilot)

“This is where AI accelerates the workflow.

Instead of manually interpreting raw logs:

👉 Microsoft Copilot analyzes the event and provides:

* Risk context
* Security implications
* Recommended focus areas

For example:

* Identifying external IP risk
* Highlighting privilege escalation potential
* Emphasizing the need for validation

👉 This reduces investigation time and improves decision-making”

---

## 🟦 9. Key Takeaways

“What this project demonstrates is:

* Control-plane visibility is critical
* Identity-based attacks are the primary cloud risk
* RBAC changes must be monitored continuously
* Detection must include:

  * Identity
  * Source IP
  * Role context
* AI can enhance—but not replace—analyst judgment”

---

## 🟦 10. Real-World Application

“In a production environment, this detection would be:

* Converted into a Sentinel Analytics Rule
* Integrated with alerting and incident response
* Correlated with:

  * Sign-in logs
  * Identity risk signals
  * Behavioral anomalies

👉 This is how modern SOC teams detect and respond to cloud threats”

---

## 🟦 11. Limitations (Honest Engineering Perspective)

“It’s important to understand limitations:

* Detection depends on log ingestion latency (~2–5 minutes)
* Only detects successful role assignments
* Requires proper diagnostic configuration at subscription level

👉 No detection is perfect — but awareness of limitations improves design”

---

## 🟦 12. Closing

“To summarize:

This is not just a query.

This is a **detection strategy**:

* Built on Zero Trust principles
* Focused on identity as the attack surface
* Designed for real-world cloud environments

And most importantly:

👉 It demonstrates how we move from raw logs to actionable security intelligence”

---

## 🟦 Optional Audience Engagement Questions

* “What would you alert on in this scenario?”
* “How would you differentiate legitimate vs malicious role assignments?”
* “What additional logs would you correlate here?”
* “How would you automate the response?”

---

## 🟦 Instructor Notes (For You)

* Pause after each section → allow questions
* Emphasize **WHY**, not just HOW
* Tie everything back to:

  * Zero Trust
  * Identity security
  * Real-world attack paths

---

thee_architect_was_here

