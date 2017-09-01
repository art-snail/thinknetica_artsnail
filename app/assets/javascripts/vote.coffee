vote = ->
  $('.vote').on('ajax:success', (e, data, status, xhr) ->
    $(this).parent().find('p.result-vote').html(xhr.responseText)
    $(this).parent().find('p.vote-errors').html('')
  ).on 'ajax:error', (e, xhr, status, error) ->
    $(this).parent().find('p.vote-errors').html(xhr.responseText)

$(document).ready(vote)
$(document).on('turbolinks:load', vote)