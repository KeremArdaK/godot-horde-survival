extends CharacterBody2D

@export var damage_indicator_scene : PackedScene
const SPEED : float = 150.0
var player = null
var health = 100
var is_dead : bool = false


func _ready() -> void:
	#düşman doğar doğmaz player grubundan player'ı çek
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player!= null:
		#karakterin yönünü bul:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()

func take_damage(amount:int, bullet_dir:Vector2):
	if is_dead : return
	health -= amount
	if damage_indicator_scene != null:
		var indicator = damage_indicator_scene.instantiate()
		indicator.global_position = global_position
		indicator.set_damage(amount)
		get_tree().current_scene.add_child(indicator)
		
	modulate = Color.WHITE
	
	var tween = create_tween()
	var target_pos = global_position + (bullet_dir * 25.0)
	tween.tween_property(self, "global_position", target_pos, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	if health <= 0:
		is_dead = true
		
		if player != null and player.has_method("gain_xp"):
			player.gain_xp(25)
		if get_parent().has_method("enemy_died"):
			get_parent().enemy_died()
		queue_free()
	else:
		await get_tree().create_timer(0.1).timeout
		modulate = Color.RED
