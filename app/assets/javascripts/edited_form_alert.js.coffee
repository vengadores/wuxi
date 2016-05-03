formHasChanged = null

$(document).on "page:change", ->
  formHasChanged = false

$(document).on "change", "form input", ->
  formHasChanged = true

$(document).on "click", ".cancel-button", (e) ->
  return true unless formHasChanged
  window.confirm "¿Estás seguro?"
