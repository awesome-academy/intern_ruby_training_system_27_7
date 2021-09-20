class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform object, header, type, user
    content = "#{type}.#{object.status}"

    Notification.create! user: user,
      header: header, content: content
  end
end
