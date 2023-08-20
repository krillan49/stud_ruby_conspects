# ====================================================================================
# 1. Задача - Сделать так, чтобы этот тест прошел(тоесть написать код под тест ?)
# ====================================================================================
require 'rspec/autorun'

RSpec.describe ApiClient do
  let(:host) { '192.168.1.1' }
  let(:port) { 8080 }
  let(:path) { '/posts' }

  before do
    ApiClient.configure do |c|
      c.host = host
      c.port = port
    end
  end

  describe '::get' do
    it 'returns correct full path' do
      expect(ApiClient.get(path)).to eq("#{host}:#{port}/#{path}")
    end
  end
end

# Решение
require 'singleton'

class ApiClient
  include Singleton

  attr_accessor :host, :port

  def self.configure
    yield ApiClient.instance
  end

  def self.get(path)
    the_client = ApiClient.instance
    "#{the_client.host}:#{the_client.port}/#{path}"
  end
end



# ===================================================================================
#  Задача
# ===================================================================================
# Table name: books
#
# id :integer not null, primary key
# iso_code :string
# title :string
# created_at :datetime not null
# updated_at :datetime not null
# author_id :integer
#
# Indexes
#
# index_books_on_author_id (author_id)
#
class Book < ApplicationRecord
  belongs_to :author

  validates :author, :title, presence: true
end

# Table name: authors
#
# id :integer not null, primary key
# birthday :date
# first_name :string
# last_name :string
# created_at :datetime not null
# updated_at :datetime not null
#
class Author < ApplicationRecord
  has_many :books
end

# ЗАДАНИЯ

# 1. Получить список всех авторов в возрасте от 20 до 30 лет(не решил хз как дату сейчас найти)
Author.where("birthday = ?", params[:post_id])
# 2. Написать на ActiveRecord запрос который возвращает все книги по имени автора (first_name)
Author.find_by(first_name: 'Kroker').books
# 3. Написать запрос на SQL который возвращает всех автором с дополнительным столбцом с количеством книг
'WITH ac AS
  SELECT author_id, COUNT(*) AS count FROM books GROUP BY author_id'
'SELECT authors.*, ac.count FROM authors JOIN books ON authors.id = ac.author_id'
