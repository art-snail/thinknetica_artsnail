# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if gon.question
    App.cable.subscriptions.create({
      channel: 'AnswersChannel',
      question_id: gon.question.id
    },{
      connected: ->
        @perform 'follow'
      ,

      received: (data) ->
        answer = JSON.parse(data)
        if !gon.current_user || (answer.user_id != gon.current_user.id)
          $('#answers').append(JST['templates/answer']({
            answer: answer
          }))
    })

answer_ready = ->
  $('body').on 'click', 'a.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

$(document).ready(answer_ready)
$(document).on('turbolinks:load', answer_ready)
