module AbTest
  class Experiment
    # config structure: {"logos"=>{"alternatives"=>[{"name"=>"yes", "percent"=>75}, {"name"=>"no", "percent"=>25}, {"name"=>"privacy", "percent"=>0}]}}
    def initialize(config)
      experiment_title = config.keys.first
      @alternatives = creates_alternatives(config, experiment_title)
      @default = name(experiment_title, config.values.first['alternatives'].first)
      @total = @alternatives.values.inject(:+).to_f
      @rps_included = relying_parties_alternative_applies_to(config)
    end

    def get_ab_test_name(random)
      random = (random * @total).round
      @alternatives.each do |name, weight|
        return name.to_s if random < weight
        random -= weight
      end
    end

    def creates_alternatives(config, experiment_title)
      alternatives = {}
      list_of_alternatives = config.values.first['alternatives']
      list_of_alternatives.each { |alternative| alternatives[name(experiment_title, alternative)] = alternative['percent'] }
      alternatives
    end

    def alternative_name(alternative_name)
      unless @alternatives[alternative_name]
        return @default
      end
      alternative_name
    end

    def concluded?
      @alternatives.keys.length <= 1
    end

    def relying_parties_alternative_applies_to(config)
      alternatives_with_rp_list = -> (alt) { alt['rp_include'] != nil }
      alternative_name_to_relying_parties = -> (alt) { { alt['name'] => alt['rp_include'] } }

      list_of_alternatives = config.values.first['alternatives']
      list_of_alternatives
          .select(&alternatives_with_rp_list)
          .map(&alternative_name_to_relying_parties)
          .reduce({}, :merge)
    end

    def rp_include(alternative_name)
      @rps_included[alternative_name] || []
    end

  private

    def name(experiment_title, alternative)
      "#{experiment_title}_#{alternative['name']}"
    end
  end
end
