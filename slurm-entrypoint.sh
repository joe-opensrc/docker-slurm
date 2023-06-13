#!/bin/bash

# env overrides command line; defaults to slurmctld
hname="$(hostname -s)"

slurmType="${SLURM_TYPE:-${1:-slurmctld}}"
SLURM_CLUSTERNAME="${SLURM_CLUSTERNAME:-ipc}"
SLURM_SLURMCTLDHOST="${SLURM_SLURMCTLDHOST:-${hname}}"

# echo "slurmType: ${slurmType}"
# echo "hname: ${hname}"
# echo "SLURM_CLUSTERNAME: ${SLURM_CLUSTERNAME}"
# echo "SLURM_SLURMCTLDHOST: ${SLURM_SLURMCTLDHOST}"

# Set debug option; runs in foreground + generates logs
echo "${slurmType^^}_OPTIONS=\"-D\"" >>"/etc/default/${slurmType}"

# gen config from template
source ~/Pyvirts/jinja2/bin/activate
echo -ne "ClusterName=${SLURM_CLUSTERNAME}\nSlurmctldHost=${SLURM_SLURMCTLDHOST}" | jinja2 --format env /etc/slurm-llnl/slurm.conf.j2 >/etc/slurm-llnl/slurm.conf

# start munge
/etc/init.d/munge start &>/dev/null 

# run command based on slurmType
case "${slurmType}" in
  slurmd|slurmctld) /etc/init.d/${slurmType} start;;
  cli) ${@};;
esac

