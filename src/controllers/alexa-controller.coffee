AlexaError     = require '../models/alexa-error'
SessionHandler = require '../handlers/session-handler'
TypeHandler    = require '../handlers/type-handler'
debug          = require('debug')('alexa-service:controller')

class AlexaController
  constructor: ({ @timeoutSeconds, @meshbluConfig, @alexaServiceUri }) ->
    throw new Error 'Missing meshbluConfig' unless @meshbluConfig?
    throw new Error 'Missing alexaServiceUri' unless @alexaServiceUri?

  trigger: (req, res) =>
    debug 'trigger request', req.body
    sessionHandler = new SessionHandler { @timeoutSeconds, client: req.redisClient, @alexaServiceUri }
    sessionHandler.start req.body, (error, { request, response } = {}) =>
      return @handleError res, error if error?
      typeHandler = new TypeHandler {
        @meshbluConfig,
        @alexaServiceUri,
        request,
        response,
        sessionHandler,
        version: 'v1'
      }
      typeHandler.handle (error) =>
        return @handleError res, error if error?
        sessionHandler.leave response.response, (error) =>
          return @handleError res, error if error?
          res.status(200).json(response.response).send()

  handleError: (res, error) =>
    return res.status(200).json(error.response).send() if error instanceof AlexaError
    res.sendError error

  respond: (req, res) =>
    { responseId } = req.params
    sessionHandler = new SessionHandler { @timeoutSeconds, client: req.redisClient, @alexaServiceUri }
    sessionHandler.respond { responseId, body: req.body }, (error) =>
      return res.sendError error if error?
      res.status(200).send { success: true }

module.exports = AlexaController
