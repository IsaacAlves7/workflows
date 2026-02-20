#!/bin/bash

sudo yum -y install wget tar gcc make
wget https://ftp.postgresql.org/pub/source/v11.5/postgresql-11.5.tar.gz
tar -zxvf postgresql-11.5.tar.gz
cd postgresql-11.5/
./configure --without-readline --without-zlib
make
sudo make install
sudo ln -s /usr/local/pgsql/bin/psql /usr/bin/psql || (sudo unlink /usr/bin/psql && sudo ln -s /usr/local/pgsql/bin/psql /usr/bin/psql)
sudo ln -s /usr/local/pgsql/bin/pg_dump /usr/bin/pg_dump || (sudo unlink /usr/bin/pg_dump && sudo ln -s /usr/local/pgsql/bin/pg_dump /usr/bin/pg_dump)
sudo ln -s /usr/local/pgsql/bin/dropdb /usr/bin/dropdb || (sudo unlink /usr/bin/dropdb && sudo ln -s /usr/local/pgsql/bin/dropdb /usr/bin/dropdb)
sudo ln -s /usr/local/pgsql/bin/createdb /usr/bin/createdb || (sudo unlink /usr/bin/createdb && sudo ln -s /usr/local/pgsql/bin/createdb /usr/bin/createdb)
psql --version && cd .. && rm -rf ~/postgresql-11.5 ~/postgresql-11.5.tar.gz