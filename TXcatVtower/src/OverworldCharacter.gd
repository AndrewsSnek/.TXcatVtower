class_name overworldCharacter extends CharacterBody2D

var hp     :int    = 10
var maxHp  :int    = 10
var attack :float  = 1.0

signal damageRecieved

func damage(amount :int) -> void:
	hp -= hp
	emit_signal("damageRecieved")


func is_type(type): return type == "overworldCharacter" #or .is_type(type)
func    get_type(): return "overworldCharacter"
