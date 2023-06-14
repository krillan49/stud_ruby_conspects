# УРОК 15 ==============================================================
# ООП. Связь классов. Альбомы-песни. Настенька
puts 'Тебе предстоит спродюссировать музыкальный альбом Настеньки и сделать ее поп звездой'
print 'Введи название своего лэйбла '
lable = gets.strip

class Album
	attr_reader :singer, :name, :songs

	def initialize singer, name
		@singer = singer
		@name = name
		@songs = []
	end

	def add_song song
		@songs << song
	end
end

class Song
	attr_reader :name, :duration

	def initialize name, duration
		@name = name
		@duration = duration
	end
end

loop do
  puts 'Выберите название альбома из предложенных(нажав указанный символ в скобках) или напишите свое'
  print '(1)"Опять 46"; (2)"Чморота ослоебная"; (3)"Этикет мой этикет" '
  name_album = gets.strip.capitalize
  case name_album
  when '1' then name_album = "Опять 46"
  when '2' then name_album = "Чморота ослоебная"
  when '3' then name_album = "Этикет мой этикет"
  end
  album1 = Album.new('Настенька', name_album)

  song_rand_sush = ['пидорас', 'тварина', 'ослопидор', 'Дзюба', 'хер', 'алкаш', 'хуй', 'падлюка', 'убогое подсирало', 'уебок', 'дерьмо', 'говно', 'пидор', 'хуета', 'курица тупорылая', 'дебил', 'ебанашка', 'лох безрукий', 'овца', 'ослоеб', 'некрофил', 'уебышь', 'долбоеб', '60 летний пидор', 'сука', 'проеба носатая', 'чмоша', 'чмо', 'засранный дед', 'баран', 'хачь']
  song_rand_pril = ['ебаный в рот', 'ебать', 'старый', 'уродливый', 'сосущий', 'обосанный', 'душный', 'ебаное', 'зоофистинг', 'сраной мыши еще не хватало', 'засунь хуй осла себе в глотку', 'тебя забыли спросить мудло', 'ебнутый', 'покажи хуй', 'с пидорасам дел не имею общих', 'в сраку дуло засунь', 'жирный', 'засохшее говно', 'тупой', 'жирное чмо']
  song_rand_deys = ['иди в пизду', 'иди нахуй', 'соси хуй', 'ахуеть', 'шо бля несешь', 'бля', 'мне похуй', 'заебал', 'пиздишь', 'тебя забыли спросить', 'блять', 'отъебись', 'с хуя ли', 'ебала я', 'ебальник бью', 'кончил', 'сосать ослячий хуй', 'очко горит', 'ебало свое завали', 'ты ебало свое видел?']

  puts 'запустите генератор названий песен и выберете количество песен в альбоме(введите цифру) '
  num_songs = gets.to_i

  num_songs.times do
    choose = rand(3)
    case choose
    when 0
      song_rand = "#{song_rand_sush[rand(song_rand_sush.size)].capitalize} #{song_rand_sush[rand(song_rand_sush.size)]}"
    when 1
      song_rand = "#{song_rand_pril[rand(song_rand_pril.size)].capitalize} #{song_rand_sush[rand(song_rand_sush.size)]}"
    when 2
      song_rand = "#{song_rand_sush[rand(song_rand_sush.size)].capitalize} #{song_rand_deys[rand(song_rand_deys.size)]}"
    end

  	song = Song.new(song_rand, "#{rand(3..6)}m #{rand(1..59)}s")
  	album1.add_song(song)
  end

  puts '-'*40
  puts "\"#{lable}\" представляет новый альбом Настеньки - \"#{album1.name}\""
  puts '-'*40
  album1.songs.each_with_index do |song, i|
  	puts "#{i + 1}: #{song.name} - #{song.duration}"
  end
  puts '-'*40

  print 'Попробуем еще раз(1) или запишем этот альбом(2)? '
  more = gets.to_i
  if more == 2
    puts "Поздравляю альбом Настеньки \"#{album1.name}\" ушел в запись. Теперь она станет поп звездой а ты еще богаче!"
    break
  else
    album1.songs.clear
  end
end


# Модификация: Артист - Альбом - Песня-------------------------------------------------------------------------------
class Artist
	attr_reader :name, :albums

	def initialize name
		@name = name
		@albums = []
	end

	def add_album album
		@albums << album
	end
end

class Album
	attr_reader :name, :songs

	def initialize name
		@name = name
		@songs = []
	end

	def add_song song
		@songs << song
	end
end

class Song
	attr_reader :name, :duration

	def initialize name, duration
		@name = name
		@duration = duration
	end
end

artist_rand = ['Pupa-zalupa', 'Senya Bidlishev', 'Chmo MC']
artist1 = Artist.new(artist_rand[rand(3)])

album_rand = ['jopa', 'huilo', 'pidar', 'suka', 'sosi', 'jri', 'govno', 'zalupa']
album1 = Album.new("#{album_rand[rand(album_rand.size)]} #{album_rand[rand(album_rand.size)]}".capitalize)
artist1.add_album(album1)

song_rand = ['faggot', 'beach', 'donkey', 'fuck you', 'asshole', 'shit', 'suck my dick']
3.times do
	song = Song.new("#{song_rand[rand(song_rand.size)]} #{song_rand[rand(song_rand.size)]}", "#{rand(3..6)}m #{rand(1..59)}s")
	album1.add_song(song)
end

puts artist1.name
album_choose = rand(artist1.albums.size)
puts artist1.albums[album_choose].name
artist1.albums[album_choose].songs.each_with_index do |song, i|
	puts "Song #{i + 1}: #{song.name.capitalize} - #{song.duration}"
end
