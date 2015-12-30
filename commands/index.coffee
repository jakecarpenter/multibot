# These commands provide simple functionality to the bot.
# each command takes the data recieved and processes it directly.
time = require './time'
joke = require './joke'
meetings = require './meetings'
procedures = require './procedures'
weather = require './weather'

module.exports =
  time: new time()
  joke: new joke()
  meetings: new meetings()
  procedures: new procedures()
  weather: new weather()
