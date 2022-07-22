extends Node

signal energy_changed
signal health_changed

var energy = 100.0
var health = 100.0
var mana

var energy_maximum = 100.0
var health_maximum = 100.0
var mana_maximum 


func decrease_health():
	if health >= 10:
		health -= 10.0
		emit_signal("health_changed")

func decrease_energy():
	if energy >= 1:
		energy -= 1.0
		emit_signal("energy_changed")

