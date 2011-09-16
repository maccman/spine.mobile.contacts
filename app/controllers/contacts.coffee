Spine   = require('spine')
{Panel} = require('spine.mobile')
$       = Spine.$
Contact = require('models/contact')

class ContactsShow extends Panel
  className: 'contacts showView'
  
  constructor: ->
    super
    
    Contact.bind('change', @render)
    
    @active (params) -> 
      @change(params.id)
      
    @addButton('Back', @back)    
  
  render: =>
    return unless @item
    @html require('views/contacts/show')(@item)
  
  change: (id) ->
    @item = Contact.find(id)
    @render()
    
  back: ->
    @navigate('/contacts', trans: 'left')    
    
class ContactsCreate extends Panel
  elements:
    'input': 'input'
  
  events:
    'submit form': 'submit'
    
  className: 'contacts createView'
  
  constructor: ->
    super
    
    @addButton('Cancel', @back)
    @addButton('Create', @submit).addClass('right')
    
    @render()

  render: ->
    @html require('views/contacts/form')()
    
  submit: (e) ->
    e.preventDefault()
    contact = Contact.create(email: @input.val())
    if contact
      @input.val('')
      @navigate('/contacts', contact.id, trans: 'left')
    
  back: ->
    @navigate('/contacts', trans: 'left')
    
  deactivate: ->
    super
    @input.blur()

class ContactsUpdate extends Panel    
  className: 'contacts updateView'
  
  constructor: ->
    super
    
    @active (params) -> 
      @change(params.id)
      
    @addButton('Cancel', @back)

  render: ->
    @html 'update'

  change: (id) ->
    @item = Contact.find(id)
    @render()
    
  back: ->
    @navigate('/contacts', trans: 'left')

class ContactsList extends Panel
  events:
    'tap .item': 'click'
  
  title: 'Contacts'
    
  className: 'contacts list listView'
  
  constructor: ->
    super
    
    Contact.bind('refresh change', @render)
    @addButton('Add', @add).addClass('right')
    
  render: =>
    items = Contact.all().sort(Contact.nameSort)
    @html require('views/contacts/item')(items)
    
  click: (e) ->
    item = $(e.target).item()
    @navigate('/contacts', item.id, trans: 'right')
    
  add: ->
    @navigate('/contacts/create', trans: 'right')

    
class Contacts extends Spine.Controller
  constructor: -> 
    super
    
    @list    = new ContactsList
    @show    = new ContactsShow
    @update  = new ContactsUpdate
    @create  = new ContactsCreate
    
    @routes
      '/contacts': (params) -> @list.active(params)
      '/contacts/:id/update': (params) -> @update.active(params)
      '/contacts/:id': (params) -> @show.active(params)
      '/contacts/create': (params) -> @create.active(params)
      
    Contact.fetch()
    
module.exports = Contacts