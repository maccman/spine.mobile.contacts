Spine   = require('spine')
{Panel} = require('spine.mobile')
$       = Spine.$
Contact = require('models/contact')

class ContactsShow extends Panel
  className: 'contacts showView'
  
  constructor: ->
    super
    
    Contact.bind 'change', @render
    
    @active @change
    
    @addButton('Back', @back)    
  
  render: =>
    return unless @item
    @html require('views/contacts/show')(@item)
  
  change: (params) ->
    @item = Contact.find(params.id)
    @render()
    
  back: ->
    @navigate('/contacts', trans: 'left')    
    
class ContactsCreate extends Panel
  elements:
    'form': 'form'
  
  events:
    'submit form': 'submit'
    
  className: 'contacts createView'
  
  constructor: ->
    super
    
    @addButton('Cancel', @back)
    @addButton('Create', @submit).addClass('right')
    
    @active @render

  render: ->
    @html require('views/contacts/form')()
    
  submit: (e) ->
    e.preventDefault()
    contact = Contact.fromForm(@form)
    if contact.save()
      @navigate('/contacts', contact.id, trans: 'left')
    
  back: ->
    @navigate('/contacts', trans: 'left')
    
  deactivate: ->
    super
    @form.blur()

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
    @create  = new ContactsCreate
    
    @routes
      '/contacts/create': (params) -> @create.active(params)
      '/contacts/:id':    (params) -> @show.active(params)
      '/contacts':        (params) -> @list.active(params)
      
    Contact.fetch()
    
module.exports = Contacts