$(function() {

  form_ensure_single_submit()
  select_tab_from_url_hash();
  disable_modal_links();
  trash_dropdown_event()

});

function form_ensure_single_submit(){
  $('form').preventDoubleSubmission()
    .on('submit', function(e){
      var $button = $(this).find('button:submit');
      $button.text($button.data('onsubmit'))
    });
}

function disable_modal_links(){
  if( !bootstrap_enabled() ){
    $("a[data-toggle='modal'").hide();
  }
}

function bootstrap_enabled(){
  return (typeof $().modal == 'function');
}

function select_tab_from_url_hash(){
  $(window.location.hash + '-tab a').tab('show');
}

function trash_dropdown_event(){
  $(".trash .dropdown-menu a").on('click', function(e){
    e.preventDefault();
    var $checkboxes = $(this).closest(".table").find(":checkbox");
    $checkboxes.prop("checked", $(this).data('select'))
  })
}


// jQuery plugin to prevent double submission of forms
jQuery.fn.preventDoubleSubmission = function() {
  $(this).on('submit',function(e){
    var $form = $(this);

    if ($form.data('submitted') === true) {
      // Previously submitted - don't submit again
      e.preventDefault();
    } else {
      // Mark it so that the next submit can be ignored
      $form.data('submitted', true);
    }
  });

  // Keep chainability
  return this;
};

