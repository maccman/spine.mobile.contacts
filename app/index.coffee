require('lib/setup')

Spine    = require('spine')
Stage    = require('controllers/stage')
Contacts = require('controllers/contacts')

class App extends Stage.Global
  constructor: ->
    super
    @contacts = new Contacts
    @navigate '/contacts'

module.exports = App