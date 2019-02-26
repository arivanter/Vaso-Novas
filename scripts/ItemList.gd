extends ItemList

var texture = preload("res://textures/porta_cerrado.png")
var portas = 0

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func fill():
	for i in range(self.portas):
		add_item(str(i+1),texture, true)

