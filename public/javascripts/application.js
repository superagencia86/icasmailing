// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  $('#company_submit').click( submit_company );
  $('#institution_type_name').live("keypress", function(event){ if (event.keyCode == '13') {submit_institution(); event.preventDefault(); }});
  $('#institution_submit').click( submit_institution );
  $('#new_company_link').live("click", function(){ $("#company_div").toggle(); $("#company_select").toggle();} );
  $('#new_institution_link').live("click", function(){ $("#institution_div").toggle(); $("#institution_select").toggle();} );

  // Subscriber form
  value = $("#subscriber_list_contact_type_id option:selected, #contact_contact_type_id option:selected").val();
  if(value == "2"){
    $("#subscriber_subtypes").show();
  }

  $("#subscriber_list_contact_type_id, #contact_contact_type_id").change(function(){
    value = $("#subscriber_list_contact_type_id option:selected, #contact_contact_type_id option:selected").val();
    if(value == "2") {
      $("#subscriber_subtypes").show();
    } else {
      $("#subscriber_subtypes").hide();
    }
  });
  
  $("#campaign_body").wysiwyg();
});

function submit_company(e) {
  var name = $('#company_name').attr('value');
  var user_id = $('#company_user_id').attr('value');
  var f = $('#company_form').attr('value');

  $.post('/companies/create', {'company[name]': name, 'company[user_id]': user_id, 'f': f}, null, "script" ); 
	e.preventDefault;
  return false;
}
function submit_institution(e) {
  var name = $('#institution_type_name').attr('value');
  /* var user_id = $('#institution_type_user_id').attr('value'); */
  var f = $('#institution_type_form').attr('value');

  $.post('/institution_types/create', {'institution_type[name]': name, 'f': f}, null, "script" ); 
	e.preventDefault;
  return false;
}

var crm = {
  search: function(query, controller) {
    if (!this.request) {
      var list = "#" + controller;          // ex. "users"
      if (list.indexOf("/") >= 0) {   // ex. "admin/users"
        list = list.split("/")[1];
      }
      $("loading").show();
      $(list).css("opacity", "0.4");
      $.get("/" + controller + "/search", {query: query, list: list}, function(){ $(list).css("opacity", "1"); }, "script");
    }
  }
}

