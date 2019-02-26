extends Node2D

func _ready():
	pass


func _on_Button_pressed():
	$AnimationPlayer.play("fadeout")
	var t = Timer.new()
	t.set_wait_time(.6)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	get_tree().change_scene("res://scenes/Game1.tscn")
