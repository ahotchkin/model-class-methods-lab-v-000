class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    self.first(5)
  end

  def self.dinghy
    where("length < 20")
  end

  def self.ship
    where("length >= 20")
  end

  def self.last_three_alphabetically
    self.all.sort_by(&:name).reverse.first(3)
  end

  def self.without_a_captain
    where(captain_id: nil)
  end

  def self.sailboats
    includes(:classifications).where(classifications: { name: "Sailboat"} )
  end

  def self.non_sailboats
    where("id NOT IN (?)", self.sailboats.pluck(:id))
  end

  def self.with_three_classifications
    joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
  end

  def self.longest_boat
    self.all.sort_by(&:length).last
  end

end
