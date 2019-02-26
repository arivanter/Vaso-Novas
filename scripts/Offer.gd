extends Path2D

onready var offer_label = $PathFollow2D/Sprite/Red/ColorRect/Label
onready var follow = $PathFollow2D
onready var tween = $Tween
signal offer_taken
signal offer_refused



func _ready():
	pass



func show_offer(offer):
	if offer == 0:
		offer = 1
	offer_label.text = str(offer) + '000'
	tween.interpolate_property(follow, "unit_offset", 0, .9999, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()



func hide_offer():
	tween.interpolate_property(follow, "unit_offset", .9999, 0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()



func _on_RedButton_pressed():
	emit_signal('offer_taken')
	hide_offer()



func _on_BlueButton_pressed():
	emit_signal('offer_refused')
	hide_offer()


