FROM richarvey/nginx-php-fpm:1.8.2

ENV WEBROOT /var/www/laravel/public

RUN rm -rf /var/www/html
RUN mkdir /var/www/laravel

# Link local directory
ADD . /var/www/laravel

# Setup working directory
WORKDIR /var/www/laravel
RUN chown -R nginx:nginx /var/www/laravel

# Install PHP Dependicies
RUN composer install --ignore-platform-reqs

# Set env
RUN cp .env.docker .env

# Laravel configuration
RUN php artisan key:generate

# Clears all laravel cache that exists
RUN php artisan view:clear

# Laravel optimization
RUN php artisan optimize > /dev/null 2>&1 || echo "An error occured while optimising, continuing..."
RUN php artisan config:cache
RUN php artisan route:cache > /dev/null 2>&1 || echo "Could not cache routes due to error, continuing...."
