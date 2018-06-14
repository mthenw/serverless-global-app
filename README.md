# serverless-global-app

Demo application for a meetup.

## Steps

### Deploy service in two different records

```bash
sls deploy --region eu-central-1
sls deploy --region us-east-1
```

### Create API Gateway custom domain

```
npm install --save-dev serverless-domain-manager
```

serverless.yaml

```
plugins:
  - serverless-domain-manager

custom:
  customDomain:
    domainName: demo.serverlessperf.com
    endpointType: regional
    certificateRegion: ${opt:region}
    createRoute53Record: false
```

```bash
sls create_domain --region eu-central-1
sls deploy --region eu-central-1

sls create_domain --region us-east-1
sls deploy --region us-east-1
```

### Setup Route 53 Latency based routing

```bash
./scripts/setupR53.sh
```

### Create DynamoDB Global Table

```bash
aws dynamodb create-global-table \
    --global-table-name keyvalues \
    --replication-group RegionName=us-east-1 RegionName=eu-central-1 \
    --region eu-central-1
```
