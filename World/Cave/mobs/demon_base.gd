extends Node

class_name Task

# States
enum {
	BIRTH,
	ROAMING,
	CHASING,
	FIGHTING,
	WINNING,
	DEATH,
}

var control = null
var tree = null
var guard = null
var status = BIRTH

# Final methods
func running():
	status = ROAMING
	if control != null:
		control.child_running()

func success():
	status = WINNING
	if control != null:
		control.child_success()

func fail():
	status = FAILED
	if control != null:
		control.child_fail()

func cancel():
	if status == ROAMING:
		status = DEATH
		# Cancel child tasks
		for child in get_children():
			child.cancel()

# Abstract methods
func run():
	# Process the task and call running(), success(), or fail()
	pass

func child_success():
	pass

func child_fail():
	pass

func child_running():
	pass

# Non-final non-abstact methods
func start():
	status = BIRTH
	for child in get_children():
		child.control = self
		child.tree = self.tree
		child.start()

func reset():
	cancel()
	status = BIRTH
