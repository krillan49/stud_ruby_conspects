Sidekiq.configure_server do |config|
  config.on(:startup) do
    # при стартапе подцепим этот фаил для крон
    schedule_file = Rails.root.join("config", "sidekiq_cron_schedule.yml")

    if File.exists?(schedule_file)
      # И если фаил существует просто загружаем инфу из него и ставим в очередь те задачи что перечислены в sidekiq_cron_schedule.yml из тех воркеров что в нем указаны. Загрузит все содержимое и запланирует все задачи
      Sidekiq.schedule = YAML.load_file(schedule_file)
      SidekiqScheduler::Scheduler.instance.reload_schedule!
    end
  end
end
