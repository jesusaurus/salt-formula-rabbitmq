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
include:
  - rabbitmq

{% set policies = salt['pillar.get']('rabbitmq:policies', False) -%}
{% if policies -%}
{% for name, policy in policies.iteritems() -%}
rabbit-policy-{{ name }}:
  rabbitmq_policy:
    - {{ policy.get('state', 'present') }}
    - name: {{ policy.get('name', name) }}
    - vhost: {{ policy.get('vhost', '/') }}
    - pattern: '{{ policy['pattern'] }}'
    - definition: '{{ policy['definition'] }}'
    - require:
      - pkg: rabbitmq-server
{% endfor %}
{% endif %}

{% if salt['pillar.get']('rabbitmq:nodes', False) -%}
{% set host = salt['pillar.get']('rabbitmq:nodes', ['NoNodesInPillar'])[0] -%}
rabbitmq-join-cluster:
  rabbitmq_cluster:
    - join
    - host: {{ host }}
    - require:
      - pkg: rabbitmq-server
{% for name in salt['pillar.get']('rabbitmq:plugins', []) %}
      - rabbitmq_plugin: {{ name }}
{% endfor -%}
{% endif -%}
