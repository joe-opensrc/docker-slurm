### PoC Dockerised Slurm Setup

Not very secure, but it is Hideously Functional ⁽™⁾ :D

tl;dr: `docker compose up -d`

The docker-compose.yml will setup a 2-node cluster.

```
⊳ docker compose ps
NAME                COMMAND                  SERVICE             STATUS              PORTS
ipc-compute-1       "/opt/slurm-entrypoi…"   compute             running             6817/tcp, 0.0.0.0:6818->6818/tcp
ipc-slurmctl-1      "/opt/slurm-entrypoi…"   slurmctl            running             0.0.0.0:6817->6817/tcp, 6818/tcp
```

Unfortuantely the slurmd containers must run with `--privileged`


#### Manual Setup:

```

# Clone the repo + cd into the new folder
git clone https://github.com/joe-opensrc/docker-slurm.git
cd docker-slurm

# Build the container
docker build -t joe-opensrc/slurm .

# Create the container network
docker network create \
  -o com.docker.network.bridge.name="slurm-net" \
  --subnet=10.129.0.0/24 \
  --gateway=10.129.0.1 \
  -d bridge \
  --label slurm-net slurm-net

# Spin up a slurmctld node
docker run --network slurm-net \
  --name ipc-slurmctl-1 \
  --hostname ipc-slurmctl-1 \
   -d joe-opensrc/slurm

# Spin up a slurmd compute node
docker run --privileged \
  --network slurm-net \
  --name ipc-compute-1 \
  --hostname ipc-compute-1 \
  -e SLURM_SLURMCTLDHOST=ipc-slurmctl-1 \
  -d joe-opensrc/slurm slurmd

# Run slurm commands from the cli
docker run --network slurm-net \
  --hostname slurmcli \
  -e SLURM_TYPE=cli \
  -e SLURM_SLURMCTLDHOST=ipc-slurmctl-1 \
  -it joe-opensrc/slurm <slurm-command> # e.g., squeue, sinfo, etc...
```
