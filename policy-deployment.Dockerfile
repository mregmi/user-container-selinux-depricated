# Copyright 2022 Intel Corporation. All Rights Reserved.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


# FINAL_BASE can be used to configure the base image of the final image.
#
# FINAL_BASE is primarily used to build Redhat Certified Openshift Operator container images that must be UBI based.
ARG FINAL_BASE=registry.access.redhat.com/ubi8-minimal:latest
FROM ${FINAL_BASE} 

LABEL name='policy-deployment' 
LABEL vendor='Intel®' 
LABEL version='0.1' 
LABEL release='1' 
LABEL summary='SELinux policy for device plugins and deployment mechanism for RedHat OpenShift' 
LABEL description='SELinux policy for device plugins and deployment mechanism for RedHat OpenShift'

ARG DIR=/user-container-selinux
WORKDIR ${DIR}
COPY . .

RUN microdnf update && \
    microdnf install --disableplugin=subscription-manager selinux-policy make && \
    microdnf clean all && rm -rf /var/cache/yum

RUN install -D ${DIR}/LICENSE /licenses/user-container-selinux/LICENSE && \
    mkdir -p /opt/selinux-policy && cp container_sr.pp.bz2 /opt/selinux-policy/container_sr.pp.bz2


ENTRYPOINT [ "/bin/sh", "-c", "semodule -i /opt/selinux-policy/container_sr.pp.bz2;while true; do sleep 60;done" ]