class Hero
  attr_reader :name, :health

  def initialize(name, health=100)
    @name = name.capitalize
    @health = health
  end

  def power_up
    @health += 10
  end

  def hero_info
    "#{@name} has #{@health} health"
  end
end
