FROM stevearc/pypicloud
MAINTAINER pruthviraj.kanmantha@gmail.com

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install packages required
ENV DEBIAN_FRONTEND noninteractive
ENV PYPICLOUD_VERSION 0.4.2
RUN apt-get update -qq \
  && apt-get install -y python-pip python2.7-dev libldap2-dev libsasl2-dev \
  && pip install virtualenv
RUN virtualenv /env
RUN /env/bin/pip install pypicloud[ldap,dynamo]==$PYPICLOUD_VERSION requests uwsgi pastescript redis

# Add the startup service
RUN mkdir -p /etc/my_init.d
ADD 0-setup-config.sh /etc/my_init.d/0-setup-config.sh
ADD pypicloud-uwsgi.sh /etc/my_init.d/pypicloud-uwsgi.sh

# Add the pypicloud config file
RUN mkdir -p /etc/pypicloud
ADD config.ini /etc/pypicloud/config.ini


# Add the command for easily creating config files
ADD make-config.sh /sbin/make-config

EXPOSE 8080
