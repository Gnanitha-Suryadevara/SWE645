# Name: Gnanitha Suryadevara
# Course: SWE 645 - HW2
# Purpose: Dockerfile to containerize the static web application using nginx

FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy our web app files into the nginx html directory
COPY index.html /usr/share/nginx/html/index.html
COPY survey.html /usr/share/nginx/html/survey.html
COPY error.html /usr/share/nginx/html/error.html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
