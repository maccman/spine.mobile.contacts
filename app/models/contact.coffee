Spine = require('spine')

class Contact extends Spine.Model
  @configure 'Contact', 'email', 'name'
  
  @extend @Local
  
  @nameSort: (a, b) ->
    if (a.name or a.email) > (b.name or b.email) then 1 else -1      
      
module.exports = Contact