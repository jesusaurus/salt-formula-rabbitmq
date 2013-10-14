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
rabbitmq-repo:
  pkgrepo:
    - managed
    - enabled: true
    - human_name: RabbitMQ Apt Repo
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - name: deb http://www.rabbitmq.com/debian testing main
    - key_url: http://www.rabbitmq.com/rabbitmq-signing-key-public.asc

net.ipv4.tcp_keepalive_time:
  sysctl.present:
    - value: 10

net.ipv4.tcp_keepalive_probes:
  sysctl.present:
    - value: 3

net.ipv4.tcp_keepalive_intvl:
  sysctl.present:
    - value: 5

networking:
  service:
    - enabled
    - watch:
      - sysctl: net.ipv4.tcp_keepalive_time
      - sysctl: net.ipv4.tcp_keepalive_intvl
      - sysctl: net.ipv4.tcp_keepalive_probes

rabbitmq:
  group:
    - present
    - system: true
  user:
    - present
    - system: true
    - createhome: false
    - gid_from_name: true
    - fullname: "RabbitMQ messaging server"
    - shell: /bin/false
    - home: /var/lib/rabbitmq
    - groups:
      - rabbitmq
    - require:
      - group: rabbitmq

/etc/rabbitmq:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/rabbitmq/ssl:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - file: /etc/rabbitmq
    - require_in:
      - pkg: rabbitmq-server

{% if salt['pillar.get']('rabbitmq:ssl:enabled', false) -%}
/etc/rabbitmq/ssl/cacert.pem:
  file:
    - managed
    - contents: {{ salt['pillar.get']('rabbitmq:ssl:cacert') | yaml }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - user: rabbitmq
      - file: /etc/rabbitmq/ssl
    - require_in:
      - pkg: rabbitmq-server

/etc/rabbitmq/ssl/cert.pem:
  file:
    - managed
    - contents: {{ salt['pillar.get']('rabbitmq:ssl:cert') | yaml }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - user: rabbitmq
      - file: /etc/rabbitmq/ssl
    - require_in:
      - pkg: rabbitmq-server

/etc/rabbitmq/ssl/cert.key:
  file:
    - managed
    - contents: {{ salt['pillar.get']('rabbitmq:ssl:key') | yaml }}
    - user: root
    - group: rabbitmq
    - mode: 640
    - require:
      - user: rabbitmq
      - file: /etc/rabbitmq/ssl
    - require_in:
      - pkg: rabbitmq-server
{% endif -%}

/var/lib/rabbitmq:
  file:
    - directory
    - user: rabbitmq
    - group: rabbitmq
    - mode: 755
    - makedirs: True
    - require:
      - user: rabbitmq

/var/lib/rabbitmq/.erlang.cookie:
  file:
    - managed
    - contents: {{ salt['pillar.get']('rabbitmq:erlang_cookie', 'rabbitmq') }}
    - user: rabbitmq
    - group: rabbitmq
    - mode: 400
    - require:
      - user: rabbitmq
      - group: rabbitmq
      - file: /var/lib/rabbitmq

/etc/rabbitmq/rabbitmq.config:
  file:
    - managed
    - source: salt://rabbitmq/templates/rabbitmq.config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        nodes: {{ salt['pillar.get']('rabbitmq:nodes', []) }}
    - require:
      - file: /etc/rabbitmq

rabbitmq-rabbitmq_management-plugin:
  rabbitmq_plugin:
    - enabled
    - name: rabbitmq_management
    - require:
      - pkg: rabbitmq-server

rabbitmq-rabbitmq_management_visualiser-plugin:
  rabbitmq_plugin:
    - enabled
    - name: rabbitmq_management_visualiser
    - require:
      - pkg: rabbitmq-server

rabbitmq-server:
  pkg:
    - latest
    - require:
      - pkgrepo: rabbitmq-repo
      - file: /etc/rabbitmq/rabbitmq.config
      - file: /var/lib/rabbitmq/.erlang.cookie
  service:
    - running
    - enable: True
    - require:
      - pkg: rabbitmq-server
    - watch:
      - rabbitmq_plugin: rabbitmq_management
      - rabbitmq_plugin: rabbitmq_management_visualiser
