require 'sidekiq-scheduler'

class CleanWorker
  include Sidekiq::Worker

  def perform # Собственно то что делает воркер (Тут очищает какууюто инфу)
    puts 'starting...'
    Player.destroy_all
    Team.destroy_all
    Tournament.destroy_all
    TeamBuddy.destroy_all
    ScheduledTask.destroy_all
    puts 'cleared!'
  end
end
