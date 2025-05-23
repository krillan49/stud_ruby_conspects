puts '                                    Кэширование с помощью Rails'

# https://guides.rubyonrails.org/caching_with_rails.html

# Caching / Кэширование - сохранение контента, созданного в ходе цикла «запрос-ответ», и его повторное использование при ответе на похожие запросы

# Кэширование — один из самых эффективных способов повысить производительность приложения. Оно позволяет веб-сайтам, работающим на скромной инфраструктуре — одном сервере с одной базой данных — поддерживать тысячи одновременных пользователей.

# Rails предоставляет набор встроенных функций кэширования, которые позволяют не только кэшировать данные, но и решать такие проблемы, как истечение срока действия кэша, зависимости кэша и аннулирование кэша.



puts '                                      Типы кэширования в Rails'

# По умолчанию кэширование Action Controller включено только в продакшн среде

# Чтобы использовать кэширование локально:
# 1. Можно запустить:
# $ rails dev:cache
# 2. Можно установить в .trueconfig/environments/development.rb настройку
config.action_controller.perform_caching # Изменение значения config.action_controller.perform_caching повлияет только на кэширование, предоставляемое Action Controller, оно не повлияет, например, на низкоуровневое кэширование

# Типы кэширования в Rails:
# 1. Кэширование фрагментов
# 2. Кэширование матрешки
# 3. Совместное частичное кэширование
# 4. Низкоуровневое кэширование с использованием Rails.cache
# 5. Кэширование SQL



puts '                        Низкоуровневое кэширование с использованием Rails.cache'

# https://guides.rubyonrails.org/caching_with_rails.html#low-level-caching-using-rails-cache

# Иногда нужно кэшировать значение или результат запроса вместо кэширования фрагментов представления. Механизм кэширования Rails отлично подходит для хранения любой сериализуемой информации.


# Rails.cache.write - метод для сохранение значения в кэше, где 1й аргумент это ключ, а 2й значение, что будет сохранено.
Rails.cache.write("greeting", "Hello, world!")

# Rails.cache.read - метод для извлечения значения из кэша по ключу
Rails.cache.read("greeting") #=> "Hello, world!"

# Rails.cache.fetch - метод осуществляет чтение из кэша, либо запись и возврат значения по умолчанию. Если под ключем из аргумента существует значение то оно возвращается, а блок, если он передан(можно и не передавать) не выполняется. Если блок передан и под ключем из аргумента нет значения, то блок выполняется и значение возвращаемое из блока записывается в кэш под ключом из аргумента и возвращается.
Rails.cache.fetch("welcome_message") { "Welcome to Rails!" } #=> Welcome to Rails!

# Rails.cache.delete - метод для удаления значения из кэша по ключу
Rails.cache.delete("greeting")

# Rails.cache.clear - очистить весь кэш
Rails.cache.clear


# Например Product модель с методом экземпляра, который ищет цену продукта на веб-сайте. Данные, возвращаемые этим методом, идеально подходят для низкоуровневого кэширования:
class Product < ApplicationRecord
  def competing_price
    Rails.cache.fetch("#{cache_key_with_version}/competing_price", expires_in: 12.hours) do
      Competitor::API.find_price(id)
    end
    # cache_key_with_version - метод, который генерирует строку на основе имени класса модели, id и updated_at атрибутов, этот ключ кэша будет выглядеть примерно "products/233-20140225082222765838000/competing_price". Это общепринятое соглашение, его преимущество в том, что кэш становится недействительным при каждом обновлении продукта. В общем, когда используеттся низкоуровневое кэширование, необходимо сгенерировать ключ кэша.
  end
end


# Не стоит кэшировать объекты Active Record, лучше кешировать ID или какой-либо другой примитивный тип данных. Тк экземпляр может измениться, в продакшене атрибуты на нем могут отличаться, запись может быть удалена, а в разработке это работает ненадежно с кэш-хранилищами, которые перезагружают код при внесении изменений.

# Так не надо - в кэше хранится список объектов Active Record, представляющих суперпользователей:
Rails.cache.fetch("super_admin_users", expires_in: 12.hours) do
  User.super_admins.to_a
end

# Так надо - в еше хранится набор ключей, указывающих на суперпользователей:
ids = Rails.cache.fetch("super_admin_user_ids", expires_in: 12.hours) do
  User.super_admins.pluck(:id)
end
# Получаем объекты по ключам
User.where(id: ids).to_a



puts '                                        Rspec + Rails.cache'

# По умолчанию методы Rails.cache не раотают в тестах

# !!! Не следует на самом деле тестировать фреймворк. Тесты кэширования Rails, по-видимому, покрывают это для вас.

# Разные варианты решения:
# https://stackoverflow.com/questions/5035982/optionally-testing-caching-in-rails-3-functional-tests
# https://makandracards.com/makandra/46189-rails-cache-individual-rspec-tests
# https://stackoverflow.com/questions/16156862/how-can-i-test-rails-cache-feature


# 1. Оставьте конфигурацию по умолчанию
# 2. Теперь заглушите кэш Rails и очистите его перед каждым примером :
RSpec.describe SomeClass do
  # объем памяти ограничен для каждого процесса, и поэтому в параллельных тестах нет конфликтов
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  it do
    expect(cache.exist?('some_key')).to be(false)

    cache.write('some_key', 'test')

    expect(cache.exist?('some_key')).to be(true)
  end
end

# Пример из silver-palm-tree
RSpec.feature "Home Page", type: :feature do
  before do
    10.times { FactoryBot.create(:podcast) }
  end

  context "random podcast" do
    # connect the cache to the tests only in this block
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    scenario "by default" do
      visit root_path

      random_podcast_id = Rails.cache.read("random_podcast_id")

      expect(random_podcast_id).to be_present
      expect(Podcast.exists?(id: random_podcast_id)).to be_truthy
      expect(page).to have_selector("#random_podcast")
    end

    scenario "forced" do
      Rails.cache.write("random_podcast_id", 6, expires_in: 1.days)
      visit root_path

      random_podcast_id = Rails.cache.read("random_podcast_id")

      expect(random_podcast_id).to eq(6)
      expect(Podcast.exists?(id: 6)).to be_truthy
      expect(page).to have_selector("#random_podcast")
    end
  end
end

















#
