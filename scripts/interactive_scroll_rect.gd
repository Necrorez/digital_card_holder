extends ColorRect
class_name InteractiveScrollRect

"""
InteractiveScrollRect

Responsible for adding, animating, handling card viewing
"""

const INTERACTIVE_SCROLL_ITEM : PackedScene = preload("res://nodes/interactive_scroll_item.tscn")

@export var margin : int = 20
@export var next_button : TextureButton
@export var previous_button : TextureButton
@onready var card_container: HBoxContainer = $CardContainer

var all_cards : Array[InteractiveScrollItem]

var current_index : int = 0 : set = set_current_index
var card_size : float = 0.0

func set_current_index(new_index:int)->void:
	current_index = clampi(new_index,0,all_cards.size()-1) 
	print(current_index," " ,new_index)
	update_shown_card()

func update_shown_card()->void:
	var tween := create_tween()
	var _real_margin = margin*2 if current_index == all_cards.size()-1 else margin 
		
	tween.tween_property(card_container,"position:x",-(card_size*0.5)*current_index-_real_margin,1.0)

func _load_test_data()->void:
	var test_dir_path := "res://textures/test_textures"
	var test_dir := DirAccess.open(test_dir_path)
	if !test_dir:
		push_error("Folder does not exist")
		return
	
	test_dir.list_dir_begin()
	var file_name = test_dir.get_next()

	while file_name != "":
		if !test_dir.current_is_dir():
			if file_name.ends_with(".import"):
				file_name = test_dir.get_next()
				continue
			var new_img = Image.load_from_file(test_dir_path+"/"+file_name)
			var new_texture = ImageTexture.create_from_image(new_img)
			generate_card(file_name,new_texture)
		
		file_name = test_dir.get_next()


func generate_card(card_name:String,card_texture:Texture2D)->void:
	var item_to_add := INTERACTIVE_SCROLL_ITEM.instantiate() as InteractiveScrollItem
	card_container.add_child(item_to_add)
	item_to_add.card_name.text = card_name
	item_to_add.card_texture.texture = card_texture
	all_cards.append(item_to_add)
	card_size = item_to_add.get_global_rect().size.x
	

func _clear_all_children()->void:
	for i in card_container.get_children():
		i.queue_free()

func _connect_buttons()->void:
	_attempt_to_conect_button(next_button,func():
		current_index = current_index + 1
		)
	
	_attempt_to_conect_button(previous_button,func():
		current_index = current_index - 1
		)
	
func _attempt_to_conect_button(button_to_connect:BaseButton,callable_to_connect:Callable=Callable())->void:
	if !button_to_connect:
		return
	
	if !callable_to_connect.is_valid():
		return
	
	button_to_connect.pressed.connect(callable_to_connect)

func _ready() -> void:
	card_container.set("theme_override_constants/separation",margin)
	_connect_buttons()
	_clear_all_children()
	_load_test_data()
