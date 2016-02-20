class Event < ActiveRecord::Base
  after_initialize :set_default_values
  before_create :generate_token
  
  has_many :scores
  has_many :teams, through: :scores
  belongs_to :user
  
  validates :name, :description, :date_start, :date_end, presence: true
  
  def generate_token()
    loop do
      code = self.code = SecureRandom.hex(2)
      break code unless self.class.exists?(code: code)
    end
  end

  def set_default_values
    self.visible ||= true
  end

  def to_param
    [id, name.parameterize].join("-")
  end

end
