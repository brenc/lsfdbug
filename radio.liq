settings.log.file.set(false)
settings.log.level.set(3)
settings.log.stdout.set(true)

ssl_transport = http.transport.ssl(
  certificate="cert.pem",
  key="key.pem",
)

harbor_ssl = input.harbor(
  "radio",
  buffer=6.0,
  port=8000,
  timeout=10.0,
  transport=ssl_transport,
  user="radio",
  password="radio",
)

output.dummy(sine(440.))
