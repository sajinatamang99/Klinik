# Use official Apache image
FROM httpd:2.4

# Remove default content
RUN rm -rf /usr/local/apache2/htdocs/*

# Copy your Klinik app content to Apache's root directory
COPY ./app/ /usr/local/apache2/htdocs/

# Expose port 80
EXPOSE 80
