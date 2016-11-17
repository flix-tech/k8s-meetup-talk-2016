FROM ubuntu:16.10

RUN \
export DEBIAN_FRONTEND="noninteractive" &&\
apt-get update -qq && \
apt-get upgrade --yes -qq && \
apt-get install --yes -qq --no-install-recommends \
runit curl ca-certificates nano git bzip2 nginx openssh-server \
php-fpm php-xdebug php-xml php-sqlite3 php-mysql php-zip php-intl \
&& apt-get clean
ADD 99-xdebug.ini /etc/php/7.0/cli/conf.d/99-xdebug.ini
ADD 99-xdebug.ini /etc/php/7.0/fpm/conf.d/99-xdebug.ini
ADD keys/* /etc/ssh/
RUN \
chsh -s /bin/bash www-data && \
mkdir -p /var/run/sshd && \
echo "date.timezone=UTC" | tee /etc/php/7.0/cli/conf.d/timezone.ini /etc/php/7.0/fpm/conf.d/timezone.ini > /dev/null && \
# We want all enviroment variables reach php-fpm \
echo "clear_env = no" >> /etc/php/7.0/fpm/pool.d/www.conf && \
echo "catch_workers_output = yes" >> /etc/php/7.0/fpm/pool.d/www.conf && \
echo "access.log = /proc/self/fd/2" >> /etc/php/7.0/fpm/pool.d/www.conf && \
# Listen on localhost instead of domain socket \
sed -e "s/^listen = .*$/listen = 127.0.0.1:9000/" -i /etc/php/7.0/fpm/pool.d/www.conf && \
sed -e "s%^error_log = .*$%error_log = /proc/self/fd/2%" -i /etc/php/7.0/fpm/php-fpm.conf && \
sed -e "s%^pid = .*$%pid = /tmp/php-fpm.pid%" -i /etc/php/7.0/fpm/php-fpm.conf && \
curl -sSL https://getcomposer.org/composer.phar -o /usr/bin/composer && \
chmod +x /usr/bin/composer && \
echo 'www-data:www-data' | chpasswd && \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
WORKDIR /var/www/
