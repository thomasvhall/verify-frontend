class Journeys
  def initialize(journey_paths)
    @journey_paths = journey_paths
  end

  def find_matching_page(path, conditions)
    next_path = @journey_paths[path] || raise("Path '#{path}' doesn't exist")
    if conditions.empty?
      next_path.call
    else
      next_path.call(*conditions)
    end
  end
end
