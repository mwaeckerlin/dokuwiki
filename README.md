# Docker Container for Dokuwiki

The image extends [mwaeckerlin/nginx](https://github.com/mwaeckerlin/nginx) by filling up the `/app` path. Connect it to [mwaeckerlin/php-fpm](https://github.com/mwaeckerlin/php-fpm) and share the volume `/app`.

It's completely rewritten and needs further tests and optimizations.

## Volumes

- `/dokuwiki/conf`: the configuration files
- `/dokuwiki/data`: the pages, files and other data
- `/dokuwiki/lib/plugins`: the installed plugins
- `/dokuwiki/lib/tpl`: the installed templates
