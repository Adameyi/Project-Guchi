extends Node2D

@onready var tool_ui_slot: TextureButton = $"../Player/CharacterBody2D/Hotbar/Tool_Slot/Tool_UI_Slot"
@onready var inventory: Inventory = preload('res://inventory/player_inventory.tres')
@onready var hotbar_slots = $"../Player/CharacterBody2D/Hotbar/Slots"

const SUNFLOWER_SEED = preload("uid://cmbrlfmdn2o2g")


@onready var grass: TileMapLayer = $Grass
@onready var dirt: TileMapLayer = $Dirt
@onready var hover_sprite: AnimatedSprite2D = $HoverSprite
@export var crop_scene: PackedScene

#Track which tile was last hovered to avoid anim restart.
#Impossible coordinate so first real tile always counts as 'new'.
var last_hovered := Vector2i(-9999,-9999)

#Vector2i -> Crop node
var planted_crops := {}

func _ready() -> void:
	hover_sprite.hide()
	
func _process(_delta):
	
	#Get mouse position in Grass' local coord space (not screens-space).
	var mouse_pos = grass.get_local_mouse_position()
	
	#Convert pixel position to grid coords (e.g., (3,5))
	var tile_coords = grass.local_to_map(mouse_pos)
	
	#Check if there's a valid tile placed at these coords (returns -1 if empty).
	if grass.get_cell_source_id(tile_coords) != -1:
		hover_sprite.position = dirt.map_to_local(tile_coords)
		hover_sprite.show()
		
		#Only trigger the animation when we've moved to a DIFFERENT tile
		if tile_coords != last_hovered:
			hover_sprite.play('hover')
			last_hovered = tile_coords
	
		if Input.is_action_just_pressed('left_click'):
			if tool_ui_slot.getCurrentTool() == 'Hoe':
				place_crop(tile_coords)
			elif tool_ui_slot.getCurrentTool() == 'Watering_Can':
				water_crop(tile_coords)
		if Input.is_action_just_pressed('right_click'):
			plant_seed(tile_coords)
	else:
		hover_sprite.hide()
		last_hovered = Vector2i(-9999,-9999)

func place_crop(tile_coords: Vector2i):
		if planted_crops.has(tile_coords):
			return # already indexed/occupied
			
		var crop = crop_scene.instantiate()
		crop.global_position = grass.map_to_local(tile_coords)
		add_child(crop)
		planted_crops[tile_coords] = crop
		
func water_crop(tile_coords: Vector2i):
		if planted_crops.has(tile_coords):
			var crop = planted_crops[tile_coords]
			crop.watered()
			
func plant_seed(tile_coords: Vector2i):
		if planted_crops.has(tile_coords):
			var crop = planted_crops[tile_coords]
			crop.grow()
			return
		
		var slot = inventory.slots[hotbar_slots.seleected_index]
		if slot.item == SUNFLOWER_SEED and slot.amount > 0:
			slot.amount -= 1
			if slot.amount <= 0:
				slot.item = null
			inventory.update.emit()
