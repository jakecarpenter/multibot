appId = "07c48270396b22ed7f5f088998c14e08" # TODO: env
class Weather
  temp: (command)->
    console.log command
    "50"
  humidity: ->
    "wet"


module.exports = Weather
