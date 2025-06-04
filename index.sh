#!/bin/bash

site=$1

site_id=$(netlify api listSites --data "{ \"name\": \"$site\" }" | jq -r '.[0].id' )
sites=$(netlify api listSiteDeploys --data "{ \"site_id\": \"$site_id\" }" | jq '[group_by(.branch)[] | max_by(.updated_at)]' | jq -r 'sort_by(.updated_at) | reverse | map(select(.branch != null) | .updated_at |= (.[:10])) | .[] | "<li><a href=\"\(.deploy_url)\">\(.branch)</a> (\(.updated_at))</li>"')

echo $sites

mkdir ./$site
cat <<EOF > ./$site/index.html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Static UI experiments for Wagtail</title>
    <meta name="color-scheme" content="light dark" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link
      rel="icon"
      href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>⚡</text></svg>"
    />
    <meta
      name="description"
      content="Fully static experiments in the Wagtail admin interface"
    />
    <style>
    body {
      font-family: "system-ui", "Arial", sans-serif, "Apple Color Emoji",
        "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
      font-size: clamp(1rem, calc(1dvmax + 1rem), 5dvmin);
      --light-dark: color-mix(in oklch, CanvasText 10%, Canvas 50%);
      --dark-light: color-mix(in oklch, Canvas 10%, CanvasText 50%);
      color: color-mix(in oklch, var(--light-dark) 20%, CanvasText);
    }
</style>
  </head>
  <body>
    <main>
      <h1>Static UI experiments for Wagtail</h1>
      <p>Current experiments:</p>
      <ol>$sites</ol>
    </main>
  </body>
</html>
EOF

netlify deploy --dir $site --prod
