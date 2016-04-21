import 'jquery';
import 'jquery-validation';

let $form;

function markAllAsNo () {
  // Mark all documents as 'No' when "I don't have documents" is selected
  var $checkbox = $(this);
  var checkboxValue = $checkbox.val();
  var $noAnswers = $form.find('input[type=radio][value=false]');

  if (checkboxValue === "true") {
    $noAnswers.trigger('click');
  }
}

function unCheckNoDocuments () {
  // Un check "I don't have documents" if the user selects a document
  var $checkbox = $form.find('.js-no-docs:checked');
  $checkbox.prop('checked',false);
  $checkbox.parent('.block-label').removeClass('selected');
}

export function init (){
  $form = $('#validate-documents');

  if ($form.length === 1) {
    $form.find('.js-no-docs').on('click',markAllAsNo);
    $form.find('input[type=radio][value=true]').on('click',unCheckNoDocuments);

    $.validator.addMethod('selectDocumentsValidation', function(value, element) {
      var numberOfDocumentQuestions = 3;
      var checkedElements = $form.find('input[type=radio]').filter(':checked');
      var allDocumentQuestionsAnswered = checkedElements.length === numberOfDocumentQuestions;
      var hasAtLeastOneDocument = checkedElements.filter('[value=true]').length > 0;
      return allDocumentQuestionsAnswered || hasAtLeastOneDocument;
    }, $.validator.format($form.data('msg')));

    $form.validate({
      rules: {
        'select_documents_form[driving_licence]': 'selectDocumentsValidation',
        'select_documents_form[passport]': 'selectDocumentsValidation',
        'select_documents_form[non_uk_id_document]': 'selectDocumentsValidation',
        'select_documents_form[no_documents]': 'selectDocumentsValidation'
      },
      groups: {
        // driving_licence is the first element, error should focus this
        driving_licence: 'select_documents_form[driving_licence] select_documents_form[passport] select_documents_form[non_uk_id_document] select_documents_form[no_documents]'
      },
      highlight: function(element, errorClass) {
        $form.children('.form-group:first').addClass('error');
      },
      unhighlight: function(element, errorClass) {
        $form.children('.form-group:first').removeClass('error');
      }
    });
  }
}
