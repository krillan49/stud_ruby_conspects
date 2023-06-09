puts '                                             REST'

# REST - паттерн для передачи состояния объекта. Это соглашение о том как лучше называть и структурровать URLы и методы их обрабатывающие. Сокращает число необходимых URL.

# В REST существует 7 различных методов(чем-то похожи на методы Синатры и Рэилс ??) с помощью которых можно управлять объектами: index, show, new, create, edit, update, destroy.


# Далее на примере pizzashop и сущности Product(REST-product):

#   index - /products - все наши продукты - get. Данный метод используется для вывода информации о всех сущностях определенной модели(тут Product)
#   show - /products/1 - конкретный продукт - get. (Последнее идентификатор)
#   new - /products/new - вывод формы для создания - get
#   create - /products - создание продукта, обращ. к params и в БД создаёт запись - post
#   edit - /products/1/edit - возвращает форму для редактирования определённого продукта - get
#   update - /products/1 - put
#   destroy - /produts/1 - delete

# Те все URL обрабатывающие определенную сущность называются ее именем во множественном числе, а дальше уже вариации.
