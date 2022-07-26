extends Node

signal energy_changed
signal health_changed
signal health_depleted
signal watering_can_changed

var energy = 100.0
var health = 10.0
var mana

var energy_maximum = 100.0
var health_maximum = 100.0
var mana_maximum 

var watering_can_maximum = 25.0
var watering_can = 12.0


func refill_watering_can():
	watering_can = watering_can_maximum
	emit_signal("watering_can_changed")

func decrease_watering_can():
	watering_can -= 1
	if watering_can <= 0:
		watering_can = 0
	emit_signal("watering_can_changed")


func decrease_health(amount):
	health -= amount
	if health <= 0:
		health = 0
		emit_signal("health_depleted")
	emit_signal("health_changed")

func decrease_energy():
	if energy >= 1:
		energy -= 1.0
		emit_signal("energy_changed")

