extends Area2D

@export var target_level : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if ( body.name == "CharacterBody2D"):
		get_tree().change_scene_to_packed(target_level)
