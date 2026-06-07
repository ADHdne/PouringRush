extends Resource
class_name ImpactData

enum SurfaceType {
	WALL,
	CEILING,
	FLOOR
}


var normal : Vector2
var velocity : Vector2
var surface_type : SurfaceType

var speed_into_surface : float
