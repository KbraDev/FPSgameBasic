extends CharacterBody3D

var salud = 10
var velMov = 1

var damage = 1
var attackRate = 1
var attackDist = 2

var puntosQueDa = 10

# Componentes

@onready var player : Node = get_parent().get_node("jugador")
@onready var timer = $Timer

func _ready() -> void:
	timer.set_wait_time(attackRate)

func _physics_process(delta: float) -> void:
	var dir = (player.position - position).normalized()
	dir.y = 0
	
	velocity = dir * velMov
	
	move_and_slide()
	
	
func take_damage(damage):
	salud -= damage
	print("Enemigo recibio dano, salud restante: ", salud)
	if salud <= 0:
		morirse()
		

func morirse():
	player.add_score(puntosQueDa)
	queue_free()
	
	
func atacar():
	player.take_damage(damage)
	

func _on_timer_timeout() -> void:
	if position.distance_to(player.position) <= attackDist:
		atacar()
