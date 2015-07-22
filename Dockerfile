FROM pay4later/docker-wkhtmltopdf:latest
MAINTAINER Andrew Mackrodt <andrew.mackrodt@pay4later.com>

# install packages
RUN apt-get -q -y update && \
    apt-get -q -y install git libapache2-mod-php5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/*

# clone the phpwkhtmltopdf-server project
RUN git clone --depth 1 --branch 0.1.0 https://github.com/pay4later/phpwkhtmltopdf-server.git /opt/phpwkhtmltopdf-server && \
    rm -rf /var/www/html/ && \
    ln -s /opt/phpwkhtmltopdf-server/public/ /var/www/html && \
    cd /opt/phpwkhtmltopdf-server/ && \
    rm -rf .git/ && \
    php -r "readfile('https://getcomposer.org/installer');" | php && \
    php composer.phar install && \
    rm -f composer.phar

EXPOSE 80

ENTRYPOINT ["apache2ctl"]

CMD ["-D FOREGROUND"]