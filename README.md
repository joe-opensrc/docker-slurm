---

### PoC Dockerised Slurm Setup

Not very secure, but it is Hideously Functional⁽™⁾ :D

```
Files:
├── cgroup.conf   
├── docker-compose.yml
├── Dockerfile
├── README.md
├── slurm.conf.j2
└── slurm-entrypoint.sh
```

The docker-compose.yml will setup a 1-node compute cluster.

The slurmd containers must run as `--privileged` 
