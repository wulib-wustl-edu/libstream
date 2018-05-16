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

$(document).on 'turbolinks:load', ->
  setTimeout (->
    $('.alert').remove()
    return
  ), 3000
  return

jwplayer.key = 'UsAbh+H0EIus1QAay94tDANQsnbPuE3wRYonzXdAwok='

$(document).on 'turbolinks:load', ->
  'use strict'
  # Change this to the location of your server-side upload handler:
  url = if window.location.hostname == 'localhost:3000' then '//jquery-file-upload.appspot.com/' else '/resources'
  uploadButton = $('<button/>').addClass('btn btn-primary').prop('disabled', true).text('Processing...').on('click', ->
    $this = $(this)
    data = $this.data()
    $this.off('click').text('Abort').on 'click', ->
      $this.remove()
      data.abort()
      return
    data.submit().always ->
      $this.remove()
      return
    return
  )
  $('#fileupload').fileupload(
    url: url
    dataType: 'json'
    paramName: 'resource[video]'
    autoUpload: false
    acceptFileTypes: /(\.|\/)(mp4)$/i
    maxChunkSize: 100000000
    disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent)
    previewMaxWidth: 100
    previewMaxHeight: 100
    previewCrop: true).on('fileuploadadd', (e, data) ->
    data.context = $('<div/>').appendTo('#files')
    $.each data.files, (index, file) ->
      node = $('<p/>').append($('<span/>').text(file.name))
      if !index
        node.append('<br>').append uploadButton.clone(true).data(data)
      node.appendTo data.context
      return
    return
  ).on('fileuploadprocessalways', (e, data) ->
    index = data.index
    file = data.files[index]
    node = $(data.context.children()[index])
    if file.preview
      node.prepend('<br>').prepend file.preview
    if file.error
      node.append('<br>').append $('<span class="text-danger"/>').text(file.error)
    if index + 1 == data.files.length
      data.context.find('button').text('Upload').prop 'disabled', ! !data.files.error
    return
  ).on('fileuploadprogressall', (e, data) ->
    progress = parseInt(data.loaded / data.total * 100, 10)
    $('#progress .progress-bar').css 'width', progress + '%'
    return
  ).on('fileuploaddone', (e, data) ->
    $.each data.result.files, (index, file) ->
      if file.url
        link = $('<a>').attr('target', '_blank').prop('href', file.url)
        $(data.context.children()[index]).wrap link
      else if file.error
        error = $('<span class="text-danger"/>').text(file.error)
        $(data.context.children()[index]).append('<br>').append error
      return
    return
  ).on('fileuploadfail', (e, data) ->
    $.each data.files, (index) ->
      error = $('<span class="text-danger"/>').text('File upload failed.')
      $(data.context.children()[index]).append('<br>').append error
      return
    return
  ).prop('disabled', !$.support.fileInput).parent().addClass if $.support.fileInput then undefined else 'disabled'
  return


