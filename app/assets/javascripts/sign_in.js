(function () {
  "use strict";

  var root = this,
    $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  root.GOVUK.signin = {
    init: function () {
    },
    attach: function () {
      var $selectIdpForm = $('.idp-option');
      $selectIdpForm.on('submit', function (e) {
        var entityId;
        e.preventDefault();
        entityId = $selectIdpForm.find('button').attr('name');
        $.ajax({
          type: "PUT",
          url: '/select-idp',
          contentType: "application/json",
          processData: false,
          data: JSON.stringify({ entityId: entityId }),
          timeout: 5000
        }).done(function(response) {
          var $samlForm = $('#post-to-idp');
          $samlForm.prop('action', response.location);
          $samlForm.find('input[name=SAMLRequest]').val(response.samlRequest);
          $samlForm.find('input[name=RelayState]').val(response.relayState);
          $samlForm.find('input[name=registration]').val(response.registration);
          $samlForm.submit();
        }).fail(function() {
          $selectIdpForm.off('submit').submit();
        });
        return false;
      });
    }
  };

}).call(this);