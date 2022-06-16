extends Node2D



func _ready():
	set_labels()
	DayNightTimer.connect("advance_day", self, "set_labels")
	DayNightTimer.connect("advance_season", self, "set_labels")

func set_labels():
	$SeasonLabel.text = DayNightTimer.season + ", " + str(DayNightTimer.day)
