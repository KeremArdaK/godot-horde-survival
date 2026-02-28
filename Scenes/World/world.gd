extends Node2D

# referanslar:
#export candır, bunu kullanarak Inspector üzerinden değerleri kontrol edebiliyom
@export var enemy_scene : PackedScene
@export var indicator_scene : PackedScene

#wave değişkenleri:
var current_wave = 1
var enemies_to_spawn = 5
var enemies_alive =  0

#düşman spawnlamak için map sınırları
var min_x : float = 50.0
var min_y : float = 50.0
var max_x : float = 1102
var max_y : float = 598

func _ready() -> void:
	start_wave()

func start_wave():
	enemies_alive = enemies_to_spawn
	
	for i in range(enemies_to_spawn):
		spawn_indicator()

func spawn_indicator():
	var rand_x = randf_range(min_x, max_x)
	var rand_y = randf_range(min_y, max_y)
	#birden fazla yerde kullanacağımız için bu random pozisyonu bir pakette birleştirelim:
	var spawn_pos = Vector2(rand_x, rand_y)
	#godotta bir şeyi kodla var etmenin kutsal üçlüsü vardır. bunlar instantiate(), position() ve add_child()dır.
	#önce bu indicator_scene'in bir kopyasını var edelim:
	var new_indicator = indicator_scene.instantiate()
	#şimdi yerini belirleyelim:
	new_indicator.position = spawn_pos
	#şimdi de oyunun içine bu kopyayı fırlatalım. bunu yapmazsak sahne var olur ancak oyunda görünmez:
	add_child(new_indicator)
	#bir sayaç kur, 1.5 saniye sürsün ve bitmesini bekle
	await get_tree().create_timer(1.5).timeout
	
	#süre dolduktan sonra kod buradan devam eder#
	new_indicator.queue_free()
	
	#aynı konuma düşmanı koy
	var new_enemy= enemy_scene.instantiate()
	new_enemy.position = spawn_pos
	add_child(new_enemy)

func enemy_died():
	enemies_alive -= 1
	print("Kalan Düşman: ", enemies_alive)
	
	if enemies_alive <= 0:
		next_wave()
	
func next_wave():
	current_wave += 1
	$CanvasLayer/Label.text = str("Wave: ",current_wave)
	enemies_to_spawn = min(enemies_to_spawn + 1, 15)
	
	start_wave()
