class Message < ApplicationRecord
  belongs_to :chat
  validates :message_number, numericality: { greater_than: 0 }
  default_scope { where(deleted_at: nil) }

  def destroy
    soft_delete!
  end

  def as_custom_json
    {
      message_number:,
      content:
    }
  end

  private

  def soft_delete!
    update!(deleted_at: Time.current)
  end
end
