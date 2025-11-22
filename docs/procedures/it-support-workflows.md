# IT Support Workflows

## 📋 Overview

This document outlines standard IT support workflows and procedures for the Smart Cruise Vessel IT infrastructure. These procedures ensure consistent, efficient, and secure IT operations across all departments.

---

## 👤 User Account Management

### **New User Provisioning**

#### **Prerequisites**
- Valid user request form (electronic or paper)
- Manager approval
- Department assignment confirmed
- Required access permissions identified

#### **Procedure**

1. **Gather Information**
   - Full name (First, Last)
   - Department
   - Job title/role
   - Manager name
   - Start date
   - Required access (file shares, applications, email)

2. **Create User Account**
   ```
   Location: Active Directory Users and Computers
   OU: Users > [Department] > [Role]
   Username: FirstInitial.LastName (e.g., J.Smith)
   Display Name: First Name Last Name
   ```

3. **Configure Account Properties**
   - Set password (temporary, force change on first logon)
   - Add to appropriate security groups
   - Set department and manager attributes
   - Configure email address (if applicable)

4. **Assign Resources**
   - Add to department file share security groups
   - Assign appropriate GPOs (via OU placement)
   - Configure home drive mapping (if applicable)
   - Set up email mailbox (if applicable)

5. **Documentation**
   - Log account creation in IT ticketing system
   - Send welcome email with login credentials
   - Schedule follow-up for password change confirmation

#### **Estimated Time:** 15-20 minutes

---

### **Password Reset**

#### **Procedure**

1. **Verify Identity**
   - Request user ID or username
   - Verify identity (ID check, manager confirmation, or security questions)
   - Document verification method

2. **Reset Password**
   ```
   Location: Active Directory Users and Computers
   Right-click user > Reset Password
   Set temporary password
   Check "User must change password at next logon"
   ```

3. **Notify User**
   - Provide temporary password securely (in person, phone, or secure email)
   - Instruct user to change password immediately
   - Remind user of password policy requirements

4. **Documentation**
   - Log password reset in IT ticketing system
   - Note reason for reset (forgot, locked, security incident)
   - Set follow-up reminder to verify password change

#### **Estimated Time:** 5-10 minutes

---

### **Account Unlock**

#### **Procedure**

1. **Identify Issue**
   - User reports account locked
   - Check Active Directory for lockout status
   - Review security logs for lockout reason

2. **Unlock Account**
   ```
   Location: Active Directory Users and Computers
   Right-click user > Properties > Account tab
   Uncheck "Account is locked out"
   ```

3. **Investigate Cause**
   - Check for multiple failed login attempts
   - Verify if password was recently changed
   - Check for system issues or misconfiguration

4. **Notify User**
   - Inform user account is unlocked
   - Provide guidance on password requirements
   - If repeated lockouts, schedule password reset

5. **Documentation**
   - Log unlock action in IT ticketing system
   - Document cause if identified
   - Note any preventive measures taken

#### **Estimated Time:** 5-10 minutes

---

### **User Account Termination**

#### **Prerequisites**
- HR notification of employee departure
- Termination date confirmed
- Data retention requirements identified

#### **Procedure**

1. **Disable Account** (On termination date)
   ```
   Location: Active Directory Users and Computers
   Right-click user > Disable Account
   ```

2. **Remove Access**
   - Remove from all security groups (except Domain Users)
   - Revoke remote access permissions
   - Disable email account (if applicable)
   - Revoke application access

3. **Data Handling**
   - Export email to PST (if required by policy)
   - Archive user files (if required)
   - Transfer ownership of shared files to manager
   - Document data retention period

4. **Schedule Deletion**
   - Set calendar reminder for account deletion (typically 30-90 days)
   - Ensure all data archived before deletion

5. **Documentation**
   - Log account disable in IT ticketing system
   - Document data retention actions
   - Update asset inventory if applicable

#### **Estimated Time:** 30-45 minutes

---

## 🔐 Access Management

### **Access Request Workflow**

#### **Request Types**
- File share access
- Application access
- Remote access (RDP)
- Administrative privileges
- Email distribution list membership

#### **Procedure**

1. **Receive Request**
   - User submits access request (ticket, email, or form)
   - Verify request includes:
     - User name/ID
     - Resource/application name
     - Business justification
     - Manager approval

2. **Evaluate Request**
   - Verify manager approval
   - Check business justification
   - Review security implications
   - Confirm user has appropriate clearance level

3. **Grant Access**
   - Add user to appropriate security group
   - Configure application-specific permissions
   - Set up remote access (if applicable)
   - Configure email forwarding (if applicable)

4. **Notify User**
   - Confirm access granted
   - Provide instructions for accessing resource
   - Include troubleshooting contact information

5. **Documentation**
   - Log access grant in IT ticketing system
   - Update access control documentation
   - Set review reminder (quarterly access reviews)

#### **Estimated Time:** 15-30 minutes (depending on complexity)

---

### **Access Revocation**

#### **Procedure**

1. **Receive Request**
   - Manager request or security incident
   - Verify authorization to revoke access

2. **Revoke Access**
   - Remove from security groups
   - Disable application accounts
   - Revoke remote access
   - Remove from distribution lists

3. **Verify Revocation**
   - Test that access is denied
   - Check security logs for access attempts
   - Confirm user cannot access resources

4. **Notify Stakeholders**
   - Inform user (if appropriate)
   - Notify manager
   - Update security team (if security incident)

5. **Documentation**
   - Log revocation in IT ticketing system
   - Document reason for revocation
   - Update access control documentation

#### **Estimated Time:** 15-20 minutes

---

## 🖥️ Workstation Support

### **Workstation Setup**

#### **Procedure**

1. **Hardware Preparation**
   - Verify hardware specifications meet requirements
   - Install operating system (Windows 10/11)
   - Update BIOS and drivers
   - Run hardware diagnostics

2. **Domain Join**
   ```
   System Properties > Computer Name > Change
   Join domain: CRUISE.LOCAL
   Provide domain admin credentials
   Restart computer
   ```

3. **Software Installation**
   - Install required applications (Office, department-specific software)
   - Install antivirus/endpoint protection
   - Configure printers
   - Set up department-specific shortcuts

4. **Configuration**
   - Verify GPO application
   - Test file share access
   - Configure email (if applicable)
   - Set up user profile

5. **Documentation**
   - Log workstation setup in asset inventory
   - Document installed software and versions
   - Assign to user and update inventory

#### **Estimated Time:** 1-2 hours

---

### **Workstation Troubleshooting**

#### **Common Issues & Solutions**

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Cannot Join Domain** | "The following error occurred" | Check network connectivity, DNS resolution, verify domain credentials |
| **GPO Not Applying** | Settings not taking effect | Run `gpupdate /force`, check OU placement, verify GPO link |
| **File Share Access Denied** | "Access Denied" error | Verify user is in correct security group, check NTFS permissions |
| **DNS Resolution Failure** | Cannot resolve hostnames | Check DNS server settings, verify DNS server is reachable |
| **Slow Logon** | Takes > 2 minutes to logon | Check network connectivity, verify GPO processing, check profile size |
| **Profile Issues** | Desktop/settings not loading | Check profile path, verify permissions, check disk space |

#### **Troubleshooting Procedure**

1. **Gather Information**
   - User description of issue
   - Error messages (screenshot if possible)
   - When issue started
   - Recent changes (software, updates, configuration)

2. **Initial Diagnostics**
   - Check event logs (Event Viewer)
   - Verify network connectivity
   - Test DNS resolution
   - Check system resources (CPU, memory, disk)

3. **Apply Solution**
   - Follow solution from knowledge base
   - Document steps taken
   - Test resolution

4. **Escalation** (if needed)
   - Document all troubleshooting steps
   - Escalate to senior IT staff
   - Provide detailed information

5. **Documentation**
   - Log issue and resolution in ticketing system
   - Update knowledge base if new solution found
   - Follow up with user to confirm resolution

---

## 📧 Email Support (If Applicable)

### **Email Account Setup**

#### **Procedure**

1. **Create Mailbox**
   - Create user account in Active Directory
   - Mailbox automatically created (if Exchange configured)
   - Or manually create mailbox in Exchange Admin Center

2. **Configure Email Client**
   - Outlook: Auto-discover should configure automatically
   - Manual setup: Provide server name, username, password
   - Test send/receive

3. **Set Up Distribution Lists**
   - Add to department distribution lists
   - Configure email forwarding (if needed)

4. **Documentation**
   - Log email setup in ticketing system
   - Provide user with email access instructions

#### **Estimated Time:** 15-20 minutes

---

## 🔍 Incident Response

### **Security Incident Procedure**

#### **Types of Security Incidents**
- Unauthorized access attempts
- Malware detection
- Phishing emails
- Account compromise
- Data breach

#### **Procedure**

1. **Initial Response**
   - Identify and contain threat immediately
   - Isolate affected systems if necessary
   - Document initial observations

2. **Investigation**
   - Review security logs
   - Identify scope of incident
   - Determine attack vector
   - Preserve evidence

3. **Remediation**
   - Remove threat (malware removal, account lockout)
   - Patch vulnerabilities
   - Reset compromised credentials
   - Restore from backup if needed

4. **Communication**
   - Notify IT management
   - Inform affected users
   - Report to security team
   - Document incident report

5. **Post-Incident**
   - Review incident response
   - Update security policies if needed
   - Conduct lessons learned session
   - Update documentation

---

## 📞 Support Contact Information

### **IT Support Hours**
- **Regular Hours:** Monday-Friday, 08:00-18:00
- **Emergency:** 24/7 on-call support for critical issues

### **Contact Methods**
- **Ticketing System:** [URL or system name]
- **Phone:** [Phone number]
- **Email:** it-support@cruise.local
- **Walk-in:** IT Office, Deck 5

### **Escalation Path**
1. **Level 1:** IT Support Technician
2. **Level 2:** IT Systems Administrator
3. **Level 3:** IT Manager / Senior Engineer

---

## 📝 Documentation Standards

### **Ticket Documentation Requirements**
- User name and contact information
- Issue description
- Error messages (if applicable)
- Troubleshooting steps taken
- Resolution or escalation
- Time spent
- User confirmation of resolution

### **Knowledge Base Updates**
- Document new solutions
- Update existing articles with new information
- Include screenshots and step-by-step instructions
- Tag articles appropriately for easy searching

---

## ✅ Quality Assurance

### **Ticket Review Checklist**
- [ ] Issue clearly described
- [ ] All troubleshooting steps documented
- [ ] Resolution confirmed with user
- [ ] Knowledge base updated (if applicable)
- [ ] Time tracking accurate
- [ ] User satisfaction confirmed

---

**Last Updated:** 2025 | **Version:** 1.0.0 | **Status:** Active

