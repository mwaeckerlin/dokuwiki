Docker Container for Dokuwiki
=============================

The image inherits [mwaeckerlin/php-fpm](https://github.com/mwaeckerlin/php-fpm), please also check the available configurations options there.

Environment
-----------

- `BASEURL`: base URL of the dokuwiki instance without path
- `BASEDIR`: path of the URL of the dokiwiki instance

Create a default administrator user:

- `ADMIN`: name of the administrator, default: `admin`
- `PASSWORD`: password of the administrator, by default no administrator is created
- `NAME`: optional name of the administartor user
- `MAIL`: optional mailof the administartor user

To create an administrator user, set at least `PASSWORD`.

Volumes
-------

- `/dokuwiki/conf`: the configuration files
- `/dokuwiki/data`: the pages, files and other data
- `/dokuwiki/lib/plugins`: the installed plugins
- `/dokuwiki/lib/tpl`: the installed templates
