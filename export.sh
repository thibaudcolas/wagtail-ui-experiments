#!/bin/bash

# Named arguments.
while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
    v="${1/--/}"
    declare $v="$2"
  fi
  shift
done

# Also supports a sessionid parameter for sites with no auto-login setup.
if [ -z "$user" ]; then user=admin; fi
if [ -z "$origin" ]; then origin=http://localhost:8000; fi
if [ -z "$path" ]; then path=/admin/; fi
if [ -z "$alias" ]; then alias=wip; fi
if [ -z "$site" ]; then site=static-wagtail-ui-experiments; fi



mkdir -p ./static-$alias


# If sessionid is set up, use it.
echo $sessionid
if [ -z "$sessionid" ]; then
  wget --header="X-Auto-Login: $user" --no-host-directories --content-disposition --page-requisites --mirror --level=1 -P ./static-$alias $origin$path
else
  domain_and_port=$(echo $origin | cut -d '/' -f3)
  echo "$domain_and_port	FALSE	/	FALSE	1745303695	sessionid	$sessionid" > ./static-$alias/cookies.txt
  wget --load-cookies ./static-$alias/cookies.txt --no-host-directories --content-disposition --page-requisites --mirror --level=1 -P ./static-$alias $origin$path
fi


wget --no-host-directories --mirror --level=1 -P ./static-$alias $origin/admin/sprite/
for i in `find static-$alias -type f -name "*\?*"`; do mv $i `echo $i | cut -d '?' -f1`; done

echo "/ $path" > ./static-$alias/_redirects

netlify deploy --site $site --dir static-$alias --alias $alias

echo "https://$alias--$site.netlify.app${path}"
echo "https://$alias--$site.netlify.app${path}" | pbcopy
open "https://$alias--$site.netlify.app${path}"

# Find path to current file.
bin=$(dirname $(readlink -f $0))

$bin/index.sh $site
