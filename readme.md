# Web Security Docker

This docker container creates a basic nginx server that proxies incoming  SSL/TLS calls to a target host after they have been processed by the ModSecurity Web Application Firewall (WAF).

In other words, it allows you to:
- Protect against a wide range (but not all) of web attacks using ModSecurity Web Application Firewall
- To configure an SSL/TLS certificate for a specific host
- It uses Nginx proxy to direct traffic to your host. It can be placed "in front" of your host.

ModSecurity protects against web attacks by looking for:
- SQL Injection
- Ensuring the content type matches the body data.
- Protection against malformed POST requests.
- HTTP Protocol Protection
- Real-time Blacklist Lookups
- HTTP Denial of Service Protections
- Generic Web Attack Protection


## Burp Suite Tests

The implementation of a Web Application Firewall will never be the perfect and undefeated solution for your security issues at the level of your application. But it will for sure boost your security level. For this matter, I have run a full security audit using Burp Suite Pro against one of the most vulnerable web application called DVWA (Damn Vulnerable Web Application).

| Unprotected DVWA | Protected DVWA |
|------------------|----------------|
|![Unprotected DVWA](https://i.imgur.com/8ia2yJt.png)|![Protected DVWA](https://i.imgur.com/mjb8F9o.png)|

As you can see, this docker container is a significant boost to the security of the application. 

## Environment variables

The following environment variables configure nginx:

- ``SEC_RULE_ENGINE``: set value for [SecRuleEngine](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecRuleEngine) (default value: ``DetectionOnly``)
- ``HTTP_VERSION``: Sets the HTTP protocol version for proxying. (default value: ``1.1``)
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
by connecting an volume onto ``/usr/local/nginx/certs`` with following files inside:

- ``key.pem``: private key file
- ``cert.pem``: certificate file

The certificate generator will check on existing ``key.pem`` and abort.

## Demo docker-compose.yml

```yaml
version: '2'
services:
    waf:
        build: waf
        hostname: ngnix-security
        restart: always
        ports:
            - 8443:8443
        environment:
            - SEC_RULE_ENGINE=On
            - HTTP_VERSION=1.1
            - DOMAIN=testphp.vulnweb.com
            - TARGET_PORT=80
            - TARGET_HOST=testphp.vulnweb.com
            - CLIENT_MAX_BODY_SIZE=200M
            - SSL_PORT=8443
        volumes: ['nginx-certs:/usr/local/nginx/certs']
volumes: {"nginx-certs"}
```

Note that for the above configuration, the private key and certificate files will be available under ``/var/lib/docker/volumes/websecuritydocker_nginx-certs/_data`` folder.

## Before you start

It is recommended to run ``SEC_RULE_ENGINE`` with ``DetectionOnly`` value to ensure that the implementation will not block any application functionality. If no alerts are to be detected on normal use of the application, you can change the value to ``On``to block potential attacks.

## Social and contact information

You can always contact me on:
- Twitter: [@LucianNitescu](https://twitter.com/LucianNitescu)
- Linkedin: [Lucian Nitescu](https://www.linkedin.com/in/luciannitescu/)


For any security issue or bugs please use the [github issue page](https://github.com/NitescuLucian/web-security-docker/issues) and please provide sufficient information.

## Based on the following projects

- docker-ssl-proxy: [https://github.com/fsouza/docker-ssl-proxy](https://github.com/fsouza/docker-ssl-proxy)
- docker-waf: [https://github.com/theonemule/docker-waf](https://github.com/theonemule/docker-waf)

## Why? It is not such a big deal...

This docker container was designed for my personal needs, and I needed something understandable, easy to deploy and easy to use (stupid proof level).

## Docker Hub Image

You can get the publicly available docker image at the following location: [web-security-docker](https://github.com/NitescuLucian/web-security-docker)
