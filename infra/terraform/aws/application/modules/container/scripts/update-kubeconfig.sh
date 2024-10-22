#!/bin/bash

CLUSTER_NAME=$1
REGION="us-west-2"

aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME
