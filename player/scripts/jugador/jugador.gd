extends CharacterBody3D

# Stats
var saludAhora : int = 10
var saludMax : int = 10
var ammo : int = 15
var score : int = 0

# Physics
var moveSpeed : float = 5.0
var jumpForce : float = 4.0
var gravity : float = 9.8

# Camera
var minLookAngle : float = -90.0
var maxLookAngle : float = 90
var cameraSens : float = .2

# Vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# Camera 
@onready var camera = get_node("cameraOrbit/Camera3D")
@onready var pivote = get_node("cameraOrbit/Camera3D/gun/Node3D")
@onready var bulletScene = preload("res://player/bullet.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Captura el movimiento del mouse
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_shoot()

# Maneja el movimiento de la camara en correlacion al mouse
func _process(delta: float) -> void:
	# Rotar camara en el eje X
	camera.rotation_degrees -= Vector3(rad_to_deg(mouseDelta.y),0,0) * cameraSens * delta
	
	# Limitar la rotacion vertical 
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# Rotar el jugador en el eje Y
	rotation_degrees -= Vector3(0, rad_to_deg(mouseDelta.x),0) * cameraSens * delta
	
	# Reiniciar mouseDelta
	mouseDelta = Vector2()
	
	if Input.is_action_just_pressed("shoot"):
		_shoot()


func _shoot():
	var bullet = bulletScene.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_transform = pivote.global_transform
	bullet.scale = Vector3.ONE
	ammo -= 1

func _physics_process(delta: float) -> void:
	# Reiniciar x y z de velocidad en cada cuadro
	velocity.x = 0
	velocity.z = 0
	
	var input = Vector2()
	
	# Input de movimientos
	if Input.is_action_pressed("up"):
		input.y -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("right"):
		input.x += 1
		
	input = input.normalized()
	
	var adelante = -global_transform.basis.z
	var derecha = -global_transform.basis.x

	# Poner velocidad
	velocity.z = (adelante * input.y + derecha * input.x).z * moveSpeed
	velocity.x = (adelante * input.y + derecha * input.x).x * moveSpeed
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jumpForce
	
	move_and_slide()
