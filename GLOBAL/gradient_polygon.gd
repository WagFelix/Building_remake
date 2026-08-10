extends Polygon2D

@export var cor_top    : Color = Color.WHITE
@export var cor_middle : Color = Color.GRAY
@export var cor_bottom : Color = Color.BLACK

@export var usar_cor_central: bool = false

# Orientações:
# 0 = Vertical
# 1 = Horizontal
# 2 = Diagonal ↘
# 3 = Diagonal ↗
# 4 = Diagonal ↙
# 5 = Diagonal ↖
@export_enum("Vertical", "Horizontal", "Diagonal ↘", "Diagonal ↗", "Diagonal ↙", "Diagonal ↖")
var orientacao:int = 0

# Largura da textura gerada
@export var tex_width:int = 256


func _ready() -> void:
	_aplicar_gradiente()


func _notification(what):
	if Engine.is_editor_hint():
		if what == NOTIFICATION_POSTINITIALIZE:
			_aplicar_gradiente()


func _aplicar_gradiente() -> void:
	if polygon.size() < 3:
		return

	# --- Criar gradiente ---
	var grad := Gradient.new()

	if usar_cor_central:
		grad.colors = [cor_top, cor_middle, cor_bottom]
		grad.offsets = [0.0, 0.5, 1.0]
	else:
		grad.colors = [cor_top, cor_bottom]
		grad.offsets = [0.0, 1.0]

	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.width = tex_width

	# --- Orientação ---
	match orientacao:
		0: # Vertical
			tex.fill_from = Vector2(0, 0)
			tex.fill_to   = Vector2(0, 1)

		1: # Horizontal
			tex.fill_from = Vector2(0, 0)
			tex.fill_to   = Vector2(1, 0)

		2: # Diagonal ↘
			tex.fill_from = Vector2(0, 0)
			tex.fill_to   = Vector2(1, 1)

		3: # Diagonal ↗
			tex.fill_from = Vector2(0, 1)
			tex.fill_to   = Vector2(1, 0)

		4: # Diagonal ↙
			tex.fill_from = Vector2(1, 0)
			tex.fill_to   = Vector2(0, 1)

		5: # Diagonal ↖
			tex.fill_from = Vector2(1, 1)
			tex.fill_to   = Vector2(0, 0)

	texture = tex

	# UV perfeito
	_gerar_uv(tex)


func _gerar_uv(tex: Texture2D) -> void:
	var pts = polygon
	if pts.size() == 0:
		return

	var aabb = Rect2(pts[0], Vector2.ZERO)
	for p in pts:
		aabb = aabb.expand(p)

	var aabb_size = aabb.size
	if aabb_size.x == 0: aabb_size.x = 1
	if aabb_size.y == 0: aabb_size.y = 1

	var tex_size = Vector2(1, 1)
	if tex:
		tex_size = tex.get_size()

	var uvs: PackedVector2Array = PackedVector2Array()
	for p in pts:
		var local = p - aabb.position
		var u_norm = local.x / aabb_size.x
		var v_norm = local.y / aabb_size.y
		var uv_px = Vector2(u_norm * tex_size.x, v_norm * tex_size.y)
		uvs.append(uv_px)

	uv = uvs
