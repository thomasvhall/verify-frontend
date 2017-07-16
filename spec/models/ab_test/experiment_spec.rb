require 'spec_helper'
require 'models/ab_test/experiment'

module AbTest
  describe Experiment do
    context '#get_ab_test_name' do
      it 'will return logos_yes given an input below 0.75' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 75 }, { "name" => "no", "percent" => 25 }] } }
        random_number = 0.1
        expect(Experiment.new(alternatives).get_ab_test_name(random_number)).to eql('logos_yes')
      end

      it 'will return logos_no given an input above 0.75 but below 1.0' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 75 }, { "name" => "no", "percent" => 25 }] } }
        random_number = 0.9
        expect(Experiment.new(alternatives).get_ab_test_name(random_number)).to eql('logos_no')
      end

      it 'will return logos_yes given a value below 0.99' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 99 }, { "name" => "no", "percent" => 1 }] } }
        random_number = 0.8
        expect(Experiment.new(alternatives).get_ab_test_name(random_number)).to eql('logos_yes')
      end

      it 'will return logos_maybe given an input of 0.99' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 33 }, { "name" => "no", "percent" => 33 }, { "name" => "maybe", "percent" => 33 }] } }
        random_number = 0.99
        expect(Experiment.new(alternatives).get_ab_test_name(random_number)).to eql('logos_maybe')
      end

      it 'will return logos_yes given an input of 0.0' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 33 }, { "name" => "no", "percent" => 33 }, { "name" => "maybe", "percent" => 33 }] } }
        random_number = 0.0
        expect(Experiment.new(alternatives).get_ab_test_name(random_number)).to eql('logos_yes')
      end
    end

    context '#alternative_name' do
      it 'will return default alternative name' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 100 }] } }
        expect(Experiment.new(alternatives).alternative_name('DROP TABLES')).to eql('logos_yes')
      end

      it 'will return alternative name' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 100 }, { "name" => "no", "percent" => 1 }] } }
        expect(Experiment.new(alternatives).alternative_name('logos_no')).to eql('logos_no')
      end
    end

    context '#concluded?' do
      it 'will be concluded if it has a single alternative' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 100 }] } }
        expect(Experiment.new(alternatives)).to be_concluded
      end

      it 'will not be concluded if it has more than one alternative' do
        alternatives = { "logos" => { "alternatives" => [{ "name" => "yes", "percent" => 50 }, { "name" => "no", "percent" => 50 }] } }
        expect(Experiment.new(alternatives)).to_not be_concluded
      end
    end

    context '#rp_included' do
      alternative_name = nil
      before(:each) do
        alternative_name = "experiment-alternative-name"
      end

      it 'returns single relying party list for matching alternative name' do
        included_rps = ['rp-one']
        alternatives = { "test_exeriment" =>
                             { "alternatives" =>
                                   [{ "name" => alternative_name,
                                      "percent" => 100,
                                      "rp_include" => included_rps }] } }

        expect(Experiment.new(alternatives).rp_include(alternative_name)).to eql(included_rps)
      end

      it 'returns multiple relying parties list for matching alternative name' do
        included_rps = ['rp-one', 'rp-two']
        alternatives = { "test_exeriment" =>
                             { "alternatives" =>
                                   [{ "name" => alternative_name,
                                      "percent" => 100,
                                      "rp_include" => included_rps }] } }

        expect(Experiment.new(alternatives).rp_include(alternative_name)).to eql(included_rps)
      end

      it 'returns empty list for matching alternative name when no relying parties are included' do
        alternatives = { "test_exeriment" =>
                             { "alternatives" =>
                                   [{ "name" => alternative_name,
                                      "percent" => 100 }] } }

        expect(Experiment.new(alternatives).rp_include(alternative_name)).to eql([])
      end

      it 'returns empty list when alternative name does not match' do
        alternatives = { "test_exeriment" =>
                             { "alternatives" =>
                                   [{ "name" => alternative_name,
                                      "percent" => 100 }] } }

        expect(Experiment.new(alternatives).rp_include('NON EXISTENT NAME')).to eql([])
      end
    end
  end
end
