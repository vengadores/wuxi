selectWrapper = ".rule_kind_select_wrapper"
mentionWrapper = ".rule_can_mention_wrapper"

$(document).on "change", selectWrapper, (e) ->
  $container = $(e.target).parents(".rule-fields")
  if e.target.value == "searchterm"
    method = "removeClass"
  else
    method = "addClass"
  $container.find(mentionWrapper)[method] "hidden"
