tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	draw_circle(Vector2(30, 20), 10.0, Color.blue)

	draw_line(Vector2(10, 10), Vector2(100, 200), Color.white, 2.0, true)
