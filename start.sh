#!/bin/bash

# 端口参数 （必填）
export WEBPORT=6705
export VMPORT=20045

# web.js 参数 （必填）
export UUID=3cdbeeb6-ade7-44f9-8192-c345fb710214
export WSPATH=serv00

# ARGO 隧道参数（如需固定 ARGO 隧道，请把 ey 开头的 ARGO 隧道的 token 填入 ARGO_AUTH ，仅支持这一种方式固定，隧道域名代理的协议为 HTTP ，端口为 VMPORT 同端口。如果不固定 ARGO 隧道，请删掉ARGO_DOMAIN那行，保留ARGO_AUTH这行。）
export ARGO_AUTH=''eyJhIjoiM2I3Zjk2MWZiYjIwZjgzOTgyYTM3OWEwOWQ4NDkyYjIiLCJ0IjoiYzIyZDU5NTItYjg5NC00ZGViLWJmNTQtOTMwNWQ1MGM4YTM3IiwicyI6Ik1ETmpOVEZqTlRNdE5HUTJaUzAwTXpVNUxUaGhOV0l0T0RjME5UUTBaRFk0T1RZMSJ9
export ARGO_DOMAIN=tunnel00.host.at.eu.org

# 网页的用户名和密码（可不填，默认为 admin 和 password ，如果不填请删掉这两行）
export WEB_USERNAME=root
export WEB_PASSWORD=5006

# 启动程序
USERNAME=$(whoami)
WORKDIR="/home/${USERNAME}/xray"
IP_ADDRESS=$(devil vhost list public | awk '/Public addresses/ {flag=1; next} flag && $1 ~ /^[0-9.]+$/ {print $1; exit}' | xargs echo -n)
mkdir -p ${WORKDIR}
cd ${WORKDIR} && \
[ ! -e ${WORKDIR}/entrypoint.sh ] && wget https://raw.githubusercontent.com/k0baya/X-for-serv00/main/entrypoint.sh -O ${WORKDIR}/entrypoint.sh && chmod +x ${WORKDIR}/entrypoint.sh && \
[ ! -e ${WORKDIR}/server.js ] && wget https://raw.githubusercontent.com/k0baya/X-for-serv00/main/server.js -O ${WORKDIR}/server.js && \
[ ! -e ${WORKDIR}/package.json ] && wget https://raw.githubusercontent.com/k0baya/X-for-serv00/main/package.json -O ${WORKDIR}/package.json
echo 'Installing dependence......Please wait for a while.' && \
npm install >/dev/null 2>&1 && \
nohup node ${WORKDIR}/server.js >/dev/null 2>&1 &
sleep 30 && echo "X-for-Serv00 is trying to start up, please visit http://${IP_ADDRESS}:${WEBPORT} to get the configuration."
