extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal menu_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_live_score():
	$MenuButton.hide()
	$Score.hide()
	$ScoreLabel.hide()
	$Timer.hide()
	$TimerLabel.hide()

func show_live_score():
	$MenuButton.show()
	$Score.show()
	$ScoreLabel.show()
	$Timer.show()
	$TimerLabel.show()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_final_score(score):	
	hide_live_score()
	show_message(str(score) + " latinhas!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	# Make a one-shot timer and wait for it to finish.
	#await get_tree().create_timer(1.0).timeout

func show_winning_message():	
	hide_live_score()
	show_message("Parabéns!\nO gato comeu.")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

func update_score(score):
	$Score.text = str(score)
	
func update_time(time):
	$Timer.text = str(time)

func _on_message_timer_timeout() -> void:
	$Message.hide()

func _on_menu_button_pressed() -> void:
	menu_pressed.emit()
