extends CharacterBody2D

@export var speed = 30
@export var limit = 0.5
@export var endPoint: Marker2D
@export var knockBackPower: int = 500

@onready var animations = $AnimationPlayer

var startPosition
var endPosition
var isDead: bool = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection() 
	velocity = moveDirection.normalized()*speed
	
func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animations.play("walk" + direction)
		
	
func _physics_process(_delta):
	if isDead: return
	updateVelocity()
	move_and_slide()
	updateAnimation()

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockBackPower
	velocity = knockbackDirection
	move_and_slide()


func _on_hurt_box_area_entered(area):
	if area == $Hitbox: return
	$Hitbox.set_deferred("monitorable", false)
	knockback(area.gravity_direction)
	isDead = true
	animations.play("death")
	await animations.animation_finished
	queue_free()
