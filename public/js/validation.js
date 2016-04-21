import 'jquery';
import 'jquery-validation';

function placeErrorMessages($error, $element) {
  $error.addClass('validation-message form-group');
  $error.children('a')
    .attr({ href: '#' + $element.attr('id') })
    .on('click', function (e) {
      e.preventDefault();
      $element.focus();
    });
  $('#validation-error-message-js').append($error);
  $error.children('a').focus();
}

export function init () {
  $.validator.setDefaults({
    focusInvalid: false,
    errorElement: 'a',
    wrapper: 'div',
    errorPlacement: placeErrorMessages,
    highlight: function(element) {
      $(element).closest('.form-group').addClass('error');
    },
    unhighlight: function(element) {
      $(element).closest('.form-group').removeClass('error');
    },
    ignore: '.js-hidden *'
  });
}

export function attach () {
  $('.js-validate').validate();
}
