Sidekiq.configure_server do |config|
  config.on(:startup) do
    # при стартапе подцепим наш yml фаил с инфой/настройками о времени запуска и именем очереди очереди для cron
    schedule_file = Rails.root.join("config", "sidekiq_cron_schedule.yml")

    if File.exists?(schedule_file)
      # И если фаил config/sidekiq_cron_schedule.yml существует просто загружаем инфу из него и ставим в очередь те задачи в те воркеры, что в нем указаны. Загрузит все содержимое и запланирует все задачи
      Sidekiq.schedule = YAML.load_file(schedule_file)
      SidekiqScheduler::Scheduler.instance.reload_schedule!
    end
  end
end
