class ChatApplication < ApplicationRecord
  before_create :set_token
  default_scope { where(deleted_at: nil) }
  has_many :chats

  def destroy
    soft_delete!
  end

  def as_custom_json
    {
      token:,
      name:,
      chats_count:
    }
  end

  private

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def set_token
    loop do
      self.token = SecureRandom.uuid
      break unless self.class.exists?(token:)
    end
  end
end
