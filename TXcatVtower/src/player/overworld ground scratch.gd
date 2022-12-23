extends overworldAttack

func _ready():
	multiplier = 1
	baseDamage = 1

func setFacing(value :int):
	if value >= 0:
		$sprite.flip_h = false
	elif value <= 0:
		$sprite.flip_h = true

func _on_collider_body_entered(body):
	if body.is_type("overworldCharacter"):
		body.damage(attack(0))

func _on_ap_animation_finished(anim_name):
	$collider/CollisionShape2D.disabled = true
	queue_free()
