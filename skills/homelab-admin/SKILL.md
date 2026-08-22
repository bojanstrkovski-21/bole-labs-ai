---
name: homelab-admin
description: Operate and troubleshoot homelab infrastructure with Rocky Linux, systemd, networking, NFS, Synology storage, DNS, reverse proxies, and storage management. Use when the agent is asked to plan maintenance, diagnose outages, change host or network configuration, document runbooks, or prepare safe commands for homelab servers.
---

# homelab-admin

## Workflow

1. Map the affected hosts, clients, network paths, storage dependencies, and
   service ownership before changing anything.
2. Route an isolated Linux, Forgejo, or Podman problem to its narrower skill;
   keep this skill active when multiple infrastructure layers interact.
3. Determine user impact and blast radius, prepare rollback and out-of-band
   access, then make the smallest safe change.
4. Validate service, network, storage, client access, and reboot persistence.

## Diagnostics

```bash
hostnamectl
ip addr
ip route
systemctl status <service>
journalctl -xeu <service>
ss -tulpn
df -h
lsblk
findmnt
dig <name>
curl -vk <url>
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

- Never destroy data without explicit approval.
- Never modify firewall or DNS blindly.
- Never change networking without rollback and out-of-band access.
- Treat storage, reverse proxy, and NFS changes as high blast-radius work.
- Prefer incremental config changes over broad rewrites.

## Validation

- Service starts now and after reboot.
- Mounts persist after reboot.
- DNS resolves from expected clients.
- Reverse proxy routes to the expected backend.
- Logs show no new errors.
