extends Area3D

var speed : float = 30.0
var damage : int = 1

func _process(delta: float) -> void:
	position += global_transform.basis.z * speed * delta


# Funcion para hacer damages a un objeto con el metodo take_damage
func _on_body_entered(body: Node3D) -> void:
	print("collision con: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
	
# Funcion para destrir la bala cuando colisione
func destroy():
	queue_free()


func _on_destroy_timer_timeout() -> void:
	destroy()
