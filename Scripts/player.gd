extends Node2D

@export var inventory:Inventory

func collect(item):
	inventory.insert(item)
