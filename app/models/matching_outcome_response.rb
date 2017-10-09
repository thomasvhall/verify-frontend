class MatchingOutcomeResponse < Api::Response
  GOTO_HUB_LANDING_PAGE = 'GOTO_HUB_LANDING_PAGE'.freeze
  WAIT = 'WAIT'.freeze
  GET_C3_DATA = 'GET_C3_DATA'.freeze
  SEND_NO_MATCH_RESPONSE_TO_TRANSACTION = 'SEND_NO_MATCH_RESPONSE_TO_TRANSACTION'.freeze
  SEND_SUCCESSFUL_MATCH_RESPONSE_TO_TRANSACTION = 'SEND_SUCCESSFUL_MATCH_RESPONSE_TO_TRANSACTION'.freeze
  SEND_USER_ACCOUNT_CREATED_RESPONSE_TO_TRANSACTION = 'SEND_USER_ACCOUNT_CREATED_RESPONSE_TO_TRANSACTION'.freeze
  SHOW_MATCHING_ERROR_PAGE = 'SHOW_MATCHING_ERROR_PAGE'.freeze
  USER_ACCOUNT_CREATION_FAILED = 'USER_ACCOUNT_CREATION_FAILED'.freeze

  ALLOWED_OUTCOMES = [
    GOTO_HUB_LANDING_PAGE,
    WAIT,
    GET_C3_DATA,
    SEND_NO_MATCH_RESPONSE_TO_TRANSACTION,
    SEND_SUCCESSFUL_MATCH_RESPONSE_TO_TRANSACTION,
    SEND_USER_ACCOUNT_CREATED_RESPONSE_TO_TRANSACTION,
    SHOW_MATCHING_ERROR_PAGE,
    USER_ACCOUNT_CREATION_FAILED,
  ].freeze

  attr_reader :outcome
  validates_inclusion_of :outcome, in: ALLOWED_OUTCOMES, message: '%{value} is not an allowed value for a matching outcome'

  def initialize(hash)
    @outcome = hash['responseProcessingStatus']
  end
end
