extends CharacterBody2D

@export var bullet_scene : PackedScene
var atis_sayaci = 0.0
var atis_hizi = 1.0

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction: 
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	move_and_slide()
	
	atis_sayaci += delta
	if atis_sayaci >= atis_hizi:
		atis_sayaci = 0.0
		ates_et()
func find_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	#ekranda düşman yoksa boş dön
	if enemies.is_empty():
		return
	var en_yakin = enemies[0]
	
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) < global_position.distance_to(en_yakin.global_position):
			en_yakin = enemy
	
	return en_yakin

func ates_et():
	var hedef = find_nearest_enemy()
	
	if hedef != null:
		#1: Mermiyi yarat
		var yeni_mermi = bullet_scene.instantiate()
		#Merminin çıkış noktası
		yeni_mermi.global_position = global_position
		#Yönü hesapla
		yeni_mermi.direction = (hedef.global_position - global_position).normalized()
		#sahneye ekle
		get_tree().current_scene.add_child(yeni_mermi)
