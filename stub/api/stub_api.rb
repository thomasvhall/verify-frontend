#!/usr/bin/env ruby

require 'sinatra'

class StubApi < Sinatra::Base
  
  post '/api/session' do
    status 201
    '{
      "sessionId":"blah",
      "sessionStartTime":32503680000000,
      "transactionSimpleId":"test-rp",
      "idps":[{
        "simpleId":"stub-idp-one",
        "entityId":"http://example.com/stub-idp-one"
      }]
    }'
  end

  get '/api/session/:session_id/federation' do
    '{
      "idps":[{
        "simpleId":"stub-idp-one",
        "entityId":"http://example.com/stub-idp-one"
      }]
    }'
  end

  put '/api/session/:session_id/select-idp' do
    '{
      "encryptedEntityId":"not-blank"
    }'
  end

  get '/api/session/:session_id/idp-authn-request' do
    '{
      "location":"/test-saml",
      "samlRequest":"blah",
      "relayState":"whatever",
      "registration":true
    }'
  end

  put '/api/session/:session_id/idp-authn-response' do
    # set isRegistration to false to simulate a sign-in journey
    '{
      "idpResult":"SUCCESS",
      "isRegistration":true
    }'
  end

  get '/api/session/:session_id/matching-outcome' do
    # see response_processing_controller.rb for different outcomes that can be triggered
    '{
      "outcome":"SEND_SUCCESSFUL_MATCH_RESPONSE_TO_TRANSACTION"
    }'
  end

  get '/api/session/:session_id/response-for-rp/success' do
    '{
      "samlMessage":"saml_message",
      "relayState":"relay_state",
      "postEndpoint":"/test-saml"
    }'
  end

  get '/api/transactions' do
    '{
      "public":[{
        "simpleId":"test-rp",
        "entityId":"http://example.com/test-rp",
        "homepage":"http://example.com/test-rp"
      }],
      "private":[]
    }'
  end
end

