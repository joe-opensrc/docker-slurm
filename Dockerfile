FROM ubuntu:20.04

USER root 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends sudo lsof less vim apt-utils procps tree ca-certificates openssl ntpdate slurm-wlm munge git

RUN touch /var/log/slurm_jobacct.log 
RUN mkdir -p /var/log/slurm /var/spool/slurm 

USER slurm
WORKDIR /var/tmp
RUN git clone --branch slurm-19.05 --depth 1 https://github.com/SchedMD/slurm.git

USER root
RUN apt-get install -y python3-minimal python3.8-venv
RUN python3 -m venv --copies ~/Pyvirts/jinja2 
RUN /bin/bash -c 'source ~/Pyvirts/jinja2/bin/activate && pip install -U pip jinja2-cli'

RUN cp /var/tmp/slurm/contribs/lua/job_submit.lua /etc/slurm-llnl/
COPY --chown=slurm:slurm slurm.conf.j2 cgroup.conf /etc/slurm-llnl/

RUN chown slurm:slurm /var/log/slurm /var/spool/slurm /var/log/slurm_jobacct.log

COPY slurm-entrypoint.sh /opt/

# RUN apt-get install -y --no-install-recommends slurmdbd
# USER slurm

WORKDIR /etc/slurm-llnl
ENTRYPOINT ["/opt/slurm-entrypoint.sh"]
CMD ["slurmctld"]

