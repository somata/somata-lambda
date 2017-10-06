AWS = require('aws-sdk')

class Client
    constructor: (options={}) ->
        @lambda = new AWS.Lambda options

    remote: (service, method, args..., cb) ->
        service = service.replace(':', '-')
        @lambda.invoke {
            FunctionName: service
            Payload: JSON.stringify {method, args}
        }, (err, data) ->
            if err?
                console.log '[remote] Error:', err
                cb err
            else
                # console.log '[remote] Success:', data
                cb null, JSON.parse data.Payload

module.exports = {Client}
