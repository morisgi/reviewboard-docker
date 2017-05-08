FROM httpd:2.4

ENV DEBIAN_FRONTEND noninteractive

# Workaround due to broken deps in latest debian docker image
RUN apt update && apt remove -y libssl1.0.0 && apt install -y libaprutil1-dev
RUN apt update && apt install -y \
    patch \
    subversion \
    memcached \
    ca-certificates \
    python-setuptools \
    python-dev \
    python-ldap \
    python-mysqldb \
    python-svn \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    gcc \
    make \
    curl

RUN easy_install pip \
    && pip install python-memcached \
    && pip install mysql-python

ENV REVIEWBOARD_VERSION=2.5.10 MOD_WSGI_VERSION=4.5.15 MERCURIAL_VERSION=4.1.3

RUN pip install mercurial==$MERCURIAL_VERSION
RUN pip install ReviewBoard==$REVIEWBOARD_VERSION

RUN curl -L https://github.com/GrahamDumpleton/mod_wsgi/archive/$MOD_WSGI_VERSION.tar.gz | tar xzvf - \
    && cd mod_wsgi-$MOD_WSGI_VERSION \
    && ./configure \
    && make \
    && make install \
    && cd ../ \
    && rm -rf mod_wsgi-$MOD_WSGI_VERSION

COPY entrypoint.sh /entrypoint.sh
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

EXPOSE 80

VOLUME /var/www/

ENTRYPOINT ["/entrypoint.sh"]
