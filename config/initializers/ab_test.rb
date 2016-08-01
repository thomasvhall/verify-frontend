Split.configure do |config|
  # config.persistence = :cookie
  # Split.redis = 'localhost:6379'
  # config.persistence = Split::Persistence::RedisAdapter.with_config(lookup_by: -> (context){context.session.instance_variable_get(:@env)['action_dispatch.cookies'].instance_variable_get(:@cookies)['x_govuk_session_cookie']})
  config.db_failover = true
  config.experiments = {
      remove_logos: {
          alternatives: ['a', 'b', 'c'],
          metadata: {
              'a' => { name: 'a', index_page: 'index', percent: 0.5, certified_companies_page: 'certified_companies' },
              'b' => { name: 'b', index_page: 'index_scenario_b', percent: 0.25, certified_companies_page: 'certified_companies_b' },
              'c' => { name: 'c', index_page: 'index_scenario_c', percent: 0.25, certified_companies_page: 'certified_companies_c' }
          }
      }
  }
end