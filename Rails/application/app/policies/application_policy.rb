class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # Вариант 1:
    @user = user  # текущий пользователь передается по умолчанию от хэлпера current_user при инициализации нового экземпляра ApplicationPolicy или ее политики-наследника, который создается когда мы вызываем метод authorize в контроллере
    # Вариант 2:
    @user = user || GuestUser.new  # добавим гостевого юзера из сервисного объекта services/guest_user.rb если current_user возвразает nil, тоесть пользователь не аутонтефицирован(не вошел в сисему)

    @record = record  # та запись, по отношению к которой пользователь хочет что-то сделать(тоесть либо конкретный вопрос, ответ итд, либо константа модели). Но так же Пандит может работать и с и любым другим объектом не обязательно Актив Рекорд. Передается из метода authorize, например (@question || Question)
  end

  # Далее прописывантся что пользователь может делать по отношению к какой-то записи, тоесть имеет ли право на использование соответсвующих по названию экшенов контроллера
  # Если в методе:
  # true             - то экшен соотв контроллера могут использовать все посетители
  # false            - то экшен соотв контроллера не может использовать никто
  # конкретные юзеры - то экшен соотв контроллера могут использовать только эти конкретные юзеры

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create? # тоесть false через create?. Нет смысла переопределять его отдельно, логичнее ограничивать так вместе с create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end


  # !! Потом можно изучить
  # Пандит умеет работать(есть в доках) со скоупами - они позволяют выдавать список записей из БД в зависимости от роли, например админам все, а комуто только определенные(WHERE)
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end

end














#
