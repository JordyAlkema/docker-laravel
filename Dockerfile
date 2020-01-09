FROM richarvey/nginx-php-fpm:1.8.2

ENV WEBROOT /var/www/laravel/public
ENV PHP_CATCHALL 0

RUN rm -rf /var/www/html
RUN mkdir /var/www/laravel

# Link local directory
ADD . /var/www/laravel

# Setup working directory
WORKDIR /var/www/laravel
RUN chown -R nginx:nginx /var/www/laravel

# Change nginx configuration
RUN sed -i 's#try_files $uri $uri/ =404;#try_files $uri $uri/ /index.php?$query_string;#g' /etc/nginx/sites-available/default.conf

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
RUN php artisan route:cache > /dev/null 2>&1 || echo "Could not cache routes due to error, continuing...."

RUN rm -f /var/www/laravel/storage/logs/*

CMD php artisan config:cache; sh /start.sh