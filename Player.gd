extends CharacterBody3D
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var canattack = true 
@export var inventory_data: InventoryData
@onready var inventory = $"../UI/InventoryInterface"
@onready var player = $"."
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
signal hit(body,damage) 
signal toggle_inventory()

var direction

func _ready():
	add_to_group("Players")
	inventory.set_player_inventory_data(self.inventory_data)
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
			
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("LClick") and is_on_floor() and (canattack == true):
		print($Neck/AttackBox.get_overlapping_bodies().size())
		canattack = false
		if $Neck/AttackBox.get_overlapping_bodies().size() >= 1:
			print("hit")
			hit.emit($Neck/AttackBox.get_overlapping_bodies(),1,direction)
		$Timer.start()
		pass
	if Input.is_action_just_pressed("Inventory"):
		inventory.visible = not inventory.visible
		
		if inventory.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			#toggle_inventory.emit()

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()	

func _on_timer_timeout():
	canattack = true
