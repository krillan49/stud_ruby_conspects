# 'ООП: Module/namespace(Модули)'

module Tools
  def self.say_hello(name)
    puts "Hi, #{name}"
  end
  def say_bye(name)
    puts "Bye, #{name}"
  end
end
# Теперь мы можем использовать этот модуль в различных фаилах, в которые подключен этот фаил

# В одном фаиле мы можем иметь множество модулей и подключать их потом выборочно в нужных фаилах.
module BB
  def self.say_hi
    puts 'hi'
  end
  def say_bye_bye
    puts "Bye bye"
  end
end
