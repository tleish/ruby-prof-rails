$(function() {

  $('form').preventDoubleSubmission();
  $('form').on('submit', function(e){
    $(this).find('button').text('Processing...')
  });

  if( !bootstrap_enabled() ){
    $("a[data-toggle='modal'").hide();
  }

});

function bootstrap_enabled(){
  return (typeof $().modal == 'function');
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

