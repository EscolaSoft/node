FROM httpd:latest
MAINTAINER Gutar "<admin@escolasoft.com>"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
  curl \
  git-core \
  gzip \
  openssh-client \
  unzip \
  zip \
  ssh \
  wget \
  git \
  gcc \
  g++ \
  make \
  --no-install-recommends && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt -y install nodejs gcc g++ make && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*
  
RUN { \
  echo "<VirtualHost *:80>"; \
  echo "  DocumentRoot /var/www/html"; \
  echo "  LogLevel warn"; \
  echo "  ErrorLog /var/log/apache2/error.log"; \
  echo "  CustomLog /var/log/apache2/access.log combined"; \
  echo "  ServerSignature Off"; \
  echo "  <Directory /var/www/html>"; \
  echo "    Options +FollowSymLinks"; \
  echo "    Options -ExecCGI -Includes -Indexes"; \
  echo "    AllowOverride all"; \
  echo; \
  echo "    Require all granted"; \
  echo "  </Directory>"; \
  echo "  <LocationMatch assets/>"; \
  echo "    php_flag engine off"; \
  echo "  </LocationMatch>"; \
  echo; \
  echo "  IncludeOptional sites-available/000-default.local*"; \
  echo "</VirtualHost>"; \
  } | tee /etc/apache2/sites-available/000-default.conf
  
RUN echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf && \
  echo "date.timezone = Europe/Warsaw" > /usr/local/etc/php/conf.d/timezone.ini && \
  echo "log_errors = On\nerror_log = /dev/stderr" > /usr/local/etc/php/conf.d/errors.ini && \
  a2enmod rewrite

EXPOSE 80
CMD ["apache2-foreground"]
