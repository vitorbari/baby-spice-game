extends Node

@export var food_scene: PackedScene
var score

var GameMode
enum Modes {MODE_NORMAL, MODE_ZEN, MODE_TURBO}

# Elapsed time for zenmode
var time_start = 0

var stages = [[10, 25], [15, 25], [18, 20], [20, 20], [25, 20]]
var current_stage = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	$TextureRect.rotation += 0.0005

	match GameMode:
		Modes.MODE_ZEN:
			$HUD.update_time(int(Time.get_unix_time_from_system() - time_start))
		Modes.MODE_TURBO:
			$HUD.update_time("%1.2f" % $MainTimer.time_left)
		_:
			$HUD.update_time(int($MainTimer.time_left))

	if Input.is_action_pressed("exit_game"):
		game_over()

func show_menu() -> void:
	$Menu.show()

func stop_game() -> void:
	GameMode = null

	$MainTimer.stop()

	$FoodTimer.stop()
	get_tree().call_group("foods", "queue_free")

	$ZenMusic.stop()
	$Music.stop()
	
func show_final_score() -> void:
	await $HUD.show_final_score(score)
	
func show_winning_message() -> void:
	await $HUD.show_winning_message()

func game_over() -> void:
	current_stage = 0
	stop_game()
	await show_final_score()
	$HUD.hide()
	show_menu()

func prepare_before_game_start():
	$Menu.hide()
	$HUD.show()
	score = 0
	$Cat.start($StartPosition.position)
	$Cat.normal_speed()
	$Music.pitch_scale = 1.0
	$FoodTimer.wait_time = 0.5
	$MeowSound.pitch_scale = 1.0
	$MeowSound.volume_db = 20
	
	$MainTimer.wait_time = 30

func start_normal_mode():
	prepare_before_game_start()

	GameMode = Modes.MODE_NORMAL

	var goal = get_goal_current_stage()
	var time = get_time_from_current_stage()

	$StartTimer.start()
	$MainTimer.wait_time = time
	$MainTimer.start()

	$HUD.show_live_score()
	$HUD.update_score("%d/%d" % [score, goal])
	$HUD.show_message("Nível %d:\n%d latinhas em\n%d segundos" % [current_stage + 1, goal, time])

	$Music.play()

func start_zen_mode():
	prepare_before_game_start()

	GameMode = Modes.MODE_ZEN

	time_start = Time.get_unix_time_from_system()

	$StartTimer.start()

	$HUD.show_live_score()
	$HUD.update_score(score)
	$HUD.show_message("Paz e amor")

	$Cat.shrink()
	$ZenMusic.play()

func start_turbo_mode():
	prepare_before_game_start()

	GameMode = Modes.MODE_TURBO

	# Spawn food faster
	$FoodTimer.wait_time = 0.25

	$StartTimer.start()
	$MainTimer.start()

	$HUD.show_live_score()
	$HUD.update_score(score)
	$HUD.show_message("Vaiii!!!!!")

	$Cat.turbo()
	$Music.pitch_scale = 1.2
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
	var velocity = null
	match GameMode:
		Modes.MODE_TURBO:
			velocity = Vector2(randf_range(600.0, 950.0), 0.0)
		_:
			velocity = Vector2(randf_range(150.0, 450.0), 0.0)

	food.linear_velocity = velocity.rotated(direction)

	# Spawn the food by adding it to the Main scene.
	add_child(food)

func _on_start_timer_timeout() -> void:
	$FoodTimer.start()

func _on_cat_ate() -> void:	
	score += 1

	match GameMode:
		Modes.MODE_TURBO:
			$Explosion.play()
		_:
			$MeowSound.play()

	match GameMode:	
		Modes.MODE_NORMAL:
			$HUD.update_score("%d/%d" % [score, get_goal_current_stage()])
		_:
			$HUD.update_score(score)

	if score >= get_goal_current_stage():
		goal_completed()

func _on_main_timer_timeout() -> void:
	game_over()

func _on_menu_normal_mode_pressed() -> void:
	start_normal_mode()

func _on_menu_turbo_mode_pressed() -> void:
	start_turbo_mode()

func _on_menu_zen_mode_pressed() -> void:
	start_zen_mode()

func _on_hud_menu_pressed() -> void:
	stop_game()
	await show_final_score()
	$HUD.hide()
	show_menu()

func get_goal_current_stage() -> int:
	var s = stages[current_stage]
	return s[0]

func get_time_from_current_stage() -> int:
	var s = stages[current_stage]
	return s[1]

func goal_completed() -> void:
	stop_game()
	await show_final_score()
	
	if current_stage == len(stages)-1:
		await show_winning_message()
		$HUD.hide()
		show_menu()
		return

	$HUD.hide()
	# continue to next stage
	current_stage = current_stage + 1
	start_normal_mode()
