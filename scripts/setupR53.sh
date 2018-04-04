#!/bin/sh

DOMAIN=serverlessperf.com
SUBDOMAIN=demo.${DOMAIN}
STACKNAME=global-app-dev
HOSTEDZONE=$(aws route53 list-hosted-zones --query 'HostedZones[?Name==`'${DOMAIN}'.`].Id' --output text)
USDOMAIN=$(aws cloudformation describe-stacks --stack-name ${STACKNAME} --region us-east-1 --query 'Stacks[0].Outputs[?OutputKey==`DomainName`].OutputValue' --output text)
EUROPEDOMAIN=$(aws cloudformation describe-stacks --stack-name ${STACKNAME} --region eu-central-1 --query 'Stacks[0].Outputs[?OutputKey==`DomainName`].OutputValue' --output text)

aws route53 change-resource-record-sets \
  --hosted-zone-id ${HOSTEDZONE} \
  --change-batch  '{
      "Comment": "optional comment about the changes in this change batch request",
      "Changes": [
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": "'${SUBDOMAIN}'",
            "Type": "CNAME",
            "TTL": 300,
            "SetIdentifier": "us-east-1",
            "Region": "us-east-1",
            "ResourceRecords": [
              {
                "Value": "'${USDOMAIN}'"
              }
            ]
          }
        },
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": "'${SUBDOMAIN}'",
            "Type": "CNAME",
            "TTL": 300,
            "SetIdentifier": "eu-central-1",
            "Region": "eu-central-1",
            "ResourceRecords": [
              {
                "Value": "'${EUROPEDOMAIN}'"
              }
            ]
          }
        }
      ]
    }'