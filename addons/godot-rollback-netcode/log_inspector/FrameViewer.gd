tool
extends Control

const Logger = preload("res://addons/godot-rollback-netcode/Logger.gd")
const ReplayServer = preload("res://addons/godot-rollback-netcode/log_inspector/ReplayServer.gd")
const LogData = preload("res://addons/godot-rollback-netcode/log_inspector/LogData.gd")

onready var time_field = $VBoxContainer/HBoxContainer/Time
onready var seek_on_replay_peer_field = $VBoxContainer/HBoxContainer/SeekOnReplayPeerField
onready var auto_replay_to_current_field = $VBoxContainer/HBoxContainer/ReplayContainer/HBoxContainer/AutoReplayToCurrentField
onready var data_graph = $VBoxContainer/VSplitContainer/DataGraph
onready var data_grid = $VBoxContainer/VSplitContainer/DataGrid
onready var settings_dialog = $SettingsDialog

var log_data: LogData
var replay_server: ReplayServer
var replay_peer_id: int
var replay_frame: int = -1

var current_frames := {}
var _replay_peer_id: int

func set_log_data(_log_data: LogData) -> void:
	log_data = _log_data
	data_graph.set_log_data(log_data)
	data_grid.set_log_data(log_data)
	settings_dialog.setup_settings_dialog(log_data, data_graph, data_grid)

func refresh_from_log_data() -> void:
	if log_data.is_loading():
		return
	
	time_field.max_value = log_data.end_time - log_data.start_time
	
	data_graph.refresh_from_log_data()
	data_grid.refresh_from_log_data()
	settings_dialog.refresh_from_log_data()
	
	_on_Time_value_changed(time_field.value)

func set_replay_server(_replay_server: ReplayServer) -> void:
	replay_server = _replay_server

func set_replay_peer_id(_replay_peer_id: int) -> void:
	replay_peer_id = _replay_peer_id

func refresh_replay() -> void:
	pass

func clear() -> void:
	current_frames.clear()
	refresh_from_log_data()

func _on_Time_value_changed(value: float) -> void:
	if log_data.is_loading():
		return
	
	var time := int(value)
	
	# Update our tracking of the current frame.
	for peer_id in log_data.peer_ids:
		var frame: LogData.FrameData = log_data.get_frame_by_time(peer_id, log_data.start_time + time)
		if frame:
			current_frames[peer_id] = frame.frame
	
	data_graph.cursor_time = time
	data_grid.cursor_time = time

func _on_PreviousFrameButton_pressed() -> void:
	jump_to_previous_frame()

func jump_to_previous_frame() -> void:
	if log_data.is_loading():
		return
	
	var frame_time := 0
	
	if seek_on_replay_peer_field.pressed:
		frame_time = _get_previous_frame_time_for_peer(replay_peer_id)
	else:
		for peer_id in current_frames:
			frame_time = int(max(frame_time, _get_previous_frame_time_for_peer(peer_id)))
	
	if frame_time > log_data.start_time:
		time_field.value = frame_time - log_data.start_time
	else:
		time_field.value = 0

func _get_previous_frame_time_for_peer(peer_id: int) -> int:
	var frame_id = current_frames[peer_id]
	if frame_id > 0:
		frame_id -= 1
	var frame: LogData.FrameData = log_data.get_frame(peer_id, frame_id)
	return frame.start_time

func _on_NextFrameButton_pressed() -> void:
	jump_to_next_frame()

func jump_to_next_frame() -> void:
	if log_data.is_loading():
		return
	
	var frame_time := log_data.end_time
	
	if seek_on_replay_peer_field.pressed:
		frame_time = _get_next_frame_time_for_peer(replay_peer_id)
	else:
		for peer_id in current_frames:
			var peer_frame_time = _get_next_frame_time_for_peer(peer_id)
			if peer_frame_time != 0:
				frame_time = int(min(frame_time, _get_next_frame_time_for_peer(peer_id)))
	
	if frame_time > log_data.start_time:
		time_field.value = frame_time - log_data.start_time
	else:
		time_field.value = 0

func _get_next_frame_time_for_peer(peer_id: int) -> int:
	var frame_id = current_frames[peer_id]
	if frame_id < log_data.get_frame_count(peer_id) - 1:
		frame_id += 1
		var frame: LogData.FrameData = log_data.get_frame(peer_id, frame_id)
		return frame.start_time
	return 0

func replay_to_current_frame() -> void:
	if not replay_server and not replay_server.is_connected_to_game():
		return
	if log_data.is_loading():
		return
	if log_data.peer_ids.size() == 0:
		return
	
	var current_frame: LogData.FrameData = current_frames[replay_peer_id]
	
	if replay_frame == current_frame.frame - 1:
		_send_replay_frame_data(current_frame)
	else:
		replay_server.send_match_info(log_data, replay_peer_id)
		for frame_id in log_data.frames:
			if frame_id > current_frame.frame:
				break
			var frame_data: LogData.FrameData = log_data.frames[frame_id]
			_send_replay_frame_data(frame_data)
	
	replay_frame = current_frame.frame

func _send_replay_frame_data(frame_data: LogData.FrameData) -> void:
	# TODO: send frame data to replay client.
	pass

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.pressed:
		if event.scancode == KEY_PAGEUP:
			jump_to_next_frame()
		elif event.scancode == KEY_PAGEDOWN:
			jump_to_previous_frame()
		elif event.scancode == KEY_UP:
			time_field.value += 1
		elif event.scancode == KEY_DOWN:
			time_field.value -= 1

func _on_StartButton_pressed() -> void:
	time_field.value = 0

func _on_EndButton_pressed() -> void:
	time_field.value = time_field.max_value

func _on_DataGraph_cursor_time_changed(cursor_time) -> void:
	time_field.value = cursor_time

func _on_SettingsButton_pressed() -> void:
	settings_dialog.popup_centered()

func _on_ReplayToCurrentButton_pressed() -> void:
	replay_to_current_frame()
