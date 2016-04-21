import 'jquery';

let $form,
  validator,
  $smartphoneQuestion,
  $landlineQuestion;

function toggleSecondaryQuestion () {
  var mobilePhoneState = $('input[name="select_phone_form[mobile_phone]"]:checked').val();
  if (mobilePhoneState === undefined) {
    $smartphoneQuestion.add($landlineQuestion)
      .addClass('js-hidden', true)
      .find('.selected').removeClass('selected').find('input').prop('checked',false);
  } else if (mobilePhoneState === 'true') {
    $smartphoneQuestion.removeClass('js-hidden');
    $landlineQuestion.addClass('js-hidden').removeClass('error')
      .find('.selected').removeClass('selected').find('input').prop('checked',false);
  } else if (mobilePhoneState === 'false') {
    $smartphoneQuestion.addClass('js-hidden').removeClass('error')
      .find('.selected').removeClass('selected').find('input').prop('checked',false);
    $landlineQuestion.removeClass('js-hidden');
  }
  $form.find('.form-group').removeClass('error');
  validator.resetForm();
}

export function init (){
  $form = $('#validate-phone');
  $smartphoneQuestion = $('#smartphone-question');
  $landlineQuestion = $('#landline-question');
  var errorMessage = $form.data('msg');
  if ($form.length === 1) {
    validator = $form.validate({
      rules: {
        'select_phone_form[mobile_phone]': 'required',
        'select_phone_form[smart_phone]': 'required',
        'select_phone_form[landline]': 'required'
      },
      messages: {
        'select_phone_form[mobile_phone]': errorMessage,
        'select_phone_form[smart_phone]': errorMessage,
        'select_phone_form[landline]': errorMessage
      }
    });
    $form.find('input[name="select_phone_form[mobile_phone]"]').on('click', toggleSecondaryQuestion);
    toggleSecondaryQuestion();
  }
}

