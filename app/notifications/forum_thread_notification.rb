# frozen_string_literal: true

class ForumThreadNotification < Noticed::Base
  deliver_by :database, association: :noticed_notifications
  deliver_by :slack, format: :to_slack, url: :slack_webhook_url

  def message
    user = params[:user]
    thread = params[:forum_thread]
    t("users.notifications.forum_thread_notification", user: user.name, thread: thread.title.truncate_words(4))
  end

  def icon
    "far fa-comments"
  end

  def to_slack
    {
      text: "*Title*: #{params[:forum_thread].title}\n*By*: #{params[:user].name}
      \n*Link*: #{generate_forum_thread_link(params[:forum_thread])}"
    }
  end

  def slack_webhook_url
    ENV.fetch("SIMPLE_DISCUSSION_SLACK_HOOK_URL", nil)
  end

  def generate_forum_thread_link(forum_thread)
    "https://circuitverse.org/forum/threads/#{forum_thread.slug}"
  end
end
