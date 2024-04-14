extends Control
class_name InteractiveScrollItem

"""
InteractiveScrollItem

Responsible for holding reference data to node structure
"""

@onready var background: ColorRect = $Background
@onready var card_texture: TextureRect = $CardTexture
@onready var card_name: Label = $CardName
