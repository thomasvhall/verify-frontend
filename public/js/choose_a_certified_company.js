import 'jquery';

export function init () {
  var $nonMatchingIdps = $('#non-matching-idps'),
    $warning = $('#non-matching-idps-warning'),
    $showCompanies = $warning.find('a');

  $showCompanies.on('click', function(event) {
    event.preventDefault();
    $warning.addClass('hidden').removeClass('js-show');
    $nonMatchingIdps.removeClass('js-hidden');
  });
}
