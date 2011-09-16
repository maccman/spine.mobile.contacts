Spine = require('spine')
$     = require('jqueryify')

class Contact extends Spine.Model
  @configure 'Contact', 'email', 'name', 'twitter', 'headline', 'location', 'organization', 'avatar'
  @endpoint: 'http://rap-proxy.herokuapp.com/contacts/email'
  
  @extend Spine.Model.Local
  
  @nameSort: (a, b) ->
    if (a.name or a.email) > (b.name or b.email) then 1 else -1
    
  fetchRemote: ->
    $.getJSON([@constructor.endpoint, @email].join('/')).success (data) =>
      data          = data.contact
      @name         = data.name
      @twitter      = data.twitter_username
      @headline     = data.headline
      @location     = data.location
      @organization = data.organisation
      @avatar       = data.image_url_proxied
      @save()
      
  validate: ->
    'Email required' unless @email
    
  @bind 'create', (rec) -> rec.fetchRemote()
      
module.exports = Contact