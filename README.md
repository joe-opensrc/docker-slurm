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

---
Manual Build:

```bash

cd docker-slurm

docker build -t joe-opensrc/slurm .

docker network create \
  -o com.docker.network.bridge.name="slurm-net" \
  --subnet=10.129.0.0/24 \
  --gateway=10.129.0.1 \
  -d bridge \
  --label slurm-net slurm-net

docker run --network slurm-net \
  --name ipc-slurmctl-1 \
  --hostname ipc-slurmctl-1 \
   -d joe-opensrc/slurm

docker run --privileged \
  --network slurm-net \
  --name ipc-compute-1 \
  --hostname ipc-compute-1 \
  -e SLURM_SLURMCTLDHOST=ipc-slurmctl-1 \
  -d joe-opensrc/slurm slurmd
```
