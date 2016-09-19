# Alexa Service

[![Build Status](https://travis-ci.org/octoblu/alexa-service.svg?branch=master)](https://travis-ci.org/octoblu/alexa-service)
[![Test Coverage](https://codecov.io/gh/octoblu/alexa-service/branch/master/graph/badge.svg)](https://codecov.io/gh/octoblu/alexa-service)
[![Dependency status](http://img.shields.io/david/octoblu/alexa-service.svg?style=flat)](https://david-dm.org/octoblu/alexa-service)
[![devDependency Status](http://img.shields.io/david/dev/octoblu/alexa-service.svg?style=flat)](https://david-dm.org/octoblu/alexa-service#info=devDependencies)
[![Slack Status](http://community-slack.octoblu.com/badge.svg)](http://community-slack.octoblu.com)

[![NPM](https://nodei.co/npm/alexa-service.svg?style=flat)](https://npmjs.org/package/alexa-service)

# Table of Contents

* [Introduction](#introduction)
* [Getting Started](#getting-started)
  * [Install](#install)
* [Creating Custom Skill](#creating-custom-skill)
* [Octoblu Usage](#octoblu-usage)
  * [Flows](#flows)
  * [Custom Flows](#custom-flows)

# Introduction

The Alexa Service, is a micro-service that allows [Octoblu](https://www.octoblu.com) to react and respond to requests from the [Amazon Echo](https://echo.amazon.com) device, or an Alexa App.

Octoblu hosts an instance of the Alexa Service at [alexa.octoblu.com](https://alexa.octoblu.com) and is available for public use.

# Getting Started

## Install

The Alexa Service can be used by cloning from github

```shell
cd /path/to/project_dir
git clone https://github.com/octoblu/alexa-service.git
cd alexa-service
npm install
npm start
```

Or by using docker. Replace tag with latest and if needed, change the exposed port.

```shell
docker pull quay.io/octoblu/alexa-service:v4.3.5
docker run alexa-service:v4.3.5 -p 5000:80
```

# Creating Custom Skill

1. Create Amazon Developer Account
1. See the [Getting Started Guide](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/getting-started-guide) by Amazon
1. Add a new skill on the [skill list](https://developer.amazon.com/edw/home.html#/skills/list) page.
1. **Skill Information**
  1. Select "Custom Interaction Model"
  1. Set your Skill Name
  1. Set the Invocation Name
1. **Interaction Model**
  1. Set the Intent Schema to:
```json
{
  "intents": [
    {
      "intent": "Trigger",
      "slots": [
        {
          "name": "Name",
          "type": "TRIGGER"
        }
      ]
    },
    {
      "intent": "ListTriggers"
    },
    {
      "intent": "AMAZON.HelpIntent"
    },
    {
      "intent": "AMAZON.StopIntent"
    },
    {
      "intent": "AMAZON.CancelIntent"
    }
  ]
}
```
  1. Create a Custom Slot with a type of "TRIGGER" and the values will be the name of the tasks you want to run. The values should be the same of the "echo-in" node name in your flow (these are currently case sensitive. Also be aware that the Amazon Alexa service may change chase. IE, it was noticed that "ipad" became "iPad", this is easily checked by reading the JSON data).
  1. Add the following generic Sample Utterances
```txt
Trigger give me the {Name}
Trigger give me {Name}
Trigger give me a {Name}
Trigger get me the {Name}
Trigger get me {Name}
Trigger get me a {Name}
Trigger could you set {Name}
Trigger could you please set {Name}
Trigger i need {Name}
Trigger i need {Name} please
Trigger tell me my {Name}
Trigger list {Name}
Trigger i want {Name}
Trigger create {Name}
Trigger create a {Name}
ListTriggers what my triggers are
ListTriggers give me a list of my triggers
ListTriggers get me a list of my triggers
ListTriggers a list of my triggers
ListTriggers my triggers
ListTriggers the triggers i have
ListTriggers what triggers do i have
```
1. **Configuration**
  1. Set the Endpoint to HTTPS and `https://alexa.octoblu.com/trigger` or the url of your hosted Alexa Service.
  1. Set Account Linking to "Yes"
  1. Set the Authorization URL to `https://oauth.octoblu.com/alexa/authorize`
  1. Create a Oauth Device / Application in Octoblu
    1. Go to your [all things](https://app.octoblu.com/things/all) page.
    1. Select and create a new Oauth Device
    1. Add a name to the Oauth Device
    1. Set the callbackUrl to the Redirect URL listed on the Configuration Page in your Alexa Skill.
    1. The Oauth device creating in Octoblu should be discoverable by everyone. This can be set on the permissions tab.
    1. The UUID and Token will of the device will be needed for the Alexa Skill. You can get the Token by generating a new one in the device configuration page in octoblu.
  1. The Skill Client ID will be the UUID of the Oauth device you created.
  1. The Following need to be added to the domain list
    - twitter.com
    - facebook.com
    - google.com
    - citrixonline.com
    - github.com
    - octoblu.com
  1. No scope needs to be set
  1. Set the Authorization Grant Type to "Auth Code Grant"
  1. Set the Access Token URI to "https://oauth.octoblu.com/access_token"
  1. Set the Client Secret to the Token of the Oauth Device
  1. Set the Client Authentication Scheme to "HTTP Basic"
  1. Set the terms to "https://app.octoblu.com/terms" or your own terms.
1. **SSL Certificate**
  1. Select the option, "My development endpoint has a certificate from a trusted certificate authority"
    - If you are hosting your own Alexa Service you may have different requirements for the SSL configuration.
1. **Publishing Information** (If testing this section is optional)
  1. This information is specific to your skill
1. **Privacy & Compliance** (If testing this section is optional)
  1. This information is specific to your skill

If you are getting unauthorized, disable and re-enable your skill, by going to http://alexa.amazon.com/spa/index.html#skills/your-skills and clicking on "link". This should open up another tab, authenticating you with Octoblu.

# Octoblu Usage

## Flows

* [Alexa Create GoToMeeting](https://app.octoblu.com/bluprints/import/297744cf-36d8-473b-b78a-245913c35986)
* [Alexa List GoToMeeting](https://app.octoblu.com/bluprints/import/84aca1ae-a9dd-4268-870c-582a40e2a8f9)
* [Alexa Podio Notifications](https://app.octoblu.com/bluprints/import/0554ffc9-f829-49d0-b9a8-9c4eeff5c9da)
* [Alexa Podio Tasks](https://app.octoblu.com/bluprints/import/7c4c73e8-e7f8-4d70-a5ad-508483343d9b)
* [Alexa Weather](https://app.octoblu.com/bluprints/import/8a262834-f140-43f1-9060-3c564f94eaff)

## Custom Flows
1. Import the base [Alexa Flow](https://app.octoblu.com/bluprints/import/9a6b516c-5f55-4676-bbf5-657612fb35e7)
1. An "Echo In" node in the [Octoblu Designer](https://app.octoblu.com) receives input into a flow from the Alexa Service. The name of the "Echo In" node should match a value in the Trigger custom slot configuration (this is no longer case-sensitive). When a Alexa Request is received, you will get a callbackUrl in the message and other information about the request.
1. An "Echo Out" allows you to respond to the Alexa request. You will need to use the callbackUrl from "Echo In" node. The value should be `{{msg.callbackUrl}}`. 
  - You can optionally set the response text.
  - The latest version allows you to respond to an echo-out node with a "response" object. The response object will be passed along to the alexa response. This gives you full access to the Alexa response object.
1. For every echo-in request, a response needs to be sent through the echo-out node.
1. The flow must be deployed and online.
