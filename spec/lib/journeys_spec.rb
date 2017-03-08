require 'rspec'
require 'journeys'

describe 'Journeys' do

  let(:journey_paths) {
    {
      'some-path' => 'next-path',
      'branching-path' => lambda do |conditions|
        return 'somewhere-else' if [:condition] == conditions
        return 'default-path'
      end
    }
  }

  it 'should return the next page in the journey' do
    journeys = Journeys.new(journey_paths)
    expect(journeys.find_matching_page('some-path')).to eql('next-path')
  end

  it 'should raise an error if the current path does not exist' do
    journeys = Journeys.new(journey_paths)
    expect { journeys.find_matching_page('i-dont-exist') }.to raise_error("Path 'i-dont-exist' doesn't exist")
  end

  it 'should match the path based on some conditions' do
    journeys = Journeys.new(journey_paths)
    conditions = [:condition]
    expect(journeys.find_matching_page('branching-path', conditions)).to eql('somewhere-else')
  end
end
