#!/usr/bin/env bash

while true; do
    POD=$(kubectl get pods -l app=helloworld --no-headers --show-all | grep Running | awk '{print $1}')
    if [[ !  -z  ${POD}  ]]
    then
        break
    fi
done

kubectl exec -ti ${POD} -c php -- \
    su www-data -c 'XDEBUG_CONFIG="PHPSTORM" php vendor/bin/phpunit -c phpunit.xml.dist'
