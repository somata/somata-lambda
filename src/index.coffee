AWS = require 'aws-sdk'
Promise = require 'bluebird'

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
                cb err
            else
                cb null, JSON.parse data.Payload

    remotePromise: (service, method, args...) ->
        Promise.fromCallback @remote.bind(@, service, method, args...)

Service = (name, methods={}) ->
    (event, context, cb) ->
        {method, args} = event
        args ||= []
        methods[method](args..., cb)

module.exports = {Client, Service}
