extends CanvasLayer

var player_ref : CharacterBody2D = null

func _ready() -> void:
	get_tree().paused = true

func setup(player:CharacterBody2D):
	player_ref = player


func _on_can_pressed() -> void:
	player_ref.max_hp += 20
	player_ref.hp += 20
	close_menu()


func _on_hız_pressed() -> void:
	player_ref.speed += 5.0
	close_menu()


func _on_hasar_pressed() -> void:
	player_ref.base_damage += 5
	close_menu()

func close_menu():
	get_tree().paused = false
	queue_free()
