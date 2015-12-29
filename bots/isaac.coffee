Bot = require 'slackbots'
Channel = require './channel.coffee'
User = require './user.coffee'
Commands = "../commands"
natural = require 'natural'

class IsaacBot extends Bot
  constructor: (settings)->
    @settings = settings
    @token = settings.token or throw new Error("need token")
    @name = settings.name or "Isaac Sirnewton"
    super @settings
    # setup easy to use channel and user objects
    @Channels = @Users = @Commands = {}
    @run()


  run: ->
    @on "start", @_onStart
    @on "message", @_onMessage
    # @getChannels().then -> @getUsers().then ->


  _onStart: ->
    for channel in @channels
      @Channels[channel.id] = new Channel(channel)
    for user in @users
      @Users[user.id] = new User(user)

  _onMessage: (message)->
    channel = @Channels[message.channel] or false
    user = @Users[message.user] or false
    # console.log message
    switch message.type
      when "hello"
        console.log "connected."
      when "message"
        console.log "#{user.name} posted a message to #{channel.name}"
        @postMessageToChannel(channel.name, "Yes, #{user.name}?") if @_talkingToMe(message)
      when "presence_change"
        console.log "#{user.name} is now #{message.presence}"
      when "user_typing"
        console.log "#{user.name} is typing."
      else true

  _talkingToMe: (message)->
    @_simpleCheck(message.text, @name) or @_simpleCheck(message.text, "isaac")

  _simpleCheck: (text, search)->
    true and (text.toLowerCase().indexOf(search.toLowerCase()) + 1)

  _findCommand: (message)->
    command

  _smartCheck: (text, search, accuracy)->

  _isQuestion: (stringOrTokens)->
    string = if (typeof(stringOrTokens) is "string") then stringOrTokens else @_tokenize stringOrTokens

  _tokenize: (string)->
    tokenizer = new natural.WordTokenizer()
    tokenizer.tokenize string


module.exports = IsaacBot
