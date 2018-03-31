'use strict'

const AWS = require('aws-sdk')
const dynamodb = new AWS.DynamoDB()

module.exports.get = (event, context, callback) => {
  const params = {
    Key: {
      key: {
        S: event.pathParameters.key
      }
    },
    TableName: process.env.TABLE_NAME
  }
  dynamodb.getItem(params, function(err, data) {
    if (err) {
      console.log(err, err.stack)
      callback(err)
    } else {
      callback(null, {
        statusCode: 200,
        body: JSON.stringify({
          key: data.Item.key.S,
          value: data.Item.value.S,
          save_region: data.Item.region.S,
          read_region: process.env.AWS_REGION
        })
      })
    }
  })
}

module.exports.set = (event, context, callback) => {
  const params = {
    Item: {
      key: {
        S: event.pathParameters.key
      },
      value: {
        S: event.body
      },
      region: {
        S: process.env.AWS_REGION
      }
    },
    TableName: process.env.TABLE_NAME
  }
  dynamodb.putItem(params, function(err, data) {
    if (err) {
      console.log(err, err.stack)
      callback(err)
    } else {
      callback(null, {
        statusCode: 200,
        body: JSON.stringify({
          key: params.Item.key.S,
          value: params.Item.value.S,
          save_region: params.Item.region.S
        })
      })
    }
  })
}
