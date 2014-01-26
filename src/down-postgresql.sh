# Title:        down-postgresql.sh
# Description:  Tear down PostgreSQL and its Ruby connector
# Author:       Matthew Norris

# sudo gem uninstall postgres
sudo aptitude remove postgresql libpq-dev pgadmin3 python-psycopg2 -y
