#!/bin/bash

export KUBE_NAMESPACE=${ENVIRONMENT}
export KUBE_SERVER=${KUBE_SERVER}

if [[ -z ${VERSION} ]] ; then
    export VERSION=${IMAGE_VERSION}
fi

if [[ ${KUBE_NAMESPACE} == "cs-prod" ]] ; then
    echo "deploy ${VERSION} to prod namespace, using HOCS_DOCS_PROD_CS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_PROD_CS}
    export REPLICAS="2"
elif [[ ${KUBE_NAMESPACE} == "wcs-prod" ]] ; then
    echo "deploy ${VERSION} to prod namespace, using HOCS_DOCS_PROD_WCS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_PROD_WCS}
    export REPLICAS="2"
elif [[ ${KUBE_NAMESPACE} == "cs-qa" ]] ; then
    echo "deploying ${VERSION} to test namespace, using HOCS_DOCS_QA_CS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_QA_CS}
    export REPLICAS="2"
elif [[ ${KUBE_NAMESPACE} == "wcs-qa" ]] ; then
    echo "deploying ${VERSION} to test namespace, using HOCS_DOCS_QA_WCS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_QA_WCS}
    export REPLICAS="2"
elif [[ ${KUBE_NAMESPACE} == "cs-demo" ]] ; then
    echo "deploy ${VERSION} to demo namespace, using HOCS_DOCS_DEMO_CS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_DEMO_CS}
    export REPLICAS="1"
elif  [[ ${KUBE_NAMESPACE} == "wcs-demo" ]] ; then
    echo "deploy ${VERSION} to demo namespace, using HOCS_DOCS_DEMO_WCS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_DEMO_WCS}
    export REPLICAS="1"
elif [[ ${KUBE_NAMESPACE} == "cs-dev" ]] ; then
    echo "deploy ${VERSION} to dev namespace, using HOCS_DOCS_DEV_CS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_DEV_CS}
    export REPLICAS="1"
elif [[ ${KUBE_NAMESPACE} == "wcs-dev" ]] ; then
    echo "deploy ${VERSION} to dev namespace, using HOCS_DOCS_DEV_WCS drone secret"
    export KUBE_TOKEN=${HOCS_DOCS_DEV_WCS}
    export REPLICAS="1"
else
    echo "Unable to find environment: ${ENVIRONMENT}"        
fi


if [[ -z ${KUBE_TOKEN} ]] ; then
    echo "Failed to find a value for KUBE_TOKEN - exiting"
    exit -1
fi

cd kd

if [[ ${KUBE_NAMESPACE} == "wcs-prod" ]] ; then
    kd --insecure-skip-tls-verify \
       --timeout 10m \
        -f deployment-wcs-prod.yaml \
        -f service.yaml \
        -f autoscale.yaml
else
    kd --insecure-skip-tls-verify \
       --timeout 10m \
        -f deployment.yaml \
        -f service.yaml \
        -f autoscale.yaml
fi
