Bot = require 'slackbots'
Channel = require './channel.coffee'
User = require './user.coffee'
Commands = require "../commands/"
natural = require 'natural'

class IsaacBot extends Bot
  constructor: (settings)->
    @settings = settings
    @token = settings.token or throw new Error("need token")
    @name = settings.name or "Isaac Sirnewton"
    @log = settings.log or @_log
    @debug = settings.debug or false
    super @settings
    # setup easy to use channel and user objects
    @Channels = {}
    @Users = {}
    @Commands = {}

    # setup commands
    for commandGroup of Commands
      for command of Commands[commandGroup]
        @Commands[command] = Commands[commandGroup][command]
    @Commands["no_command"] = ->
      '''no matching command was found. check out the documentation or type: `isaac help` for a list of commands'''
    @Commands["help"] = ->
      Object.keys @

    @_registerEvents()

  _registerEvents: ->
    @on "start", @_onStart
    @on "message", @_onMessage

  _onStart: ->
    @log @channels

    for channel in @channels
      @Channels[channel.id] = new Channel(channel)
    for user in @users
      @Users[user.id] = new User(user)

  _onMessage: (message)->
    channel = @Channels[message.channel] or false
    user = @Users[message.user] or false
    @log message
    switch message.type
      when "hello"
        @log "connected."
      when "message"
        @log "#{user.name} posted a message to #{channel.name}"
        if @_talkingToMe(message) and command = @_findCommand(message)
          messageToSend = "Command: #{command}, results: #{@Commands[command](@_tokenize(message.text))}" or "Yes, #{user.name}?"
          @postMessageToChannel(channel.name, messageToSend)
      when "presence_change"
        @log "#{user.name} is now #{message.presence}"
      when "user_typing"
        @log "#{user.name} is typing.", "yep"
      else true

  _talkingToMe: (message)->
    return false if message.subtype == "bot_message" # we don't care what bots say
    @_simpleCheck(message.text, @name) or @_simpleCheck(message.text, "isaac")

  _simpleCheck: (text, search)->
    true and (text.toLowerCase().indexOf(search.toLowerCase()) + 1)

  _findCommand: (message)->
    tokens = @_tokenize(message.text)
    # array position 1 should be the command. if this is a direct message, pad the array
    if @Commands[tokens[1]]
      tokens[1]
    else if @Commands[tokens[0]]
      tokens[0]
    else
      "no_command"

  _log: (args...)->
    @debug and console.log args.join(" ")

  _smartCheck: (text, search, accuracy)->
    true # TODO: make this do something

  _isQuestion: (stringOrTokens)->
    string = if (typeof(stringOrTokens) is "string") then stringOrTokens else @_tokenize stringOrTokens

  _tokenize: (string)->
    tokenizer = new natural.WordTokenizer()
    tokenizer.tokenize string

module.exports = IsaacBot
