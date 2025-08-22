# Dockerfile
FROM wordpress:php8.2-apache

# Copie uniquement le code applicatif (wp-content)
COPY ./wp-content /var/www/html/wp-content
