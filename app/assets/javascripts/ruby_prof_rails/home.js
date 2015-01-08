$(function() {

  $('form').preventDoubleSubmission();
  $('form').on('submit', function(e){
    $(this).find('button').text('Processing...')
  });

  select_profiles_tab_from_url_hash();
  disable_modal_links();

});

function disable_modal_links(){
  if( !bootstrap_enabled() ){
    $("a[data-toggle='modal'").hide();
  }
}

function bootstrap_enabled(){
  return (typeof $().modal == 'function');
}

function select_profiles_tab_from_url_hash(){
  if( window.location.hash == '#profiles' ){
    $('#profiles-tab a').tab('show');
  }
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

