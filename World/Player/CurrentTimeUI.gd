extends Node2D



func _ready():
	set_labels()
	DayNightTimer.connect("advance_day", self, "set_labels")
	DayNightTimer.connect("advance_season", self, "set_labels")

func set_labels():
	$DayLabel.text = str(DayNightTimer.day)
	$SeasonLabel.text = DayNightTimer.season
