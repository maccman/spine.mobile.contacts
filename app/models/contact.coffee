Spine = require('spine')
$     = require('jqueryify')

class Contact extends Spine.Model
  @configure 'Contact', 'email', 'name', 'twitter', 'headline', 'location', 'organization'
  @endpoint: 'https://profiles.rapportive.com/contacts/email'
  
  @extend Spine.Model.Local
  
  fetchRemote: ->
    $.getJSON([@constructor.endpoint, @email].join('/')).success (data) =>
      data          = data.contact
      @name         = data.name
      @twitter      = data.twitter_username
      @headline     = data.headline
      @location     = data.location
      @organization = data.organisation
      @save()
      
module.exports = Contact