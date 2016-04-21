import 'jquery';

let $form,
  $notResidentReasonSection,
  validator;

export function init () {
    $form = $('#validate-will-it-work-for-me');
    $notResidentReasonSection = $('#not_resident_reason');
    var errorMessage = $form.data('msg');
    if ($form.length === 1) {
        validator = $form.validate({
            rules: {
                'will_it_work_for_me_form[above_age_threshold]': 'required',
                'will_it_work_for_me_form[resident_last_12_months]': 'required',
                'will_it_work_for_me_form[not_resident_reason]': {
                    required: '#will_it_work_for_me_form_resident_last_12_months_false:checked'
                }
            },
            groups: {
                primary: 'will_it_work_for_me_form[above_age_threshold] will_it_work_for_me_form[resident_last_12_months] will_it_work_for_me_form[not_resident_reason]'
            },
            messages: {
                'will_it_work_for_me_form[above_age_threshold]': errorMessage,
                'will_it_work_for_me_form[resident_last_12_months]': errorMessage,
                'will_it_work_for_me_form[not_resident_reason]': errorMessage
            }
        });
        setNotResidentReasonSectionVisibility();
        $form.find('input[name="will_it_work_for_me_form[resident_last_12_months]"]').on('click', setNotResidentReasonSectionVisibility);
    }
}

function setNotResidentReasonSectionVisibility () {
    if (notLivedInTheUKFor12Months()) {
        $notResidentReasonSection.removeClass('js-hidden');
    } else {
        // re-validate the "which of these applies to you" section - if we don't do this, the "Please answer all questions"
        // message remains for the section even if it's hidden by the user selecting "Yes" to "Have you lived in the UK for the last 12 months?"
        validator.element('#will_it_work_for_me_form_not_resident_reason_movedrecently');
        $notResidentReasonSection.addClass('js-hidden').removeClass('error')
            .find('.selected').removeClass('selected').find('input').prop('checked', false);
    }
}

function notLivedInTheUKFor12Months () {
    var input = $('input[name="will_it_work_for_me_form[resident_last_12_months]"]:checked');
    return input.length === 1 && input.val() === 'false';
}
