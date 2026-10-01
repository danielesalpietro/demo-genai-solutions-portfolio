# IT Security Policy

**Organization**: Acme Corp  
**Version**: 3.0  
**Effective Date**: 2024-01-01  
**Owner**: Information Security Team

---

## Purpose

This policy defines the information security requirements for all Acme Corp systems, data, and personnel. Its goal is to protect the confidentiality, integrity, and availability of corporate information assets.

---

## Scope

Applies to all employees, contractors, vendors, and partners who access Acme Corp systems or handle Acme Corp data.

---

## Password Policy

Passwords are the primary authentication mechanism for most Acme Corp systems. All user passwords must be at least **12 characters** and changed every **90 days**. Additional requirements:

- Must include at least one uppercase letter, one lowercase letter, one digit, and one special character
- Must not reuse any of the last 12 passwords
- Must not contain the user's name, username, or department
- Must not be shared with any third party, including IT support staff

Multi-factor authentication (MFA) is mandatory for all remote access, cloud services, and administrative accounts. Passwords for privileged accounts (administrator, root) must be at least 16 characters and rotated every 60 days.

---

## Acceptable Use Policy

Acme Corp IT resources are provided to conduct legitimate business. Acceptable use rules:

- Corporate devices and network access are for business purposes; incidental personal use is tolerated when it does not interfere with work or violate this policy
- Employees must not install unauthorized software, disable security controls, or attempt to access systems beyond their assigned permissions
- Connecting personal devices to the corporate network requires prior approval from IT and enrollment in the mobile device management (MDM) system
- Transmission of confidential data over unencrypted channels (plain HTTP, FTP, unencrypted email) is prohibited
- Accessing, storing, or transmitting content that is illegal, obscene, or harassing via corporate systems is strictly prohibited
- Social media activity on corporate accounts must comply with the Communications Policy

Violations of this policy may result in disciplinary action up to and including termination.

---

## Data Classification

Acme Corp classifies all information assets into one of the following levels:

| Level | Label | Description | Handling |
|---|---|---|---|
| 1 | **Public** | Information approved for unrestricted external release | No special controls |
| 2 | **Internal** | General business information for employees only | Standard access controls; no external sharing without approval |
| 3 | **Confidential** | Sensitive business, customer, or partner data | Encrypted at rest and in transit; access on need-to-know basis; NDA required for third parties |
| 4 | **Restricted** | Highly sensitive data (PII, PCI, trade secrets, legal privilege) | Strict need-to-know; audit logging; encrypted storage; approval required to share even internally |

Data owners are responsible for classifying new information assets. If in doubt, classify at a higher level and consult the Information Security Team.

---

## Incident Response

Security incidents (suspected breach, malware, unauthorized access, lost device) must be reported to the Information Security Team within **2 hours** of discovery via `security@acmecorp.example` or the internal incident hotline. Employees must not attempt to investigate or remediate incidents independently.

---

## Policy Owner and Review

This policy is reviewed annually by the Information Security Team. Questions should be directed to `security@acmecorp.example`.