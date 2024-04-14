extends StaticBody3D

var spawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
  spawnPoint = $fabricator/spawnPoint
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_area_3d_area_entered(area):
  print("spawning")
  spawnPoint.transform.origin.y = 2
  pass # Replace with function body.
