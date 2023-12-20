class ApplicationService
  def self.call(*args, &block) # создаем метод класса
    new(*args, &block).call # инстанцирует указанный класс (создает экзепляр, те сервисный объект класса наследника, который вызовет метод self.call и передает в него параметры, те params[:archive]) и вызывает уже метод call экземпляра того класса
  end
end
