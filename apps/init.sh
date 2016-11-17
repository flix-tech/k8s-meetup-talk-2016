#!/usr/bin/env bash
cd $(dirname $(realpath $0))
set -euv

mkdir -p /nfs-data/composer
mkdir -p /sock
chown vagrant /sock
ln -f $SSH_AUTH_SOCK /sock/sock
echo 'ln -f "$SSH_AUTH_SOCK" /sock/sock' > /home/vagrant/.bashrc

kubectl apply -f helloworld/k8s/db.yml
(cd helloworld/docker/; docker build -t dev .)
kubectl delete pod -lapp=helloworld
kubectl apply -f helloworld/k8s/

set +v

while true; do
    POD=$(kubectl get pods -l app=helloworld --no-headers --show-all | grep Running | awk '{print $1}')
    if [[ !  -z  ${POD}  ]]
    then
        break
    fi
    echo '.'
    sleep 1
done

kubectl exec -i ${POD} -c php -- \
    su www-data -c "composer install --prefer-dist --no-interaction --no-progress"

while true; do
    POD2=$(kubectl get pods -l app=demo-db --no-headers --show-all | grep Running | awk '{print $1}')
    if [[ !  -z  ${POD2}  ]]
    then
        break
    fi
    echo '.'
    sleep 1
done

kubectl exec -i ${POD} -c php -- \
    su www-data -c "php bin/console doctrine:schema:create -n -q; php bin/console doctrine:fixtures:load -n"
