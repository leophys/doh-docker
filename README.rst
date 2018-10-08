==========
DOH-Docker
==========

A docker image to host a simple instance of one's own DNS-over-HTTPS proxy.

Why
===

Because browsers are beginning to migrate_ to DOH (DNS-over-HTTPS). Motivations
for securing the DNS traffic make a lot of sense. But the risk to run towards
a new monopoly is high. This project should encourage people to deploy one's own
resolver.

Break down
==========

This project is a patchwork of others:

  - doh-proxy_: a HTTP-to-DNS proxy written in Rust.
  - letsencrypt_: the Mozilla free certification authority (and the related certbot utility).
  - nginx_: a very nice HTTP server and reverse proxy.

All the above is glued together via docker_ and orchestrated by supervisord_.

What does what
==============

``doh-proxy`` is responsible to receive the HTTP request on a specific path and issue a
corresponding DNS request (and serve the response as HTTP response).
``letsencrypt`` provides a widely accepted certificate for TLS secure connection and
``nginx`` proxies the HTTP connection into a secure HTTP2 connection for the clients
to be used.

What do you need
================

You need three things:

  - A machine with a public ip address, ideally always up, capable
    of running docker and with TCP ports 80 and 443 reachable from
    the outside and able to DNS-query towards a chosen server.
  - A domain that resolves on the said machine.
  - An email to be able to obtain a valid TLS certificate from letsencrypt.

This translate directly in two environment variables to be passed to
the running container:

  - ``EMAIL`` should be a valid email address under your control.
  - ``DOMAINS`` should be a space-separated list of domains to which your
    machine is reachable (can also be a single name).

Optionally you may tweak with the upstream dns resolver (i.e. **where all the queries
are sent, in the end - you may want to really change it from the default google
resolver - 8.8.8.8:53**) and the path to which the HTTP server responds:

  - ``UPSTREAM_DNS`` should be a valid IP address plus the UDP port (defaults to
    google's ``8.8.8.8:53``).
  - ``DOH_PATH`` should be a path, that begins with a ``/``.

Do you need it
==============

No, you don't. You may yet have a VPS with an HTTP server that you may want to use
for the purpose. In this case, I invite you to take a look at doh-proxy_ and to
use it directly.

How to use it
=============

Shallow
-------

.. code:: bash

   $ docker run --restart unless-stopped \
         -e DOMAINS="my.domain.org" \
         -e EMAIL="me@myemail.org" \
         --name="my-doh-resolver" \
         leophys/doh-proxy

Paranoid (preferred way)
------------------------

On the machine you want to run the resolver you'll need:

- ``GNU make``
- ``git``
- ``docker`` (of course)

Then run:

.. code:: bash

   $ git clone https://github.com/leophys/doh-docker
   $ cd doh-docker
   $ make run -e DOH_DOMAINS="my.domain.com myother.domain.com" \
                 DOH_EMAIL="me@myemail.org"

If you don't trust me (you shouldn't), **read the code**.


Licence
=======

See LICENCE_.


.. _migrate: https://blog.usejournal.com/getting-started-with-dns-over-https-on-firefox-e9b5fc865a43
.. _doh-proxy: https://github.com/jedisct1/rust-doh
.. _letsencrypt: https://letsencrypt.org/
.. _nginx: https://www.nginx.com/
.. _docker: https://www.nginx.com/
.. _supervisord: http://supervisord.org/
.. _LICENCE: https://github.com/leophys/doh-docker/blob/master/LICENCE
