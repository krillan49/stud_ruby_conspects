# self.included метод который срабатывает, когда класс (тут MessagesDictionary) подключается кудато при помощи include
module MessagesDictionary
  def self.included(klass)
    # klass - принимает константу(или спец объект ??) того класса куда подключаем MessagesDictionary
    klass.include MessagesDictionary::Injector # в итоге подключим в неоходимый класс то что нам нужно
  end
end
# По аналогии с included есть и экстендед








#
