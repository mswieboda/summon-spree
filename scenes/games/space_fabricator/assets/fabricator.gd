extends StaticBody3D
#spawn point Y = 2 when out of way and 0.5 when testing
var spawnX
var spawnZ
var spawnY

var spawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
  spawnPoint = get_node("spawnPoint")
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_timer_timeout():
  spawnX = randi_range(-19,0)
  spawnZ = randi_range(-7,7)
  spawnY = 0.5
  spawnPoint.transform.origin = Vector3(spawnX,spawnY,spawnZ)
  print(Vector3(spawnX,spawnY,spawnZ))
  pass # Replace with function body.
