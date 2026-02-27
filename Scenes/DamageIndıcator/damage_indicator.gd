extends Node2D

func _ready() -> void:
	var tween = create_tween()
	
	#yazıyı 0.5 saniye içinde 30 piksel yukarı kaldır
	tween.tween_property(self, "position", position - Vector2(0, 30.0), 0.5).set_ease(Tween.EASE_OUT)
	
	#aynı anda saydamlığı (alphayı) 0'a çek
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(queue_free)

func set_damage(amount:int):
	$Label.text = str(amount)
