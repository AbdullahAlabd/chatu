class Chat < ApplicationRecord
  belongs_to :chat_application
  validates :number, numericality: { greater_than: 0 }
  default_scope { where(deleted_at: nil) }

  def destroy
    soft_delete!
  end

  def as_custom_json
    {
      number:,
      name:,
      messages_count:
    }
  end

  private

  def soft_delete!
    update!(deleted_at: Time.current)
  end
end
