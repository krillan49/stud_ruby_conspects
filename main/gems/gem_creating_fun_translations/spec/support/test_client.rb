module TestClient
  # метод имитирует создание клиента
  def test_client(token = nil)
    FunTranslations.client token
  end
end
