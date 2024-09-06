@tool
@icon("animated_sprite_2d_state.svg")
class_name AnimatedSprite2DState
extends AtomicState

## Animation player that this state will use.
@export_node_path("AnimatedSprite2D") var animated_sprite_2d: NodePath:
	set(value):
		animated_sprite_2d = value
		update_configuration_warnings()

## The name of the animation that should be played when this state is entered.
## When this is empty, the name of this state will be used.
@export var animation_name: StringName = ""

## A custom speed for the animation. Use negative values to play the animation
## backwards.
@export var custom_speed: float = 1.0

## Whether the animation should be played from the end.
@export var from_end: bool = false

var _animated_sprite_2d: AnimatedSprite2D

func _ready():
	if Engine.is_editor_hint():
		return
		
	super._ready()
	_animated_sprite_2d = get_node_or_null(animated_sprite_2d)

	if not is_instance_valid(_animated_sprite_2d):
		push_error("The animation player is invalid. This node will not work.")

func _state_enter(expect_transition: bool = false):
	super._state_enter()

	if not is_instance_valid(_animated_sprite_2d):
		return

	var target_animation = animation_name
	if target_animation == "":
		target_animation = get_name()
		
	if _animated_sprite_2d.animation == target_animation and _animated_sprite_2d.is_playing():
		return

	_animated_sprite_2d.play(target_animation, custom_speed, from_end)

func _get_configuration_warnings():
	var warnings = super._get_configuration_warnings()

	if animated_sprite_2d.is_empty():
		warnings.append("No animated sprite 2D is set.")
	elif get_node_or_null(animated_sprite_2d) == null:
		warnings.append("The animated sprite 2D path is invalid.")

	return warnings
