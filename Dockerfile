# Utilizamos la imagen oficial de PrestaShop
FROM prestashop/prestashop:latest

# Establecemos variables de entorno
ENV PS_DEV_MODE=true \
    PS_INSTALL_AUTO=1 \
    DB_SERVER=$DB_SERVER \
    DB_PORT=$DB_PORT \
    DB_NAME=$DB_NAME \
    DB_USER=$DB_USER \
    DB_PASSWORD=$DB_PASSWORD \
    ADMIN_EMAIL=$ADMIN_EMAIL \
    ADMIN_PASSWORD=$ADMIN_PASSWORD \
    PS_LANGUAGE=en \
    PS_COUNTRY=US \
    PS_DOMAIN=$CAPROVER_APP_DOMAIN

# Actualizamos el sistema y las herramientas necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    vim \
    curl \
    wget \
    rsync \
    apt-utils \
    gnupg \
    gnupg1 \
    gnupg2 \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    zlib1g-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    nano

# Instalamos las extensiones de PHP más comunes para PrestaShop
RUN docker-php-ext-install \
    mysqli \
    pdo_mysql \
    gd \
    mbstring \
    zip \
    opcache \
    intl \
    soap \
    xml \
    calendar \
    bcmath \
    pcntl \
    iconv

# Instalamos y habilitamos Xdebug para entornos de desarrollo
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Limpiamos los archivos temporales
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Instalamos Composer (útil para la instalación de dependencias si es necesario)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecemos permisos adecuados para el directorio de PrestaShop
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exponemos el puerto por defecto de Apache
EXPOSE 80

# Iniciamos el servidor Apache
CMD ["apache2-foreground"]
