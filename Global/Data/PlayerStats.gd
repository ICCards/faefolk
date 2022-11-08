extends Node

signal mana_changed
signal energy_changed
signal health_changed
signal health_depleted
signal watering_can_changed

var energy = 100.0
var health = 100.0
var mana = 100.0

var energy_maximum = 100.0
var health_maximum = 100.0
var mana_maximum = 100.0

func _ready():
	start_mana_timer()
	
func start_mana_timer():
	yield(get_tree().create_timer(2.0), "timeout")
	if mana != 100:
		mana += 4
		emit_signal("mana_changed")
	start_mana_timer()


func eat(food_name):
	energy += JsonData.item_data[food_name]["EnergyHealth"][0]
	health += JsonData.item_data[food_name]["EnergyHealth"][1]
	if health > 100:
		health = 100
	if energy > 100:
		energy = 100
	emit_signal("energy_changed")
	emit_signal("health_changed")

func decrease_mana(amount):
	mana -= amount
	if mana <= 0:
		mana = 0
	emit_signal("mana_changed")

func decrease_health(amount):
	health -= amount
	if health <= 0:
		health = 0
		emit_signal("health_depleted")
	emit_signal("health_changed")

func increase_health(amount):
	health += amount
	if health >= 100:
		health = 100
	emit_signal("health_changed")

func decrease_energy():
	if energy >= 1:
		energy -= 1.0
		emit_signal("energy_changed")

