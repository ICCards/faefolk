extends ConditionLeaf


func tick(actor, blcakboard):
	var geniusTeritory : Area2D = actor.targetArea
	if geniusTeritory.overlaps_body(actor.player):
		return SUCCESS
	else:
		return FAILURE
