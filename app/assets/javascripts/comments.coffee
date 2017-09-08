# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if gon.question
    App.cable.subscriptions.create({
      channel: 'CommentsChannel',
      id: gon.question.id
    }, {
      connected: ->
        @perform 'follow'
      ,

      received: (data) ->
        comment = JSON.parse(data)
        if !gon.current_user || (comment.user_id != gon.current_user.id)
          $('.comments').after(JST['templates/comment']({
            comment: comment
          }))
    })
