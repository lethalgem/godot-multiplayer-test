class_name Card extends Node2D

@export var area_2d: Area2D
@export var collision_2d: CollisionPolygon2D

signal card_hover_active
signal card_hover_inactive

var hand_position

func _ready():
	#This will get card manager
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered():
	emit_signal("card_hover_active", self)

func _on_area_2d_mouse_exited():
	emit_signal("card_hover_inactive", self)
