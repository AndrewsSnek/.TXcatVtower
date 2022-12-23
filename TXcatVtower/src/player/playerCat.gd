extends overworldCharacter

var direction  := Vector2(0,0)
var airTime    := 0.0
var facing     := 0
var jumpKey    := false
var noClimb    := 0.0
var aniState   := 0
var timeInDir  := 0.0
var enabled    := true
var skyAttacks := 2

var currentAttacks := []
var groundAttack    = preload("res://src/player/attack.tscn")

const gravity    := 1000
const jumpConst  := -250
const fallValues := [-200,-50 , 50 , 200, 500]
const maxSkyAttacks := 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$TempHP.text = str(hp) + "/" + str(maxHp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		aniState = 0
		control()
		
		velocity.x += direction.x * delta * 2000
		velocity = physicsCalulations(delta,velocity)
		
		jump()
		actions()
		move_and_slide()
		
		facingStuff(delta)
		animation()
		

func physicsCalulations(delta, vel) -> Vector2:
	var delta300 = delta * 300
	if !is_on_floor():
		airTime += delta
		aniState = 3
	else:
		airTime = 0
		skyAttacks = maxSkyAttacks
	
	vel.y += gravity * delta
	vel.x *= 0.9563524998 ** delta300 # TARGET ~0.8
	
	facing = -1 if vel.x < 0 else facing
	facing = 1 if vel.x > 0 else facing
	
	if is_on_wall_only():
		#gFrames =  0
		#animaniState = 1
		vel.y -= (gravity * delta * 0.975)# + abs(vel.x)
		vel.y *= 0.9959676105 ** delta300 # TAGET ~ 0.98
		#vel.y  = lerp(vel.y, 0, 0.02)
		vel.x  = 10 * facing
		aniState  = 4
		if Input.is_action_pressed("down"):
			vel.y += 5
			
		if Input.is_action_pressed("jump") and not jumpKey and noClimb <= 0:
			vel.y = jumpConst
			jumpKey = true
			vel.x = jumpConst * facing * 1.5
			noClimb = 0.5
			skyAttacks = maxSkyAttacks
	noClimb -= delta
	
	return vel

func control():
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	aniState = 1 if abs(direction.x) >= 0.2 else aniState

func jump():
	if airTime <= 0.05 and Input.is_action_just_pressed("jump") and !jumpKey:
		jumpKey = true
		velocity.y = jumpConst * 0.8
	elif airTime <= 0.15 and Input.is_action_pressed("jump"):
		velocity.y = jumpConst * 0.8 if velocity.y >= jumpConst * 0.8 else velocity.y
	
	if !Input.is_action_pressed("jump"):
		jumpKey = false

func actions():
	if airTime <= 0.05:
		Attack(2)
	else:
		Attack(1)

func Attack(multiplier :int):
	if Input.is_action_just_pressed("action") and skyAttacks > 0:
		velocity = Vector2(300 * facing, -100)
		currentAttacks.append(groundAttack.instantiate())
		currentAttacks[-1].multiplier = multiplier
		currentAttacks[-1].setFacing(facing)
		add_child(currentAttacks[-1])
		skyAttacks -= 1

func facingStuff(delta):
	if facing == 1:
		if timeInDir >= 0:
			timeInDir += delta
		else:
			timeInDir = 0
	elif facing == -1:
		if timeInDir <= 0:
			timeInDir -= delta
		else:
			timeInDir = 0

func _damageRecieved(amount :int) -> void:
	hp -= amount
	$TempHP.text = str(hp) + "/" + str(maxHp)

func animation():
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	if aniState == 0:
		$AP.play("IDLE")
	elif aniState == 1:
		if abs(timeInDir) >= 1:
			$AP.play("run")
		else:
			$AP.play("walk")
	elif aniState == 3:
		$AP.play("MANUAL")
		$Sprite2D.frame = 24
		for x in fallValues:
			if velocity.y >= x:
				$Sprite2D.frame += 1
	elif aniState == 4:
		if facing == 1:
			$Sprite2D.flip_h = false
		elif facing == -1:
			$Sprite2D.flip_h = true
		if velocity.y <= 0:
			$AP.play("climbRun")
		else:
			$AP.play("climbWalk")

