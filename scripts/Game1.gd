extends Node2D

onready var path = $Path2d
onready var follow = $Path2D/PathFollow2D
onready var tween = $Tween
onready var holding_porta = $Path2D/PathFollow2D/ColorRect
var index
var bank_offer
var bank_offer_count = 0
var boc_limit = 5
var sample = []
var hold = false
var hold_index
var winnings
var bank_pitch
var porta_index = 0

var portas = 20

func _ready():
	hide()
	$AnimationPlayer.play("fadein")
	show()
	global.last_index = porta_index + 1
	$Path2D/PathFollow2D/EndGame.hide()
	$Path2D/PathFollow2D/LastChance.hide()
	randomize()
	holding_porta.hide()
	$ItemList.portas = portas
	$ItemList.fill()
	bank_pitch = int(portas/5)
	# random sample
	for i in range(portas):
	    sample.append(randi()%10000)


func _process(delta):
	$Path2D/PathFollow2D/ColorRect/Sprite/Offer.text = "Oferta en:\n" + str(boc_limit - bank_offer_count)


func _on_ItemList_item_selected(index):
	self.index = index
	if hold == false:
		hold = true
		hold_index = index
		global.hold = hold_index
		$Path2D/PathFollow2D/ColorRect/Sprite/Index.text = str(index+1)
		holding_porta.show()
		$ItemList.set_item_icon(index, null)
		$ItemList.set_item_selectable(index, false)
		$Label.text = "Elige un portafolio para abrir"
		return
		
	show_selected_porta()
	tween.interpolate_property(follow, "unit_offset", 1, 0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	



func show_selected_porta():
	$Sprite2.hide()
	$Sprite.show()
	$Sprite/Index.text = str(index+1)



func _on_Button_pressed():
	tween.interpolate_property(follow, "unit_offset", 0, 1, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()



func _on_Abrir_pressed():
	$Sprite.hide()
	$Sprite2.show()
	$Sprite2/ColorRect/Label.text = str(sample[index])+"000"
	$ItemList.set_item_icon(index, load("res://textures/porta_cancelado.png"))
	$ItemList.set_item_selectable(index, false)
	bank_offer_count += 1
	portas -= 1
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	tween.interpolate_property(follow, "unit_offset", 0, 1, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if portas == 2:
		while not $ItemList.is_item_selectable(porta_index):
			global.last_index = porta_index + 1
			porta_index += 1
			
		last_choice()
	if bank_offer_count == boc_limit:
		bank_offer()



func bank_offer():
	var offer = sample[hold_index]-bank_pitch
	if offer < 0:
		offer = 1
	$Offer.show_offer(offer)
	if bank_pitch > 1:
		bank_pitch -= 1
	bank_offer_count = 0


func _on_Offer_offer_taken():
	$Offer.hide_offer()
	winnings = $Offer/PathFollow2D/Sprite/Red/ColorRect/Label.text
	endgame()



func _on_Offer_offer_refused():
	bank_offer_count = randi()%5+1
	if bank_offer_count >= portas-2:
		bank_offer_count = portas-2
	$Offer.hide_offer()
	
	
	
func last_choice():
	$Path2D/PathFollow2D/LastChance/Button/Label.text = str(global.hold)
	$Path2D/PathFollow2D/LastChance/Button2/Label2.text = str(global.last_index)
	$Offer.hide()
	$Path2D/PathFollow2D/ColorRect.hide()
	$Path2D/PathFollow2D/LastChance/AnimationPlayer.play("fadein")
	$Path2D/PathFollow2D/LastChance.show()
	

func _on_LastChance_chioce():
	endgame()
	
	
	
func endgame():
	$Path2D/PathFollow2D/EndGame/AnimationPlayer.play("fadein")
	$Path2D/PathFollow2D/EndGame.show()
	$Path2D/PathFollow2D/EndGame/Sprite/ColorRect/Label.text = winnings
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	# TODO: return to main menu


