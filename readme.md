# Web Security Docker

One docker to rule them all!

## Environment variables

The following environment variables configure nginx:

- ``DOMAIN``: domain in the SSL certificate (default value: ``www.example.com``)
- ``TARGET_PORT``: target port for the reverse proxy (default value: ``80``)
- ``TARGET_HOST``: target host for the reverse proxy (default value: ``proxyapp``)
- ``TARGET_HOST_HEADER``: value to be used as the Host header when sending
  requests to the target host (defaults to the value of ``$TARGET_HOST``)
- ``CLIENT_MAX_BODY_SIZE``: maximum size of client uploads (default value: ``20M``)
- ``SSL_PORT``: port ngnix SSL proxy listens on

## Certificates and CA location

The SSL certificate is generated using a own-ROOT-ca that is available in the
directory ``/etc/nginx/ca``, you may use Docker volumes to share the CAs with
other containers, so they can trust the installed certificate.

## Using own Certificate

You can use existing SSL certificates for your ``DOMAIN``
by connecting an volume onto ``/etc/nginx/certs`` with following files inside:

- ``key.pem``: private key file
- ``cert.pem``: certificate file

The certificate generator will check on existing ``key.pem`` and abort.

## Based on the following projects

- docker-ssl-proxy: [https://github.com/fsouza/docker-ssl-proxy](https://github.com/fsouza/docker-ssl-proxy)
- docker-waf: [https://github.com/theonemule/docker-waf](https://github.com/theonemule/docker-waf)

## Why?

This docker was created for my own needs... I wanted something plain and simple to use.

## Docker Hub Image

You can get the publicly available docker image at the following location: [web-security-docker]()
