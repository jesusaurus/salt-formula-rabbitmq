# Copyright 2013 Hewlett-Packard Development Company, L.P.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#

net.ipv4.tcp_keepalive_time:
  sysctl.present:
    - value: {{ salt['pillar.get']('rabbitmq:keepalive:time', 10) }}

net.ipv4.tcp_keepalive_probes:
  sysctl.present:
    - value: {{ salt['pillar.get']('rabbitmq:keepalive:probes', 3) }}

net.ipv4.tcp_keepalive_intvl:
  sysctl.present:
    - value: {{ salt['pillar.get']('rabbitmq:keepalive:intvl', 5) }}

networking:
  service:
    - enabled
    - watch:
      - sysctl: net.ipv4.tcp_keepalive_time
      - sysctl: net.ipv4.tcp_keepalive_intvl
      - sysctl: net.ipv4.tcp_keepalive_probes

{% for host, ip in salt['pillar.get']('rabbitmq:cluster', {}).iteritems() %}
rabbit_host_{{host}}:
  host.present:
    - name: {{ host }}
    - ip: {{ ip }}
{% endfor %}
