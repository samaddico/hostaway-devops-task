FROM nginx:1.27-alpine

# Remove the default index page
RUN rm -rf /usr/share/nginx/html/*

# Copy custom HTML into container
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
