# 'ООП: Module/namespace(Модули)'

module Tools
  def self.say_hello(name)
    puts "Hi, #{name}"
  end
  def say_bye(name)
    puts "Bye, #{name}"
  end
end
# Теперь мы можем использовать этот модуль в различных фаилах, в нашем случае в example10.rb

# В одном фаиле мы можем иметь множество модулей и подключать их потом выборочно в нужных фаилах.
module BB
  def self.say_hi
    puts 'hi'
  end
end
