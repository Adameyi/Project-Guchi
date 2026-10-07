extends Resource
class_name CropData

@export var crop_name: String
@export var sprite_frames: SpriteFrames
@export var max_stage: int = 4
@export var grow_time: float = 5.0
@export var harvest_item: Inventory_Item
@export var harvest_amount: int = 2
