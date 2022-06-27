#!/bin/bash
echo "========================================"
echo "Bootstrapping"
echo "========================================"

echo "========================================"
echo "Checking if any of the Minio base resources exists"
echo "========================================"

if [[ $(oc get deployment minio -n minio  --ignore-not-found) ]]
then
  echo "At the cluster exists the MinIO deployment"
  echo "========================================"
  echo "Please, clean all the pre-existing resources"
  echo "========================================"
  exit
else
  echo "Not MinIO deployed"
  echo "========================================"
  if [[ $(oc get ns minio --ignore-not-found) ]]
  then
    echo "MinIO namespace exists"
    echo "========================================"
    echo "========================================"
    echo "Please, clean all the pre-existing resources"
    echo "========================================"
    exit
  fi
fi

while true; do
    echo "========================================"
    echo "  Do you wish to deploy MinIO?"
    echo "    - Yes   : Deploy MinIO"
    echo "    - No    : Skip the MinIO deployment"
    echo "========================================"
    read -p "" minio
    case $minio in
        [Yy]* ) echo ""

                oc create -f yaml/*-ns.yaml

                while [[ $(oc get ns minio -o 'jsonpath={..status.phase}') != Active ]]; do
                  echo "The namespace is not still Active"
                  echo "..."
                  sleep 5
                done

                oc create -f yaml/minio-pvc.yaml
                oc create -f yaml/minio-service.yaml
                oc create -f yaml/webui-route.yaml
                oc create -f yaml/api-route.yaml
                oc create -f yaml/minio-deployment.yaml;

                while [[ $( oc get po -n minio -l app.kubernetes.io/name=minio -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
                  sleep 1
                  echo "MinIO is still starting"
                  echo "..."
                  sleep 5
                done

                echo "========================================"
                echo "MinIO WEBUI Route."
                echo "========================================"
                oc get route minio-webui -n minio -o 'jsonpath={..spec.host}'
                echo ""
                echo "========================================"
                echo "MinIO API Route."
                echo "========================================"
                oc get route minio-api -n minio -o 'jsonpath={..spec.host}'
                echo ""
                echo "========================================"

            break;;
        [Nn]* ) echo "MinIO is not going to be deployed"; break;;
        * ) for run in {1..10}; do
              echo ""
            done
            echo "========================================"
            echo "Please answer Yes or No."
            echo "========================================" ;;
    esac
done
