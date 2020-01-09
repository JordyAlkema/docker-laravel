FROM richarvey/nginx-php-fpm:1.8.2

# Set the enviroment variables
ENV WEBROOT /var/www/laravel/public
ENV PHP_CATCHALL 0

# Setup the folder structure
RUN rm -rf /var/www/html
RUN mkdir /var/www/laravel
ADD . /var/www/laravel
RUN chown -R nginx:nginx /var/www/laravel

# Update the nginx config to support Laravel
RUN sed -i 's#try_files $uri $uri/ =404;#try_files $uri $uri/ /index.php?$query_string;#g' /etc/nginx/sites-available/default.conf

# Install PHP Dependicies
WORKDIR /var/www/laravel
RUN composer install --ignore-platform-reqs

# Copy the enviroment file
RUN cp .env.docker .env

# Laravel configuration
RUN php artisan key:generate
RUN php artisan view:clear

# Laravel optimization
RUN php artisan optimize > /dev/null 2>&1 || echo "An error occured while optimising, continuing..."
RUN php artisan route:cache > /dev/null 2>&1 || echo "Could not cache routes due to error, continuing...."

CMD php artisan config:cache; sh /start.sh