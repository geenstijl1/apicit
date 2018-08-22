class User < ApplicationRecord
  has_secure_password
  before_create :set_default_role
  mount_uploader :avatar, AvatarUploader
  attr_accessor :current_password

  validates :username, presence: true, uniqueness: true, length:  {in: 3..12}
  validates :email, presence: true, uniqueness: true
  validates_length_of       :password, maximum: 72, minimum: 8, allow_nil: true, allow_blank: false
  validates_presence_of :password_confirmation, if: :password_digest_changed?

  enum role: [:admin, :user, :supervisor]

  private

  def set_default_role
    self.role ||= :user
  end

  validate :current_password_is_correct,
           if: :validate_password?, on: :update

  def current_password_is_correct
    if User.find(id).authenticate(current_password) == false
      errors.add(:current_password, "is incorrect.")
    end
  end

  def validate_password?
    !password.blank?
  end

end
