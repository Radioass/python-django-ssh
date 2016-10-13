#!/bin/bash

# Build a Django project and start it
django-admin.py startproject django_start

echo "===> start listening 80 port"
exec python ./django_start/manage.py runserver 0.0.0.0:80
