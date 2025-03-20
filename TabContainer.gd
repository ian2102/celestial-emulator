extends TabContainer

@onready var planet_info = $"../../PlanetInfo"
@onready var planet_label_3d = $"../../Label3D"

@onready var planet_gaseous = $"../../Views/PlanetGaseous"
@onready var planet_ice = $"../../Views/PlanetIce"
@onready var planet_lava = $"../../Views/PlanetLava"
@onready var planet_no_atmosphere = $"../../Views/PlanetNoAtmosphere"
@onready var planet_sand = $"../../Views/PlanetSand"
@onready var planet_terrestrial = $"../../Views/PlanetTerrestrial"
@onready var star = $"../../Views/Star"

@onready var stars = $"../../Stars"

@onready var current_view = planet_no_atmosphere
var current_tab_name = ""

func _ready():
	pass


func _process(_delta):
	var current_tab_node = get_current_tab_control()
	var planet_name = current_tab_node.name
	
	
	var planet = get_node_or_null("../../Planets/" + planet_name)
	var label = current_tab_node.get_node_or_null("ScrollContainer/Label")
	
	if planet and label:
		if current_tab_name != planet_name:
			current_tab_name = planet_name
			planet_label_3d.text = planet_name
			switch_view(planet.type)
		
		var label_text = "Planet Name: " + planet_name + "\n"
		label_text += "Fg mag of Sun: " + str(planet.force_mag_sun) + "\n"
		label_text += "Force of Sun: " + str(planet.force_sun) + "\n"
		label_text += "Distance from Sun: " + str(planet.force_sun) + "\n"
		label_text += "Inertia: " + str(planet.inertia) + "\n"
		label_text += "Mass: " + str(planet.mass) + "\n"
		label_text += "Position: " + str(planet.position) + "\n"
		label_text += "Center of Mass: " + str(planet.center_of_mass) + "\n"
		label_text += "Radius: " + str(planet.radius) + "\n"
		label_text += "\n" + "\n"
			
		var data = planet_info.planet_data[planet_name]
		for key in data.keys():
			var value = data[key]
			label_text += "%s: %s\n" % [key, value]
		
		label.text = label_text

func switch_view(type):
	stars.position = Vector3(0.0,100.0,0.0)
	current_view.hide()
	match type:
		"planet_gaseous":
			current_view = planet_gaseous
		"planet_ice":
			current_view = planet_ice
		"planet_lava":
			current_view = planet_lava
		"planet_no_atmosphere":
			current_view = planet_no_atmosphere
		"planet_sand":
			current_view = planet_sand
		"planet_terrestrial":
			current_view = planet_terrestrial
		"star":
			current_view = star
			stars.position = Vector3(0.0,0.0,0.0)

	current_view.show()
