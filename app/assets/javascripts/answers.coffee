# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#ready = ->
#  $('.edit-answer-link').click (e) ->
##    alert 'click'
#    e.preventDefault()
#    $(this).hide()
#    answer_id = $(this).data('answerId')
#    $('form#edit-answer-' + answer_id).show()
##    alert answer_id
#
#$(document).ready(ready)
##$(document).on "turbolinks:load", ready()
##$(document).on('turbolinks', ready)
#$(document).on "turbolinks:load", ready
#$(document).on 'page:update', ready
#$(document).on('page:load', ready)

$ ->
  $('body').on 'click', 'a.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('body').on 'click', '#test', (e) ->
#    alert 'click'
    e.preventDefault()
    $(this).hide()