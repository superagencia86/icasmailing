(function($) {

  if (typeof console == "undefined" || typeof console.log == "undefined") {
    console = {
      log : function() {},
      debug : function() {}
    };
  }

  function submit_company(e) {
    var name = $('#company_name').attr('value');
    var user_id = $('#company_user_id').attr('value');
    var f = $('#company_form').attr('value');

    $.post('/empresas', {
      'company[name]': name,
      'company[user_id]': user_id,
      'f': f
    }, null, "script" );
    e.preventDefault();
    return false;
  }

  function submit_institution(e) {
    var name = $('#institution_type_name').attr('value');
    /* var user_id = $('#institution_type_user_id').attr('value'); */
    var f = $('#institution_type_form').attr('value');

    $.post('/instituciones', {
      'institution_type[name]': name,
      'f': f
    }, null, "script" );
    e.preventDefault();
    return false;
  }




  $(document).ready(function() {
    $('#company_submit').click( submit_company );
    $('#institution_type_name').live("keypress", function(event){
      if (event.keyCode == '13') {
        submit_institution();
        event.preventDefault();
      }
    });
    $('#institution_submit').click( submit_institution );
    $('#new_company_link').live("click", function(){
      $("#company_div").toggle();
      $("#company_select").toggle();
    } );
    $('#new_institution_link').live("click", function(){
      $("#institution_div").toggle();
      $("#institution_select").toggle();
    } );

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

    // Institutions
    $("#subscriber_list_all_institutions, #subscriber_list_all_general").click(function(){
      var checked = $(this).is(":checked") ? true : false;
      var elem = $(this).attr("id") == "subscriber_list_all_general" ? ".hobby_checkbox" : ".institution_type_checkbox"
      $(elem).attr("checked", checked);
    });

    $(".institution_type_checkbox").click(function(){
      if($(this).is(":checked")){
        if($(".institution_type_checkbox").not(":checked").length == 0){
          $("#subscriber_list_all_institutions").attr("checked", true);
        }
      }else{
        $("#subscriber_list_all_institutions").attr("checked", false);
      }
    });
    $(".hobby_checkbox").click(function(){
      if($(this).is(":checked")){
        if($(".hobby_checkbox").not(":checked").length == 0){
          $("#subscriber_list_all_general").attr("checked", true);
        }
      }else{
        $("#subscriber_list_all_general").attr("checked", false);
      }
    });

    // Subscriber list contact listing
    $("#contact_filters #filter_contact_type:select").change(function(){
      if($(this).val() == '1'){
        $(".filters #general").show();
        $(".filters #institution").hide();
        $("#filter_contact_type_institution_type").val("");
      }else if($(this).val() == '4'){
        $(".filters #general").hide();
        $(".filters #institution").show();
        $("#filter_contact_type_hobby").val("");
      }else{
        $(".filters #general").hide();
        $(".filters #institution").hide();
        $("#filter_contact_type_institution_type").val("");
        $("#filter_contact_type_hobby").val("");
      }
    });

    if((elem = $("#contact_filters #filter_contact_type:select")).length){
      if(elem.val() == '1'){
        $(".filters #general").show();
      }else if(elem.val() == '4'){
        $(".filters #institution").show();
      }
    }

    $(".share_list_link").click(function(e){
      var form = $(this).nextAll('form');
      form.toggle();
      e.preventDefault();
    });

    // Contact form hide contact type
    $(".contact_type_select_radio").click(function(){
      if($(this).val() == '1'){
        $("#hobbies").show();
        $("#institution_types").hide();
      }else if($(this).val() == '4'){
        $("#hobbies").hide();
        $("#institution_types").show();
      }else{
        $("#hobbies").hide();
        $("#institution_types").hide();
      }
    });

    if($(".contact_type_select_radio:checked").length){
      var elem = $(".contact_type_select_radio:checked");
      if(elem.val() == '1'){
        $("#hobbies").show();
        $("#institution_types").hide();
      }else if(elem.val() == '4'){
        $("#hobbies").hide();
        $("#institution_types").show();
      }
    }

    // Seleccionar o deseleccionar todos los usuarios
    // URL: /campañas/XX/selection
    $("#select_all_contacts").click(function(e) {
      $("form input[type=checkbox]:enabled").attr('checked', true);
      showSelectCountContacts();
      e.stopPropagation();
    });
    $("#select_none_contacts").click(function(e) {
      $("form input[type=checkbox]:enabled").attr('checked', false);
      showSelectCountContacts();
      e.stopPropagation();
    });

    if ($("#select_count_contacts").length) {
      $("form input[type=checkbox]").click(function() {
        showSelectCountContacts();
      });
      showSelectCountContacts();
    }

    // GESTIÓN  DE ROLES DE USUARIO
    $("form.roles input[type=checkbox]").click(function(e) {
      var url = $(this).parent("form.roles").attr('action');
      var data = {};
      data['rol'] = $(this).attr('name');
      data['value'] = $(this).attr('checked');
      data['_method'] = "put";
      data['authenticity_token'] = $("meta[name=csrf-token]").attr('content');
      $.post(url + ".js", data, function(response) {
        console.log(response);
      });
      e.stopPropagation();
    });
  }); // JQUERY document.load

  function showSelectCountContacts() {
    var size = $("form input[type=checkbox]:checked").length;
    $("#select_count_contacts").html("" + size + " contactos seleccionados.");
  }

})(jQuery);

var crm = {
  search: function(query, search_path) {
    if (!this.request) {
      $("#paginate").hide();
      $("loading").show();
      $(".search").css("opacity", "0.4");
      $.get(search_path, {
        query: query
      }, function(){
        $(".search").css("opacity", "1");
      }, "script");
    }
  }
}