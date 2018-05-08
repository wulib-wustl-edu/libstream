# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('.checkAll').on 'click', ->
    $(this).closest('table').find('tbody :checkbox').prop('checked', @checked).closest('tr').toggleClass 'selected', @checked
    return
  $('tbody :checkbox').on 'click', ->
    $(this).closest('tr').toggleClass 'selected', @checked
    $(this).closest('table').find('.checkAll').prop 'checked', $(this).closest('table').find('tbody :checkbox:checked').length == $(this).closest('table').find('tbody :checkbox').length
    return
  return