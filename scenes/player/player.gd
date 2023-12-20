extends CharacterBody2D

signal healthChanged

@export var speed: int = 35
@export var maxHealth: int = 3

@onready var animations = $AnimationPlayer
@onready var currentHealth: int = maxHealth
@onready var hurtColor = $Sprite2D/ColorRect


func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animations.play("walk" + direction)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func _physics_process(_delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()


func _on_hurt_box_area_entered(area):
	if area.name == "Hitbox":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth
		healthChanged.emit(currentHealth)
