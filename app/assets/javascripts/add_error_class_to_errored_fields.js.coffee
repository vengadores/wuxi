$(document).on "ready", ->
  $(".field_with_errors").each (i, field) ->
    # apply .error class (styled by semantic)
    # to wrapper
    # and pull input & label out of .field_with_errors
    # wrapper as it'll mess up semantic styles
    $field = $(field)
    $field.parent()
          .addClass("error")
          .append $field.html()
    $field.remove()
