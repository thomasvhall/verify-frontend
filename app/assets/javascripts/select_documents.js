(function(global) {
  "use strict"
  var GOVUK = global.GOVUK || {};
  var $ = global.jQuery;

  var selectDocuments = {
    init: function (){
      selectDocuments.$form = $('#validate-documents');

      if (selectDocuments.$form.length === 1) {

        $.validator.addMethod('selectDocumentsValidation', function(value, element) {
          var numberOfDocumentQuestions = 3;
          var checkedElements = selectDocuments.$form.find('input[type=radio]').filter(':checked');
          var allDocumentQuestionsAnswered = checkedElements.length === numberOfDocumentQuestions;
          var hasAtLeastOneDocument = checkedElements.filter('[value=true]').length > 0;
          return allDocumentQuestionsAnswered || hasAtLeastOneDocument;
        }, $.validator.format(selectDocuments.$form.data('msg')));

        selectDocuments.$form.validate($.extend({}, GOVUK.validation.radiosValidation, {
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
            selectDocuments.$form.children('.form-group:first').addClass('error');
          },
          unhighlight: function(element, errorClass) {
            selectDocuments.$form.children('.form-group:first').removeClass('error');
          }
        }));
      }
    }
  };

  GOVUK.selectDocuments = selectDocuments;

  global.GOVUK = GOVUK;
})(window);
