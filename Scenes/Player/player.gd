extends CharacterBody2D

@export var bullet_scene : PackedScene
@export var xp_bar : ProgressBar
@export var health_bar : ProgressBar
@export var level_up_menu_scene : PackedScene 
var is_invincible: bool = false
var max_hp = 100.0
var hp = 100.0
var base_damage = 100.0
var atis_sayaci = 0.0
var atis_hizi = 1.0
var level:int=1
var current_xp: int = 0
var xp_to_next_level:int = 100
var unspent_skill_points: = 0

var speed = 300.0

func _ready() -> void:
	update_health_bar()

func update_health_bar():
	if health_bar != null:
		health_bar.max_value = max_hp
		health_bar.value = hp
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction: 
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	move_and_slide()
	
	atis_sayaci += delta
	if atis_sayaci >= atis_hizi:
		atis_sayaci = 0.0
		ates_et()
	
	check_enemy_collisions()

func check_enemy_collisions():
	if is_invincible : return
	
	var overlapping_bodies = $Hurtbox.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("enemy"):
			take_damage(10)
			break
	
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
		yeni_mermi.damage = base_damage
		#sahneye ekle
		get_tree().current_scene.add_child(yeni_mermi)
		

func gain_xp(amount:int):
	current_xp += amount
	
	if current_xp >= xp_to_next_level:
		level_up()
	update_xp_bar()

func level_up():
	current_xp -= xp_to_next_level
	level += 1
	unspent_skill_points += 1
	
	xp_to_next_level = int(xp_to_next_level * 1.5)
	open_level_up_menu()

func update_xp_bar():
	if xp_bar != null:
		xp_bar.max_value = xp_to_next_level
		xp_bar.value = current_xp

func open_level_up_menu():
	if level_up_menu_scene != null:
		var menu = level_up_menu_scene.instantiate()
		get_tree().current_scene.add_child(menu)
		menu.setup(self)

func take_damage(amount:int):
	hp -= amount
	update_health_bar()
	
	is_invincible = true
	modulate = Color.RED
	await get_tree().create_timer(0.5).timeout
	
	is_invincible = false
	modulate = Color.DARK_BLUE
