# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      $('#questions').append data
  })

question_ready = ->
  $('.edit-question-link').on 'click', (e)   ->
    e.preventDefault()
    $(this).hide()
    $('.edit_question').show()

$(document).ready(question_ready)
$(document).on('turbolinks:load', question_ready)