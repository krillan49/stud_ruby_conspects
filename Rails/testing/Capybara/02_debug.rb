puts '                                  Методы для отладки (save_...) '

# save_and_open_page - это вспомогательный метод, предоставляемый гемом Capybara

# Используется только временно, во время локальной отладки

# Когда в тесте вызывается `save_and_open_page`, то Capybara:
# 1. Сохраняет текущую HTML-страницу во временный .html файл. Так же создает .html файл в корневой директории (?настраивается отдельно?)
# 2. Открывает этот файл в браузере (по умолчанию — в системном), например: Chrome, Firefox
# 3. Позволяет разработчику визуально изучить состояние страницы в момент выполнения теста

# Где используется:
# 1. В system тестах (например, с ApplicationSystemTestCase в Minitest или feature-тестах в RSpec).
# 2. В feature- и integration-тестах, где используется Capybara и браузерный драйвер (например, Selenium или Cuprite).


# Примеры использования в тесте:
test "debugging current page" do
  visit some_path
  save_and_open_page  # <- Страница откроется в браузере
end

test "debugging current page" do
  all('tbody tr').each_with_index do |row, index|
    save_and_open_page if index == 0
    assert_text '6 месяцев'      # не :link, если это не ссылка
  end
end


# Другие похожие методы:
# save_page                - сохраняет, но не открывает
# save_and_open_screenshot - делает скриншот и открывает
# page.body                - можно вывести HTML вручную для анализа