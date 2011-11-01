require('lib/setup')

Spine    = require('spine')
$        = Spine.$
{Stage}  = require('spine.mobile')
Contacts = require('controllers/contacts')

class App extends Stage.Global
  constructor: ->
    super
    @contacts = new Contacts
    
    Spine.Route.setup(shim:true)
    @navigate '/contacts'

module.exports = App