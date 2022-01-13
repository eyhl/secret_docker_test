#!/bin/sh
#dvc pull
#export KEY=$(dotenv -f "/root/project/vars.env" get YOUR_API_KEY)
#echo $KEY
echo $KEY
#echo $(dotenv -f "/root/project/vars.env" get YOUR_API_KEY)
# if [ ! -d /run/secrets ]; then
#   exec "$@"
# fi

# if [ -z "${YOUR_API_KEY}" ]; then
#   exec "$@"
# fi

# eval "$(find /run/secrets -maxdepth 1 -type f | grep "$(echo "${YOUR_API_KEY}" | sed 's/;/\\|/g')" | xargs cat | grep -v '^#' | sed 's/^\([^=]\+\)=\(.*\)$/if [ -z "$\1" ]; then \1="\2"; export \1; fi/g')"

# exec "$@"

#export KEY=d26e92732bb5c5949a85c45d52822ae4d3e2693f
#dotenv.cli:cli -f "vars.env" get YOUR_API_KEY
wandb login $YOUR_API_KEY