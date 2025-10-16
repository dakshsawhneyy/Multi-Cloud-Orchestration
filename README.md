# End-to-End Multi-Cloud Orchestration Pipeline

This repository contains a fully automated, production-grade pipeline that provisions, configures, and monitors a web application across both AWS and Azure from a single, unified codebase. It demonstrates a complete Infrastructure as Code (IaC) and Configuration Management lifecycle, orchestrated via a CI/CD workflow.

---
## Architecture

<img width="1393" height="864" alt="diagram-export-10-13-2025-5_47_19-PM" src="https://github.com/user-attachments/assets/ddd4cee1-e0ed-43c0-afa2-f93e8df91924" />

The architecture is designed for consistency, scalability, and resilience. The core workflow begins with a push to the Git repository, which triggers a GitHub Actions pipeline. This pipeline leverages Terraform for infrastructure provisioning and Ansible for configuration, with all state managed centrally and securely in an AWS S3 backend.

---
## Key Features

* **Unified Multi-Cloud Provisioning:** A single Terraform codebase with workspaces to selectively deploy and manage infrastructure on AWS and Azure.
  <img width="1487" height="450" alt="diagram-export-10-14-2025-4_45_17-PM" src="https://github.com/user-attachments/assets/f3f1b188-2ea6-44da-ae8f-c2d82b8a2a68" />

* **Dynamic Inventory Generation:** Terraform automatically generates the Ansible inventory file upon provisioning, creating a seamless link between infrastructure state and configuration management.
* **Idempotent Configuration:** An Ansible playbook ensures consistent, repeatable, and stateful configuration of the Nginx web server and Datadog monitoring agents.
<img width="1364" height="640" alt="Screenshot 2025-10-16 142012" src="https://github.com/user-attachments/assets/0743fcc0-21da-44fd-99b7-8c1d60980e36" />

* **Automated CI/CD Pipeline:** A GitHub Actions workflow orchestrates the entire deployment process, from provisioning infrastructure to running configuration playbooks, triggered automatically or manually.
<img width="1403" height="952" alt="Screenshot 2025-10-16 152642" src="https://github.com/user-attachments/assets/41e72e5e-0992-4d7a-a94d-8bffa35fe31c" />

* **Centralized Observability:** Datadog agents are installed and configured via Ansible, providing a single pane of glass for monitoring system and application metrics from both cloud environments.
<img width="1309" height="750" alt="diagram-export-10-14-2025-4_25_56-PM" src="https://github.com/user-attachments/assets/0a02037b-4ce1-4074-834a-6098a5515592" />

* **Secure Credential Management:** All sensitive credentials (cloud provider keys, API keys, SSH keys) are managed securely using GitHub Secrets.

---
## Technology Stack

* **Infrastructure as Code:** Terraform
* **Configuration Management:** Ansible
* **Cloud Providers:** AWS, Microsoft Azure
* **CI/CD:** GitHub Actions
* **Monitoring:** Datadog

---
## Core Challenges & Solutions

This project demonstrates mastery over common and complex challenges in real-world infrastructure automation.

1.  **State Mismatch in CI/CD:** Initial pipeline runs failed with `Permission denied (publickey)` errors despite correct local configurations. **Solution:** I diagnosed a key mismatch between the CI/CD runner and the provisioned instances by comparing SSH key fingerprints directly within the workflow. The root cause was identified as stale infrastructure created with old keys. The solution involved manually clearing the stale state and forcing a clean rebuild, ensuring the entire environment was created from a single, consistent source of truth.

2.  **Service Readiness Race Condition:** After resolving the key issue, Ansible would intermittently fail because the SSH daemon on the newly created VMs was not yet ready to accept connections. **Solution:** I implemented a `wait_for_connection` pre-task in the Ansible playbook. This professional pattern makes the pipeline resilient by ensuring configuration does not begin until the infrastructure is confirmed to be fully available.

3.  **Dynamic Configuration Errors:** An Nginx service restart would fail due to an invalid configuration file. **Solution:** I identified that Ansible's `copy` module is literal, while the `template` module is needed to process Jinja2 variables. The fix was to refactor the Nginx configuration into a `.j2` template, allowing dynamic values like `cloud_provider` to be correctly injected and ensuring a valid final configuration.

---
## Usage

This project is orchestrated entirely through GitHub Actions.

1.  **Prerequisites:** Configure the following secrets in the GitHub repository settings under `Settings > Secrets and variables > Actions`:
    * `AWS_ACCESS_KEY_ID`
    * `AWS_SECRET_ACCESS_KEY`
    * `AZURE_CREDENTIALS` (as a single JSON object)
    * `SSH_PRIVATE_KEY`
    * `DATADOG_API_KEY`

2.  **Run the Pipeline:**
    * Navigate to the **Actions** tab in the repository.
    * Select the **"Deploy Multi-Cloud Infrastructure"** workflow.
    * Click **"Run workflow"**.
    * Choose the target workspace (`aws` or `azure`) from the dropdown and execute.
