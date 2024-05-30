module QuestionsAnswers
  extend ActiveSupport::Concern

  included do
    def load_question_answers(do_render: false) # метод который будем вызывать в контроллерах
      @question = @question.decorate
      @answer ||= @question.answers.build # создаем для генерации URL в форме questions#show (тольно если еще не опеределена)
      @pagy, @answers = pagy @question.answers.includes(:user).order(created_at: :desc)
      @answers = @answers.decorate
      render('questions/show') if do_render # рэндерим если значение true (для answers#create)
    end
  end
end
