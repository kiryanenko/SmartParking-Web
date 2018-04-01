class Random
  def self.rand_bool(chance = 0.5)
    rand < chance
  end
end