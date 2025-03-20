extends Node

@onready var planets = $Planets
@onready var tab_container = $CanvasLayer/TabContainer

const tab = preload("res://tab.tscn")
const object = preload("res://object.tscn")

enum MODES {
	PLANET_VIEW,
	ORBIT_VIEW,
}

var mode = MODES.PLANET_VIEW

	
var objects = []

func _ready():
	objects.append_array(planets.get_children())

	var planet_data = read_json_file("res://data/data.json")
	for planet_name in planet_data["Planets"].keys():
		var planet = planet_data["Planets"][planet_name]
		spawn_object(planet_name, planet)

func _unhandled_key_input(event):
	if event.is_action("quit"):
		get_tree().quit()

func spawn_object(planet_name, planet):
	var object_instance = object.instantiate()
	object_instance.name = planet_name
	object_instance.mass = planet["MASS kg"]
	object_instance.radius = planet["RADIUS km"]
	object_instance.type = planet["TYPE"]
	
	if planet_name == "Sun":
		object_instance.freeze = true
	else:
		object_instance.position = Vector3(planet["X km"],planet["Y km"],planet["Z km"])
		object_instance.linear_velocity = Vector3(planet["VX km/s"],planet["VX km/s"],planet["VX km/s"])
		
	objects.append(object_instance)
	planets.add_child(object_instance)
	create_tab(object_instance)

func parse_json(json_string):
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			print(data_received) # Prints array
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

func read_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = JSON.parse_string(content_as_text)
	return content_as_dictionary

func create_tab(object_instance):
	var new_tab = tab.instantiate()
	new_tab.name = object_instance.name
	tab_container.add_child(new_tab)


func _on_option_button_item_selected(index):

	print(mode)
