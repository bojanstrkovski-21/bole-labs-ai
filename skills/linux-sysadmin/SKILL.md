---
name: linux-sysadmin
description: Diagnose and operate Linux systems, especially Rocky Linux and Ubuntu, including SSH, SELinux, permissions, firewalls, packages, processes, logs, and systemd services. Use when the agent is asked to troubleshoot hosts, prepare commands, write runbooks, fix service failures, or reason about Linux administration.
---

# linux-sysadmin

## Workflow

1. Gather host, service, resource, network, and security diagnostics.
2. Determine whether the failure is host-level or primarily belongs to a
   specialized application, container, or cross-system infrastructure skill.
3. Identify impact and recent changes, then create rollback for files,
   packages, service units, and firewall changes.
4. Implement the smallest host-level fix and validate runtime behavior, remote
   access, security policy, and boot persistence.

## Diagnostics

```bash
cat /etc/os-release
uname -a
uptime
free -h
df -h
lsblk
systemctl status <unit>
journalctl -xeu <unit>
ss -tulpn
getenforce
firewall-cmd --list-all
ufw status verbose
```

## Diagnose from evidence

Work from evidence, not a plausible-sounding story. Correlate the failure
time against logs, file/config mtimes, and recent changes (deploys, package
updates, edits) before proposing a cause. State plainly what the evidence
proves versus what is inferred, and say so directly when the cause is
genuinely ambiguous rather than settling on a guess. Diagnosis is read-only
until the cause is established — do not fix, tidy, or reconfigure while
still gathering evidence.

## Safety Rules

- Never disable SELinux as a default fix.
- Never rotate SSH keys or change `sshd_config` without rollback.
- Never modify firewall rules without confirming active firewall stack.
- Prefer systemd drop-ins over editing packaged unit files.
- Preserve ownership, permissions, ACLs, mount options, and labels.

## Validation

- Service starts now and after reboot.
- Logs show no new errors.
- Expected ports listen and unexpected ports do not.
- SSH access still works.
- SELinux and firewall state match the intended policy.
