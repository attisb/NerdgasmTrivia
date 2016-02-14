class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :teammates
  has_many :teams, through: :teammates
  belongs_to :team
  has_many :scores

  after_initialize :set_default_values

  validates :first_name, :last_name, presence: true

  self.per_page = 20

  def set_default_values
    self.admin ||= false
    self.host ||= false
  end

  def sum_score
    Score.where(user_id: self.id).sum(:points)
  end


end
