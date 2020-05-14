extends Node
class_name Timerzinho

var timer_on: bool = true


func start_timerzinho() -> void:
    while true:

        ## Fazer a requisição
        yield(get_tree().create_timer(0.5), "timeout")
    
## TODO: Mudar o nome desse script
## TODO: Colocá-lo em uma cena
## TODO: Criar uma pasta específica para ele
## TODO: Colocar um Node HTTP
## TODO: Conectar o sinal de HTTP neste script
## TODO: Fazer a requisição dentro do while da função start_timerzinho
## TODO: OBS: Mudar o nome das funções dentro desse script
## TODO: Quando a requisição terminar -> Enviar um sinal
## TODO: Ter um jeito de quando a classe do Timerzinho for criada, quem criou, conseguir conectar uma função no sinal que o timerzinho emitirá quando a requisição concluir
## TODO: Objetivo desse script -> Fazer uma requisição pra sempre, até segunda ordem e enviar o resultado dessa requisição para algum lugar
## TODO: 

