#!/bin/sh
# Purpose: Install all packages for a ALL-IN-ALL docker image.
# Author: Zhang Huangbin <zhb@iredmail.org>

# Required binary packages.
PKGS_BASE="ca-certificates"
PKGS_MYSQL="mariadb mariadb-client"
PKGS_NGINX="nginx"
PKGS_PHP_FPM="php7 php7-fpm"
PKGS_POSTFIX="postfix postfix-pcre postfix-mysql"
PKGS_DOVECOT="dovecot dovecot-lmtpd dovecot-pop3d dovecot-pigeonhole-plugin dovecot-mysql"
PKGS_AMAVISD="amavisd-new"
PKGS_SPAMASSASSIN="spamassassin"
PKGS_CLAMAV="clamav"
PKGS_IREDAPD="py2-sqlalchemy py-setuptools py2-dnspython py2-mysqlclient py2-pip py2-more-itertools py2-six py2-markdown"
PKGS_MLMMJ="mlmmj altermime"
PKGS_MLMMJADMIN="py-requests uwsgi uwsgi-python uwsgi-syslog py2-more-itertools py2-six py2-markdown"
PKGS_ROUNDCUBE="php7-mysqli php7-pdo_mysql php7-ldap php7-json php7-gd php7-mcrypt php7-curl php7-intl php7-xml php7-mbstring php7-zip mariadb-client aspell php7-pspell"

# Required Python modules.
PIP_MODULES="web.py==0.40"

# Install packages.
apk add --no-cache --progress \
    ${PKGS_BASE} \
    ${PKGS_MYSQL} \
    ${PKGS_NGINX} \
    ${PKGS_PHP_FPM} \
    ${PKGS_POSTFIX} \
    ${PKGS_DOVECOT} \
    ${PKGS_AMAVISD} \
    ${PKGS_SPAMASSASSIN} \
    ${PKGS_CLAMAV} \
    ${PKGS_IREDAPD} \
    ${PKGS_MLMMJ} \
    ${PKGS_MLMMJADMIN} \
    ${PKGS_ROUNDCUBE}

# Install Python modules.
pip install \
    --no-cache-dir \
     \
    ${PIP_MODULES}

# Add required system accounts.
addgroup -g 2002 iredapd
adduser -D -H -u 2002 -G iredapd -s /sbin/nologin iredapd

# Install iRedAPD.
wget -c https://dl.iredmail.org/yum/misc/iRedAPD-3.3.tar.bz2 && \
tar xjf iRedAPD-3.3.tar.bz2 -C /opt && \
rm -f iRedAPD-3.3.tar.bz2 && \
ln -s /opt/iRedAPD-3.3 /opt/iredapd && \
chown -R iredapd:iredapd /opt/iRedAPD-3.3 && \
chmod -R 0500 /opt/iRedAPD-3.3 && \

# Install mlmmjadmin.
wget -c https://github.com/iredmail/mlmmjadmin/archive/2.1.tar.gz && \
tar zxf 2.1.tar.gz -C /opt && \
rm -f 2.1.tar.gz && \
ln -s /opt/mlmmjadmin-2.1 /opt/mlmmjadmin && \
chown -R mlmmj:mlmmj /opt/mlmmjadmin-2.1 && \
chmod -R 0500 /opt/mlmmjadmin-2.1

# Install Roundcube.