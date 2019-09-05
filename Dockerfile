FROM ubuntu:12.04

COPY sources.list /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y \
  apache2 \
  apache2-dev \
  bison \
  build-essential \
  curl \
  flex \
  libdbd-mysql \
  libmcrypt-dev \
  libmysqlclient-dev \
  libtool \
  mysql-client \
  nano \
  wget

RUN ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so.18 /usr/lib/
RUN ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so

ENV PHP_VERSION 4.4.9
RUN mkdir -p /tmp/install/ \
  && cd /tmp/install \
  && wget http://museum.php.net/php4/php-${PHP_VERSION}.tar.bz2 \
  && tar xfj php-${PHP_VERSION}.tar.bz2 \
  && cd php-${PHP_VERSION} \
  && cd /tmp/install/php-${PHP_VERSION} \
  && ./configure \
  --prefix=/usr/local/php4 \
  --with-apxs2=/usr/bin/apxs2 \
  --with-mcrypt \
  --with-mysql=/usr \
  --with-zlib-dir \
  && make \
  && make install \
  && rm -rf /tmp/install

COPY php/phpinfo.php /var/www/index.php
COPY php/php.ini /usr/local/php4/lib/php.ini

COPY apache/ports.conf /etc/apache2/ports.conf
COPY apache/default /etc/apache2/sites-available/default
COPY apache/dir.conf /etc/apache2/mods-available/dir.conf

WORKDIR /var/www

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
