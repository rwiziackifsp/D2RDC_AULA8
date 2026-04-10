FROM ubuntu:24.04


# PARA NÃO PRECISAR TECLAR sim (y)
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


# Configuração de diretórios
RUN a2enmod rewrite
RUN mkdir -p /run/mysqld /var/lib/mysql /var/www/html \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql \
    && chown -R www-data:www-data /var/www/html

# Limpa e inicializa o banco de dados
RUN rm -rf /var/lib/mysql/* \
    && mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	
	
#--- GIT AULA 8 ---
RUN git clone https://github.com/rwiziackifsp/D2RDC_AULA8.git /tmp/app \
    && cp -r /tmp/app/* /var/www/html/ \
    && rm -rf /tmp/app
	
# Garante que o script SQL de inicialização seja reconhecido pelo CMD abaixo
RUN cp /var/www/html/banco_contatos.sql /var/www/html/init.sql


#EXPÕE DAS DUAS PORTAS A SEREM USADAS, 80 HTML E 3306 PARA MARIA DB
EXPOSE 80 3306

# CMD SÓ SERÁ EXECUTAD QUANDO O CONTEINER RODAR (DOCKER RUN)
CMD ["bash", "-c", "\
    mysqld_safe --datadir=/var/lib/mysql & \
    sleep 8; \
    if [ ! -f /var/lib/mysql/.root_configured ]; then \
        mariadb -u root -e \"ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('root'); FLUSH PRIVILEGES;\"; \
        touch /var/lib/mysql/.root_configured; \
    fi; \
    until mariadb-admin -u root -proot ping --silent; do sleep 2; done; \
    if [ ! -f /var/lib/mysql/.init_done ]; then \
        if [ -f /var/www/html/init.sql ]; then \
            mariadb -u root -proot < /var/www/html/init.sql; \
        fi; \
        touch /var/lib/mysql/.init_done; \
    fi; \
    exec apachectl -D FOREGROUND \
"]