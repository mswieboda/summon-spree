extends Area3D

var speed = 25

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  global_transform.origin += global_transform.basis.z * speed * delta


func _on_body_entered(body):
  if body.name.contains("enemy"):
    body.do_damage()
    pass
  get_parent().get_parent().despawn(self)
  pass # Replace with function body.

