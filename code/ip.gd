extends Node2D

@onready var ip = $ip
@onready var ihp = $ihp
@onready var addhp = $addhp
@onready var minushp = $minushp
@onready var iatk = $iatk
@onready var addatk = $addatk
@onready var minusatk = $minusatk
@onready var isp = $isp
@onready var addsp = $addsp
@onready var minussp = $minussp
@onready var idef = $idef
@onready var adddef = $adddef
@onready var minusdef = $minusdef
@onready var ispd = $ispd
@onready var addspd = $addspd
@onready var minusspd = $minusspd
@onready var icrit = $icrit
@onready var addcrit = $addcrit
@onready var minuscrit = $minuscrit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_buttons()
	update_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_start_button_pressed() -> void:
	print("starting game again!")
	get_tree().change_scene_to_file("res://fight1-1.tscn")
	
func _on_home_button_pressed() -> void:
	print("Returning home again!")
	get_tree().change_scene_to_file("res://start.tscn")

func update_buttons():
	if(Global.ihp + 1 > Global.ip):
		addhp.disabled = true
	else:
		addhp.disabled = false
		
	if(Global.iatk + 1 > Global.ip):
		addatk.disabled = true
	else:
		addatk.disabled = false
	
	if(Global.isp + 1 > Global.ip):
		addsp.disabled = true
	else:
		addsp.disabled = false
	
	if(Global.idef + 1 > Global.ip):
		adddef.disabled = true
	else:
		adddef.disabled = false
	
	if(Global.ispd + 1 > Global.ip):
		addspd.disabled = true
	else:
		addspd.disabled = false
	
	if(Global.icrit + 1 > Global.ip):
		addcrit.disabled = true
	else:
		addcrit.disabled = false
	
	if(Global.ihp <  1):
		minushp.disabled = true
	else:
		minushp.disabled = false
	
	if(Global.iatk <  1):
		minusatk.disabled = true
	else:
		minusatk.disabled = false
	
	if(Global.isp <  1):
		minussp.disabled = true
	else:
		minussp.disabled = false
	
	if(Global.idef <  1):
		minusdef.disabled = true
	else:
		minusdef.disabled = false
	
	if(Global.ispd <  1):
		minusspd.disabled = true
	else:
		minusspd.disabled = false
	
	if(Global.icrit <  1):
		minuscrit.disabled = true
	else:
		minuscrit.disabled = false

func update_labels():
	ip.text = "Innate Potential: " + str(Global.ip)
	ihp.text = "Innate HP: " + str(Global.ihp) + "   |   Cost to Upgrade: " + str(Global.ihp + 1)
	isp.text = "Innate SP: " + str(Global.isp) + "   |   Cost to Upgrade: " + str(Global.isp + 1)
	iatk.text = "Innate Attack: " + str(Global.iatk) + "   |   Cost to Upgrade: " + str(Global.iatk + 1)
	idef.text = "Innate Defense: " + str(Global.idef) + "   |   Cost to Upgrade: " + str(Global.idef + 1)
	ispd.text = "Innate Speed: " + str(Global.ispd) + "   |   Cost to Upgrade: " + str(Global.ispd + 1)
	icrit.text = "Innate Crit: " + str(Global.icrit) + "%" + "   |   Cost to Upgrade: " + str(Global.icrit + 1)

func _on_addhp_pressed() -> void:
	Global.ip -= Global.ihp + 1
	Global.ihp += 1
	update_buttons()
	update_labels()

func _on_minushp_pressed() -> void:
	Global.ip += Global.ihp
	Global.ihp -= 1
	update_buttons()
	update_labels()

func _on_addatk_pressed() -> void:
	Global.ip -= Global.iatk + 1
	Global.iatk += 1
	update_buttons()
	update_labels()

func _on_minusatk_pressed() -> void:
	Global.ip += Global.iatk
	Global.iatk -= 1
	update_buttons()
	update_labels()

func _on_addsp_pressed() -> void:
	Global.ip -= Global.isp + 1
	Global.isp += 1
	update_buttons()
	update_labels()

func _on_minussp_pressed() -> void:
	Global.ip += Global.isp
	Global.isp -= 1
	update_buttons()
	update_labels()

func _on_adddef_pressed() -> void:
	Global.ip -= Global.idef + 1
	Global.idef += 1
	update_buttons()
	update_labels()

func _on_minusdef_pressed() -> void:
	Global.ip += Global.idef
	Global.idef -= 1
	update_buttons()
	update_labels()

func _on_addspd_pressed() -> void:
	Global.ip -= Global.ispd + 1
	Global.ispd += 1
	update_buttons()
	update_labels()


func _on_minusspd_pressed() -> void:
	Global.ip += Global.ispd
	Global.ispd -= 1
	update_buttons()
	update_labels()

func _on_addcrit_pressed() -> void:
	Global.ip -= Global.icrit + 1
	Global.icrit += 1
	update_buttons()
	update_labels()

func _on_minuscrit_pressed() -> void:
	Global.ip += Global.icrit
	Global.icrit -= 1
	update_buttons()
	update_labels()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://start.tscn")
