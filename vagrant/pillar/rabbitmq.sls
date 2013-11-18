rabbitmq:
  erlang_cookie: SomeRandomCookie

  policies:
    hp-all:
      pattern: '.*'
      definition: '{"ha-mode":"all", "ha-sync-mode":"automatic"}'
  
  plugins:
    - rabbitmq_management
    - rabbitmq_management_visualiser

  mnesia_base: /mnt/rabbitmq/mnesia

  admin:
    user: admin
    password: adminPassword

  ssl:
    enabled: false
    cacert: |
      -----BEGIN CERTIFICATE-----
      MIIEogIBAAKCAQEArk517i2X.....
      -----END CERTIFICATE-----

    cert: |
      -----BEGIN CERTIFICATE-----
      MIIEogIBAAKCAQEArk517i2X.....
      -----END CERTIFICATE-----

    key: |
      -----BEGIN RSA PRIVATE KEY-----
      MIIEogIBAAKCAQEArk517i2X.....
      -----END RSA PRIVATE KEY-----
