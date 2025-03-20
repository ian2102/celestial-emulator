extends RigidBody3D

var G = 6.6743 * pow(10, -7) # -11

@export var initial_velocity = Vector3(0,0,0)

var force_mag_sun = 0
var force_sun = Vector3(0,0,0)
var distance_from_sun = 0
var type = null
var radius = 1.0

func _ready():
	linear_velocity = initial_velocity

func _process(_delta):
	for object in get_tree().root.get_child(0).objects:
		apply_gravity(object)

func apply_gravity(otherbody):
		if otherbody != self:
				
			var otherbodyMass = otherbody.mass
			var direction = position - otherbody.position
			var distance = direction.length()
			
			if distance != 0:  # To avoid division by zero
				var forceMag = G * ((mass * otherbodyMass) / (distance * distance))
				var force = direction.normalized() * forceMag
				if otherbody.name == "Sun":
					force_mag_sun = forceMag
					force_sun = force
					distance_from_sun = distance
				apply_central_force(-force)
