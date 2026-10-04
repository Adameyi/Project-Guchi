extends Control

@onready var day_label: Label = $VBoxContainer/DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $VBoxContainer/TimePanel/MarginContainer/TimeLabel
@onready var player_money: Label = $VBoxContainer/MoneyPanel/MarginContainer/PlayerMoney

@export var normal_speed:int = 5
@export var fast_speed:int = 50
@export var double_speed:int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DayNightCycleManager.time_tick.connect(on_time_tick)
	Economy.balance_changed.connect(_on_balance_changed)
	_on_balance_changed(Economy.get_bal())
	
func on_time_tick(day:int, hour:int, minute:int) -> void:
		day_label.text = 'Day ' + str(day)
		time_label.text = '%02d:%02d' % [hour, minute]
		
func _on_normal_speed_pressed() -> void:
	DayNightCycleManager.game_speed = normal_speed

func _on_fast_speed_button_pressed() -> void:
	DayNightCycleManager.game_speed = fast_speed

func _on_double_speed_button_pressed() -> void:
	DayNightCycleManager.game_speed = double_speed

#PlayerWallet
func _on_balance_changed(new_balance: int):
	player_money.text = str(new_balance) 
