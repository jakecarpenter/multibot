dotenv = require 'dotenv'
bots = require './bots'
winston = require 'winston'

Isaac = new bots.IsaacBot
  name: "Isaac"
  token: "xoxb-17484547552-cb7MFN1NNM0vfJ1MbdkUax2T"
  log: winston.info
  debug: true
