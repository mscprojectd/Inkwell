FROM httpd:latest

# Copy index.html to Apache document root
COPY index.html /usr/local/apache2/htdocs/

# Install OpenSSL
RUN apt-get update && \
    apt-get install -y openssl

# Generate self-signed SSL certificate and private key
RUN openssl req -x509 -newkey rsa:4096 -nodes -keyout /usr/local/apache2/conf/server.key \
    -out /usr/local/apache2/conf/server.crt -days 365 -subj "/CN=UDITPROJECT"

# Enable necessary Apache modules
RUN sed -i '/mod_ssl.so/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN sed -i '/mod_socache_shmcb.so/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Update Apache configuration to enable SSL
RUN sed -i '/#Include conf\/extra\/httpd-ssl.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Copy custom SSL configuration
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf

# Expose ports for HTTP and HTTPS
EXPOSE 80
EXPOSE 443

