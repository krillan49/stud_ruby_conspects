puts '                                               HTML'

# В руби пишем теги просто через оператор вывода puts/print
puts '<body>' # теперь со следующей строки можно писать html код(весь вывод будет восприниматься как html код)
puts 'hello<br>'

def show_book book
	puts '==============================<br/>'
	book.each do |name, age|
		puts "<i>#{name}</i>'s age is <b>#{age}</b><br/>"
	end
	puts '==============================<br/>'
end

book1={mike: 65, tom: 55}
show_book book1
book2={jessie: 22, den: 32}
show_book book2
book=book1.merge book2
show_book book

puts "</body>" #=> закрываем тег


# Пример с yeild
def show_me_text
  print "<h1>"
  yield
  print "</h1>"
end

show_me_text { puts "Foo!" }
#=> <h1>Foo!</h1>
