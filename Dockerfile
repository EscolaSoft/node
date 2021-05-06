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
  sudo \
  --no-install-recommends && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get update && \
  apt-get -y install nodejs gcc g++ make && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*
  
EXPOSE 80
CMD ["apache2-foreground"]
