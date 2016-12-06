class IdpRanker

  def initialize(rankings)
    @rankings = rankings
  end

  def rank(evidence)
    evidence_set = evidence.map(&:to_s).to_set
    @rankings.select do |ranking|
      profile_set = ranking['profile'].to_set
      evidence_set == profile_set
    end.map do |ranking|
      ranking['rank']
    end.first
  end

end
