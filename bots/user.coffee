class User
  constructor: (slackUserObject)->
    @raw = slackUserObject
    @name = slackUserObject.name


module.exports = User
