class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrense { daily(1) }

  def perform
    # User.send_daily_digest
  end
end
