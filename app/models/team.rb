class Team < ActiveRecord::Base
  has_many :teammates
  has_many :users, through: :teammates
  belongs_to :user
  has_many :scores

  after_initialize :set_default_values
  before_create :generate_token
  
  validates :name, presence: true
  
  def generate_token()
    loop do
      code = self.code = SecureRandom.hex(3)
      break code unless self.class.exists?(code: code)
    end
  end

  def set_default_values
    self.visible ||= true
  end
  
  def sum_score
    Score.where(team_id: self.id).sum(:points)
  end

end
