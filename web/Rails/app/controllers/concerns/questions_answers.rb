module QuestionsAnswers
  extend ActiveSupport::Concern

  included do
    def load_question_answers(do_render: false) # метод который будем вызывать в контроллерах
      @question = @question.decorate
      @answer ||= @question.answers.build # создаем тольно если еще не опеределена(для questions#show)
      @pagy, @answers = pagy @question.answers.order(created_at: :desc)
      @answers = @answers.decorate
      render('questions/show') if do_render # рэндерим если значение true (для answers#create)
    end
  end
end
