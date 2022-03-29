#!/usr/bin/bash
set -e
if [[ -z "${UPDATER_URL}" ]]; then
  echo "$UPDATER_URL env variable is not set, exiting"
  exit 1
fi
IP_IN_RECORD=1.0.0.0
REAL_IP=0.0.0.0
function google(){
    dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | cut -d'"' -f 2
}
function openDns(){
    dig @resolver4.opendns.com myip.opendns.com +short
}
echo 'Initializing...'
echo 'google  dig IP:' $(google)
echo 'openDNS dig IP:' $(openDns) 
i=1
while :
do
    ((i=i+1))
    REAL_IP=$(google) || REAL_IP=$(openDns) || sleep 2 || exit 1

    if [ "$REAL_IP" != "$IP_IN_RECORD" ] && [  -n "$REAL_IP" ] && [[ $REAL_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Changing IP from" $IP_IN_RECORD "to" $REAL_IP " -- " $(date) " -- update number:" $i
        curl -s $UPDATER_URL  || echo 'failed to update freedns' || exit 1
        IP_IN_RECORD=$REAL_IP
    #else
        # echo "IP didnt change"
    fi
    sleep 10 #seconds
done
