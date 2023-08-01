extends RigidBody3D
var health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	pass # Replace with function body.
	var player = get_tree().get_nodes_in_group("Players")[0]#get_node("../Player")
	#print(player.has_signal("hit"))
	player.hit.connect(gothit)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func gothit(id,dmg,direction):
	print(id)
	if id[0] == self:
		#apply_impulse(Vector3(direction[0]*5,direction[1]*5,10),Vector3(0,0,0))
		print("hitme!")
		health -= dmg

	if health < 1:
		queue_free()
	pass
	
