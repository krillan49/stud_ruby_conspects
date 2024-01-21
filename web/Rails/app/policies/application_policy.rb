class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user      # текущий пользователь передается при инициализации нового объекта ApplicationPolicy
    @record = record  # та запись(вопрос, ответ итд), но так же Пандит может работать и с и любым другим объектом не обязательно Актив Рекорд, по отношению к которой пользователь хочет чтото сделать
  end

  # Далее прописывантся что пользователь может делать по отношению к какойто записи, тоесть имеет ли право на использование соотв по названию экшена контроллера, тоесть если в методе:
  # true - то экшен соотв контроллера могут использовать все посетители
  # false - экшен соотв контроллера не может использовать не кто
  # какието конкретные юзеры - то экшен соотв контроллера могут использовать только описанные юзеры

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
    create? # тоесть false, тоесть тоже самое что и в методе create?. Тоесть нет смысла переопределять его отдельно, проще ограничивать так вместе с create?
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
