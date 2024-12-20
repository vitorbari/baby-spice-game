extends Area2D

signal ate

# How fast the player will move (pixels/sec).
@export var default_speed = 400
@export var turbo_speed = 800
var speed = default_speed

var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.stop()
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite2D.frame = 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimatedSprite2D.frame = 0
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	ate.emit()
	body.hide() 
	body.set_deferred("disabled", true)

func grow():
	$AnimatedSprite2D.scale *= 1.10
	$CollisionPolygon2D.scale *= 1.10

func shrink():
	$AnimatedSprite2D.scale = Vector2(0.5,0.5)
	$CollisionPolygon2D.scale = Vector2(0.5,0.5)

func turbo():
	speed = turbo_speed

func normal_speed():
	speed = default_speed
