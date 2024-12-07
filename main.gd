extends Node

@export var food_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	$TextureRect.rotation += 0.0005
	$HUD.update_time(int($MainTimer.time_left))

func game_over() -> void:
	$FoodTimer.stop()
	
	$HUD.hide_live_score()
	$HUD.show_game_over(score)
	
	$Music.stop()
	
func new_game():
	get_tree().call_group("foods", "queue_free")
	
	score = 0
	$Cat.start($StartPosition.position)
	$StartTimer.start()
	$MainTimer.start()
	
	$HUD.show_live_score()
	$HUD.update_score(score)
	$HUD.show_message("Preparar")
	
	$Music.play()

func _on_food_timer_timeout() -> void:
	# Create a new instance of the Food scene.
	var food = food_scene.instantiate()

	# Choose a random location on Path2D.
	var food_spawn_location = $FoodPath/FoodSpawnLocation
	food_spawn_location.progress_ratio = randf()

	# Set the food's direction perpendicular to the path direction.
	var direction = food_spawn_location.rotation + PI / 2

	# Set the food's position to a random location.
	food.position = food_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	food.rotation = direction

	# Choose the velocity for the food.
	var velocity = Vector2(randf_range(150.0, 450.0), 0.0)
	food.linear_velocity = velocity.rotated(direction)

	# Spawn the food by adding it to the Main scene.
	add_child(food)


func _on_start_timer_timeout() -> void:
	$FoodTimer.start()

func _on_cat_ate() -> void:	
	$MeowSound.play()
	score += 1
	$HUD.update_score(score)


func _on_main_timer_timeout() -> void:
	game_over()
