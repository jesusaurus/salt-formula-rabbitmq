rabbitmq:
  erlang_cookie: SomeRandomCookie
  
  plugins:
    - rabbitmq_management
    - rabbitmq_management_visualiser

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
