FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    mariadb-server \
    mariadb-client \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# Configura diretórios e permissões
RUN mkdir -p /run/mysqld /var/lib/mysql /var/www/html \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql \
    && chown -R www-data:www-data /var/www/html

# --- MUDANÇA: CLONANDO O REPOSITÓRIO DIRETAMENTE ---
RUN rm -rf /var/www/html/*
# Substitua pela URL real do seu repositório Git
RUN git clone https://github.com/rwiziackifsp/D2RDC_AULA8.git /var/www/html/

# Ajusta permissões dos arquivos baixados
RUN chown -R www-data:www-data /var/www/html
# --------------------------------------------------

RUN rm -rf /var/lib/mysql/* \
    && mariadb-install-db --user=mysql --datadir=/var/lib/mysql

EXPOSE 80 3306

CMD ["bash", "-c", "\
    mysqld_safe --datadir=/var/lib/mysql & \
    sleep 8; \
    if [ ! -f /var/lib/mysql/.root_configured ]; then \
        mariadb -u root -e \"ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('root'); FLUSH PRIVILEGES;\"; \
        touch /var/lib/mysql/.root_configured; \
    fi; \
    until mariadb-admin -u root -proot ping --silent; do sleep 2; done; \
    if [ ! -f /var/lib/mysql/.init_done ]; then \
        # AJUSTADO PARA O NOME DO SEU ARQUIVO SQL:
        if [ -f /var/www/html/banco_contatos.sql ]; then \
            mariadb -u root -proot < /var/www/html/banco_contatos.sql; \
        fi; \
        touch /var/lib/mysql/.init_done; \
    fi; \
    exec apachectl -D FOREGROUND \
"]