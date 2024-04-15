extends Node3D


var arrow_scene = preload("res://scenes/games/minion_battle/objs/minion_archer/arrow.tscn")


func attack(color: String):
  var arrow = arrow_scene.instantiate()
  var material = StandardMaterial3D.new()
  material.albedo_color = Color(color)
  arrow.get_node("mesh/tail").set_surface_override_material(0, material)

  get_tree().get_root().get_node("minion_battle/arrows").add_child(arrow)
  arrow.global_position = $bow/arrow_spawn.global_position
  arrow.rotation = get_parent().rotation
