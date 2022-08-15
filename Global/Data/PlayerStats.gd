extends Node

signal energy_changed
signal health_changed
signal health_depleted
signal watering_can_changed

var energy = 100.0
var health = 100.0
var mana

var energy_maximum = 100.0
var health_maximum = 100.0
var mana_maximum 

func eat(food_name):
	health += JsonData.food_data[food_name]["Health"]
	energy += JsonData.food_data[food_name]["Energy"]
	if health > 100:
		health = 100
	if energy > 100:
		energy = 100
	emit_signal("energy_changed")
	emit_signal("health_changed")


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

