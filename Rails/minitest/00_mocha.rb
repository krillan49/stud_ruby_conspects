puts '                                              mocha'

# mocha - библиотека  которая предоставляет stubs (?? и чето еще ??) для Minitest

# Gemfile:
group :test do
  gem "mocha"
end
# $ bundle install

# test_helper.rb добавить:
require "mocha/minitest"



puts '                                              Примеры'

test "should get export (xlsx)" do
  Export::PurchasesToXlsxJob.stubs(:perform_now).returns(Rails.root.join("tmp", "dummy.xlsx").to_s)
  get export_workspace_cabinet_purchases_path(@cabinet), as: :xlsx
  assert_response :success
end

test "should get export (xlsx)" do
  # Тест проверяет, что экшен export возвращает XLSX-файл.
  #
  # Контроллер вызывает Export::PurchasesToXlsxJob и передаёт путь к сгенерированному файлу в send_file.
  #
  # Вместо запуска джоба и генерации файла, подменяем perform_now с помощью stub,
  # возвращая путь к временному XLSX-файлу, созданному через Tempfile.
  #
  # Tempfile безопасно создаёт и удаляет файл после завершения блока.
  #
  # headers["Accept"] нужен, чтобы не возникло ошибки, с форматом ответа
  Tempfile.create(["dummy", ".xlsx"]) do |file|
    file.write("fake xlsx content")
    file.rewind
    Export::PurchasesToXlsxJob.stubs(:perform_now).returns(file.path)
    get export_workspace_cabinet_purchases_path(@cabinet), headers: { "Accept" => "*/*" }
    assert_response :success
  end
end