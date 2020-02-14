FROM phpdockerio/php74-cli:latest

# Create a directory for our application code.
RUN mkdir /app

# Copy our code (and downloaded composer dependencies.
COPY . /app

# Install our composer dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN cd /app && composer install --no-dev --no-progress

# Set our working directory.
WORKDIR /app

# We'll simply just output the example file as the CLI output and be done with it... it's proves it built and we packaged out files etc.
CMD ["php", "/app/examples/test.php"]
