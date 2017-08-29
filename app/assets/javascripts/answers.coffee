# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$ ->
#  $('form.new_answer').on('ajax:success', (e, data, status, xhr) ->
#    answer = $.parseJSON(xhr.responseText)
#    $('#answers').append('<p>' + answer.body + '</p>')
#  ).on 'ajax:error', (e, xhr, status, error) ->
#    errors = $.parseJSON(xhr.responseText)
#    $.each errors, (index, value) ->
#      $('.answer-errors').html(value)


answer_ready = ->
  $('body').on 'click', 'a.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

$(document).ready(answer_ready)
$(document).on('turbolinks:load', answer_ready)
