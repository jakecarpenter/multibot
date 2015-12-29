class Channel
  constructor: (slackChannelObject)->
    @raw = slackChannelObject
    @name = slackChannelObject.name


module.exports = Channel
