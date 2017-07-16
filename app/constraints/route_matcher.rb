module RouteMatcher
  AbTestCookieMatchesExperiment = -> (experiment_details, request) {
    experiment_name = experiment_details[:experiment_name]
    alternative = experiment_details[:alternative]

    experiment_group = "#{experiment_name}_#{alternative}"

    experiment_name_in_cookie = Cookies.parse_json(request.cookies[CookieNames::AB_TEST])[experiment_name]
    request_experiment_group = AB_TESTS[experiment_name] ? AB_TESTS[experiment_name].alternative_name(experiment_name_in_cookie) : 'default'

    experiment_group == request_experiment_group
  }

  AbTestMatchesRelyingParty = -> (experiment_details, request) {
    experiment_name = experiment_details[:experiment_name]
    alternative = experiment_details[:alternative]

    request_experiment_rp = AB_TESTS[experiment_name] ? AB_TESTS[experiment_name].rp_include(alternative) : 'default'

    request_experiment_rp.include? request.session[:transaction_simple_id]
  }

  ReportToPiwik = -> (experiment_name, request) {
    reported_alternative = Cookies.parse_json(request.cookies[CookieNames::AB_TEST])[experiment_name]
    transaction_id = request.session[:transaction_simple_id]
    AbTest.report(experiment_name, reported_alternative, transaction_id, request)
  }

  relying_party_matches = AbTestMatchesRelyingParty.curry.(experiment_name: 'proof_of_address', alternative: 'variant')
  relying_party_does_not_match = -> (request) { !relying_party_matches.call(request) }

  ProofOfAddressA = -> (request) {
    control_group = AbTestCookieMatchesExperiment.curry.(experiment_name: 'proof_of_address', alternative: 'control')
    # control_group.call(request) || (variantGroup.call(request) && relyingPartyDoesNotMatch.call(request))
    control_group.call(request) || relying_party_does_not_match.call(request)
  }

  ProofOfAddressB = -> (request) {
    variant_group = AbTestCookieMatchesExperiment.curry.(experiment_name: 'proof_of_address', alternative: 'variant')
    variant_group.call(request) && relying_party_matches.call(request)
  }
end
