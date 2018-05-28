FROM alpine:3.7

# add PHP, extensions and third-party software
ENV GID=991 \
    UID=991 \
    UPLOAD_MAX_SIZE=50M \
    PHP_MEMORY_LIMIT=128M \
    OPCACHE_MEMORY_LIMIT=128

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories \
 && apk add -U \
    nginx \
    su-exec \
    curl \
    php7-dev@community \
    php7-pdo@community \
    php7-pdo_mysql@community \
    php7-exif@community \
    php7-zip@community \
    php7-gd@community \
    php7-opcache@community \
    graphicsmagick \
    mysql-client \
    unzip \
    freetype-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libpng-dev

COPY rootfs /
RUN chown -R $GID:$UID /usr/local/bin /db
RUN chmod +x /usr/local/bin/* /db/*

# set recommended PHP.ini settings
# see http://docs.filerun.com/php_configuration
COPY rootfs/filerun/config/filerun-optimization.ini /usr/local/etc/php/conf.d/

# Install ionCube
RUN curl -O http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
 && PHP_EXT_DIR=$(/usr/bin/php-config7 --extension-dir) \
 && cp "ioncube/ioncube_loader_lin_7.2.so" $PHP_EXT_DIR \
 && echo "zend_extension=ioncube_loader_lin_7.2.so" >> /usr/local/etc/php/conf.d/00_ioncube_loader_lin_7.2.ini \
 && rm -rf ioncube ioncube_loaders_lin_x86-64.tar.gz

# Install FileRun
RUN curl -o /filerun.zip -L https://www.filerun.com/download-latest-php71 \
 && mkdir /user-files \
 && chown $GID:$UID /user-files

VOLUME /user-files
USER root
ENTRYPOINT ["entrypoint.sh"]
