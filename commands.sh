#!/bin/sh

set -e


# Perform all actions as user 'postgres'
export PGUSER=postgres

# Create the 'template_postgis' template db
psql <<EOSQL
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Populate 'template_postgis'
psql --dbname template_postgis < /usr/share/postgresql/9.4/contrib/postgis-2.1/postgis.sql
psql --dbname template_postgis < /usr/share/postgresql/9.4/contrib/postgis-2.1/topology.sql
psql --dbname template_postgis < /usr/share/postgresql/9.4/contrib/postgis-2.1/spatial_ref_sys.sql

psql <<EOSQL
CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;
CREATE DATABASE swipebuydb WITH TEMPLATE template_postgis;
CREATE USER swipebuyuser WITH PASSWORD 'djeuiiouy8973649ouijkjkajdu8';
GRANT ALL PRIVILEGES ON DATABASE swipebuydb TO swipebuyuser;
ALTER USER swipebuyuser WITH SUPERUSER;
EOSQL
