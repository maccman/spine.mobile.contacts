require('lib/setup')

$        = jQuery
Spine    = require('spine')
{Stage}  = require('spine.mobile')
Contacts = require('controllers/contacts')

class App extends Stage.Global
  constructor: ->
    super
    @contacts = new Contacts
    
    Spine.Route.setup(shim:true)
    @navigate '/contacts'
    
    $('body').bind 'click', (e) -> 
      e.preventDefault()
    
    $('body').bind 'shake', ->
      if (confirm('Reload?'))
        window.location.reload()

module.exports = App