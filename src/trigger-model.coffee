_ = require 'lodash'
request = require 'request'

class TriggerModel
  parseTriggersFromDevices: (devices) =>
    triggers = []

    return triggers unless devices?

    _.each devices, (device) => triggers = _.union triggers, @collectTriggersFromDevice(device)

    return triggers

  collectTriggersFromDevice: (device) =>
    triggersInFlow = _.filter device.flow?.nodes, type: 'operation:trigger'

    return _.map triggersInFlow, (trigger) =>
      name: trigger.name
      flowId: device.uuid
      flowName: device.name ? ''
      id: trigger.id
      uri: "https://triggers.octoblu.com/flows/#{device.uuid}/triggers/#{trigger.id}"


module.exports = TriggerModel
