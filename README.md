# [Wagtail UI experiments](https://static-wagtail-ui-experiments.netlify.app/)

A lightweight website to simplify sharing of one-off UI experiments for the Wagtail CMS.

Initial setup:

```bash
npm install -g netlify-cli
netlify --telemetry-disable
netlify login
netlify deploy --dir static-wagtail-ui-experiments
```

Automated demo exporting and publishing, also rebuilding the index:

```bash
./export.sh --user arabic --path /admin/styleguide/ --alias rtl-styleguide-test
# Also supports a sessionid for sites with no auto-login implemented:
./export.sh --sessionid hselz7tvv2358h6isqm2fpbp8ipl6xql --path /admin/styleguide/ --alias rtl-styleguide-test
```

Alias it for easier reuse everywhere:

```bash
alias wagtail-static-demo=~/Dev/thibaudcolas/wagtail-ui-experiments/export.sh
wagtail-static-demo --origin http://localhost:8001 --path /admin/reports/page-types-usage/ --alias page-types-usage --sessionid hselz7tvv2358h6isqm2fpbp8ipl6xql
```

Manual steps:

```bash
wget --header="X-Auto-Login: admin" --no-host-directories --content-disposition --page-requisites --mirror --level=1 -P ./static-my-demo http://localhost:8000/admin/pages/60/edit/
wget --no-host-directories --mirror --level=1 -P ./static-my-demo http://localhost:8000/admin/sprite/
for i in `find static-my-demo -type f -name "*\?*"`; do mv $i `echo $i | cut -d '?' -f1`; done
netlify deploy --dir static-my-demo --alias my-demo
```
