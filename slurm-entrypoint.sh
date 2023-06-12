#!/bin/bash

# env overrides command line; defaults to slurmctld
slurmType="${SLURM_TYPE:-${1:-slurmctld}}"
echo "${slurmType^^}_OPTIONS=\"-D\"" >>"/etc/default/${slurmType}"

/etc/init.d/munge start

source ~/Pyvirts/jinja2/bin/activate

hname="$(hostname -s)"
echo -ne "ClusterName=${SLURM_CLUSTERNAME:-ipc}\nSlurmctldHost=${SLURM_SLURMCTLDHOST:-${hname}}" | jinja2 --format env /etc/slurm-llnl/slurm.conf.j2 >/etc/slurm-llnl/slurm.conf

/etc/init.d/${slurmType} start 
