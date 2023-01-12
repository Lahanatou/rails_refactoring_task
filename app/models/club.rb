class Club < ApplicationRecord
  before_commit :players_average_age, only: [:show]
  has_one_attached :logo

  has_many :home_matches, class_name: "Match", foreign_key: "home_team_id"
  has_many :away_matches, class_name: "Match", foreign_key: "away_team_id"
  has_many :players
  belongs_to :league

  def matches
    Match.where("home_team_id = ? OR away_team_id = ?", self.id, self.id)
  end

  def matches_on(year = nil)
    return nil unless year

    matches.where(kicked_off_at: Date.new(year, 1, 1).in_time_zone.all_year)
  end

  def won?(match)
    match.winner == self
  end

  def lost?(match)
    match.loser == self
  end

  def draw?(match)
    match.draw?
  end

  def win_on(year)
    commun(year,1)
  end

  def lost_on(year)
    commun(year,2)
  end

  def draw_on(year)
    commun(year,3)
  end
  [:won?, :lost?, :draw?]
  #def homebase
  #  "#{hometown}, #{country}"
  #end
  def players_average_age
    if self.players.length != 0
      (self.players.sum(&:age) / self.players.length).to_f
    end
  end
  private
    def commun(year,i)
      note ="draw?"
      year = Date.new(year, 1, 1)
      count = 0
      matches.where(kicked_off_at: year.all_year).each do |match|
        if i == 1
          count += 1 if won?(match)
        elsif i == 2
          count += 1 if lost?(match)
        elsif i == 3
          count += 1 if draw?(match)
        end
      end
      count
    end

end
