extends Node

signal energy_changed

var energy = 100.0
var health
var mana

var energy_maximum = 100.0
var health_maximum
var mana_maximum 


func decrease_energy():
	energy -= 1.0
	emit_signal("energy_changed")

