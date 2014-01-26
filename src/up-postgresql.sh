# Title:        up-postgresql.sh
# Description:  Setup PostgreSQL and its Ruby connector
# Author:       Matthew Norris
# Reference:    http://nachbar.name/blog/2008/11/28/rails-and-postgresql-on-ubuntu-hardy-804-lts/
#               https://help.ubuntu.com/community/PostgreSQL
#               http://antoniocangiano.com/2007/12/26/installing-django-with-postgresql-on-ubuntu/

sudo aptitude install postgresql libpq-dev pgadmin3 python-psycopg2 -y
# sudo gem install postgres

# NOTE: pgadmin3 is a GUI for PostgreSQL

################################################################################
# Test your Ruby installation with these commands
################################################################################

# $irb
# irb(main):005:0> require 'rubygems'
# => true
# irb(main):006:0> require 'postgres'
# => true
