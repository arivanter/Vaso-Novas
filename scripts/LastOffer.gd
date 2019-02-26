extends Node2D

signal chioce



func _ready():
	pass
	
	
	
func _process(delta):
	if $ColorRect/AnimationPlayer.current_animation != "color_change":
		$ColorRect/AnimationPlayer.play("color_change")


func _on_Button_pressed():
	get_node("/root/Game1").winnings = str(get_node("/root/Game1").sample[get_node("/root/Game1").hold_index]) + "000"
	emit_signal("chioce")


func _on_Button2_pressed():
	get_node("/root/Game1").winnings = str(randi()%100) + "000"
	emit_signal("chioce")
