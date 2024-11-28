extends StaticBody3D

func open():
  collision_layer = 0
  hide()

func close():
  collision_layer = 1
  show()
