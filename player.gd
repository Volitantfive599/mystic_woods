extends CharacterBody2D

class_name Player
signal got_hit

var run_speed = 75
var attacking = false
var input
enum states {IDLE, RUN, ATTACK, DEAD, HURT}
var state = states.IDLE
var health = 3

func _physics_process(delta):
	choose_action()
	move_and_slide()
	
	
func choose_action():
	$Label.text = states.keys()[state]
	
	match state:
		states.DEAD:
			$AnimationPlayer.play("death")
			set_physics_process(false)
			$CollisionShape2D.disabled = true
			
		states.IDLE:
			velocity = Vector2.ZERO
			$AnimationPlayer.play("idle")
			
		states.RUN:
			input = Input.get_vector("left", "right", "up", "down")
			velocity = input * run_speed
			if velocity.x != 0:
				transform.x.x = sign(velocity.x)
			$AnimationPlayer.play("run")
			if velocity == Vector2.ZERO:
				state = states.IDLE

			
		states.ATTACK:
			velocity = Vector2.ZERO
			$AnimationPlayer.play("attack")
			await $AnimationPlayer.animation_finished
			attacking = false
			state = states.IDLE
			
		states.HURT:
			pass


func _input(event):
	if event.is_action_pressed("attack"):
		attacking = true
		state = states.ATTACK
	if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up") or event.is_action_pressed("down"):
		if !attacking:
			state = states.RUN


func hurt(amount, dir):
	health -= amount
	got_hit.emit(health)
	velocity = dir * 100
	var prev_state = state
	state = states.HURT
	await get_tree().create_timer(0.2).timeout
	state = prev_state
	if health <= 0:
		state = states.DEAD


func _on_hurt_box_body_entered(body):
	body.hurt(1, position.direction_to(body.position))
