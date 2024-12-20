# Menggunakan image PHP dengan FPM
FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install npm dan Node.js untuk kebutuhan frontend
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Buat direktori kerja
WORKDIR /var/www

# Salin seluruh file proyek ke container
COPY . .

# Install dependensi aplikasi
RUN composer install

RUN npm install

RUN npm run dev

RUN php artisan key:generate

RUN chmod -R 777 /var/www/storage /var/www/bootstrap/
