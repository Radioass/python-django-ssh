FROM python:2.7
MAINTAINER TenxCloud <dev@tenxcloud.com>

# Install packages
RUN apt-get update && apt-get install -y \
		supervisor \
                gcc \
		gettext \
		mysql-client libmysqlclient-dev \
		postgresql-client libpq-dev \
		sqlite3 \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV DJANGO_VERSION 1.10.2

RUN pip install mysqlclient psycopg2 django=="$DJANGO_VERSION"

# Install ssh
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh

# Configure environment variables
ENV PYTHON_VERSION 2.7
ENV ROOT_PASS ''
ENV AUTHORIZED_KEYS **None**

# ADD scripts
ADD start-sshd.sh /start-sshd.sh
ADD start-pythondemo.sh /start-pythondemo.sh
ADD run.sh /run.sh
ADD set_root_pw.sh /set_root_pw.sh
RUN chmod 755 /*.sh
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD supervisord-pythondemo.conf /etc/supervisor/conf.d/supervisord-pythondemo.conf

# Add volumes for app directory
VOLUME  ["/app"]

# Expose ports
EXPOSE 80 22

# Set the application directory as WORKDIR for this container
WORKDIR /app

CMD ["/run.sh"]
