CREATE ROLE ckan        WITH LOGIN PASSWORD 'ckan';
CREATE DATABASE ckan     OWNER ckan;

CREATE ROLE datastore   WITH LOGIN PASSWORD 'ckan_datastore';
CREATE ROLE datastore_ro WITH LOGIN PASSWORD 'ckan_datastore';

CREATE DATABASE datastore OWNER datastore;
\connect datastore
CREATE EXTENSION IF NOT EXISTS hstore;

