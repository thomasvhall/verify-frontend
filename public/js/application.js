import 'jquery';
import 'govuk_frontend_toolkit/javascripts/govuk/selection-buttons';

import * as validation from './validation';
import * as selectDocuments from './select_documents';
import * as selectPhone from './select_phone';
import * as willItWorkForMe from './will_it_work_for_me';
import * as chooseACertifiedCompany from './choose_a_certified_company';
import * as dialog from './dialog';
import * as signin from './sign_in';

validation.init();
selectDocuments.init();
selectPhone.init();
willItWorkForMe.init();
chooseACertifiedCompany.init();
dialog.init();

$(function () {
  // Use GOV.UK selection-buttons.js to set selected and focused states for block labels
  var $blockLabelInput = $(".block-label").find("input[type='radio'],input[type='checkbox']");
  new GOVUK.SelectionButtons($blockLabelInput);

  validation.attach();
  signin.attach();
});
