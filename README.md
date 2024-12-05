[![tests](https://github.com/ddev/ddev-addon-template/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-addon-template/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

# ddev-matomo <!-- omit in toc -->


## What is ddev-matomo?

ddev-matomo provides an integration with Matomo - the
leading open-source analytics platform that gives you
more than powerful analytics.

## Getting started

1. Install the plugin with `ddev get valthebald/ddev-matomo`
2. Review your database settings in .ddev/docker-compose.matomo.yaml
3. Create matomo database if needed with `echo "SHOW TABLES;" | ddev import-db --database=${MATOMO_DATABASE_DBNAME}`'
4. Restart DDEV to install it with `ddev restart`
5. Access https://matomo.\<projectname\>.ddev.site in your browser and follow the installation steps
