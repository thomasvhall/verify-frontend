import 'jquery'

export function attach () {
  var $container = $('.js-idp-option-container')
  $container.on('submit', '.idp-option', function (e) {
    var entityId, displayName;
    var $originalForm = $(e.target);
    e.preventDefault();
    var selectIdpButton = $originalForm.find('button');
    entityId = selectIdpButton.attr('name');
    displayName = selectIdpButton.attr('value');
    $.ajax({
      type: 'PUT',
      url: '/select-idp',
      contentType: "application/json",
      processData: false,
      data: JSON.stringify({ entityId: entityId, displayName: displayName }),
      timeout: 5000
    }).done(function(response) {
      var $samlForm;
      if (!response.location) {
        throw Error('Expected response to contain location');
      }
      $samlForm = $('#post-to-idp');
      $samlForm.prop('action', response.location);
      $samlForm.find('input[name=SAMLRequest]').val(response.saml_request);
      $samlForm.find('input[name=RelayState]').val(response.relay_state);
      $samlForm.find('input[name=registration]').val(response.registration);
      $samlForm.submit();
    }).fail(function() {
      $container.off('submit');
      $originalForm.submit();
    });
    return false;
  });
}
