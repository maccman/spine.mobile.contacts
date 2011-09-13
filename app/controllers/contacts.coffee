Spine   = require('spine')
Panel   = require('controllers/panel')
$       = Spine.$
Contact = require('models/contact')

class ContactsShow extends Panel
  className: 'contacts showView'
  
  constructor: ->
    super
    
    @active (params) -> 
      @change(params.id)
      
    @addButton('Cancel', @back)
  
  render: ->
    @html require('views/contacts/show')(@item)
  
  change: (id) ->
    @item = Contact.find(id)
    @render()
    
  back: ->
    @navigate('/contacts', trans: 'left')
    
class ContactsCreate extends Panel
  events:
    'submit form': 'submit'
    
  className: 'contacts createView'
  
  constructor: ->
    super
    
    @addButton('Cancel', @back)

  render: ->
    @html 'create'
    
  submit: (e) ->
    e.preventDefault()
    
  back: ->
    @navigate('/contacts', trans: 'left')

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
    'tap button.add': 'add'
    
  className: 'contacts list listView'
  
  constructor: ->
    super
    
    Contact.bind('refresh change', @render)
    @header.append($('<button />').addClass('add').text('Add Contact'))
    
  render: =>
    items = Contact.all()
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
    
module.exports = Contacts