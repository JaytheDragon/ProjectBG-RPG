extends Node2D

@onready var grenadebuy = $grenadebuy
@onready var bombbuy = $bombbuy2
@onready var nukebuy = $nukebuy3
@onready var potionbuy = $potionbuy4
@onready var fullhealbuy = $fullhealbuy5

@onready var grenadesell = $grenadesell
@onready var bombsell = $bombsell2
@onready var nukesell = $nukesell3
@onready var potionsell = $potionsell4
@onready var fullhealsell = $fullhealsell5

@onready var g = $g
@onready var b = $b
@onready var n = $n
@onready var p = $p
@onready var f = $f
@onready var money = $money

var hpCost = 10
var spCost = 10
var atkCost = 10
var defCost = 10
var spdCost = 10
var critCost = 10
var gambleCost = 5

@onready var hp = $hp
@onready var atk = $atk
@onready var sp = $sp
@onready var def = $def
@onready var spd = $spd
@onready var crit = $crit
@onready var gamble = $gamble

@onready var ahp = $ahp
@onready var aatk = $aatk
@onready var asp = $asp
@onready var adef = $adef
@onready var aspd = $aspd
@onready var acrit = $acrit
@onready var agamble = $agamble

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hpCost = 10
	spCost = 10
	atkCost = 10
	defCost = 10
	spdCost = 10
	critCost = 10
	gambleCost = 5
	check_money()
	check_items()
	update_items()
	update_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_money():
	if(Global.money < hpCost):
		ahp.disabled = true
	else:
		ahp.disabled = false
		
	if(Global.money < spCost):
		asp.disabled = true
	else:
		asp.disabled = false
		
	if(Global.money < atkCost):
		aatk.disabled = true
	else:
		aatk.disabled = false
		
	if(Global.money < defCost):
		adef.disabled = true
	else:
		adef.disabled = false
	
	if(Global.money < spdCost):
		aspd.disabled = true
	else:
		aspd.disabled = false
	
	if(Global.money < critCost):
		acrit.disabled = true
	else:
		acrit.disabled = false
		
	if(Global.money < gambleCost):
		agamble.disabled = true
	else:
		agamble.disabled = false
		
	if(Global.money < 40):
		grenadebuy.disabled = true
		bombbuy.disabled = true
		nukebuy.disabled = true
		potionbuy.disabled = true
		fullhealbuy.disabled = true
	elif(Global.money < 100):
		grenadebuy.disabled = false
		bombbuy.disabled = true
		nukebuy.disabled = true
		potionbuy.disabled = false
		fullhealbuy.disabled = true
	elif(Global.money < 200):
		grenadebuy.disabled = false
		bombbuy.disabled = false
		nukebuy.disabled = true
		potionbuy.disabled = false
		fullhealbuy.disabled = true
	elif(Global.money < 300):
		grenadebuy.disabled = false
		bombbuy.disabled = false
		nukebuy.disabled = false
		potionbuy.disabled = false
		fullhealbuy.disabled = true
	else:
		grenadebuy.disabled = false
		bombbuy.disabled = false
		nukebuy.disabled = false
		potionbuy.disabled = false
		fullhealbuy.disabled = false
	
func check_items():
	if(Global.grenade < 1):
		grenadesell.disabled = true
	else:
		grenadesell.disabled = false
	
	if(Global.bomb < 1):
		bombsell.disabled = true
	else:
		bombsell.disabled = false
	
	if(Global.nuke < 1):
		nukesell.disabled = true
	else:
		nukesell.disabled = false
	
	if(Global.potion < 1):
		potionsell.disabled = true
	else:
		potionsell.disabled = false
	
	if(Global.fheal < 1):
		fullhealsell.disabled = true
	else:
		fullhealsell.disabled = false

func update_items():
	g.text = "Grenades: " + str(Global.grenade)
	b.text = "Bombs: " + str(Global.bomb)
	n.text = "Nukes: " + str(Global.nuke)
	p.text = "Potions: " + str(Global.potion)
	f.text = "Full Heals: " + str(Global.fheal)
	money.text = "Mahni: " + str(Global.money)

func update_stats():
	hp.text = "HP: " + str(Global.hp) + "   |   Cost to Upgrade: " + str(hpCost)
	sp.text = "SP: " + str(Global.sp) + "   |   Cost to Upgrade: " + str(spCost)
	atk.text = "Attack: " + str(Global.atk) + "   |   Cost to Upgrade: " + str(atkCost)
	def.text = "Defense: " + str(Global.def) + "   |   Cost to Upgrade: " + str(defCost)
	spd.text = "Speed: " + str(Global.spd) + "   |   Cost to Upgrade: " + str(spdCost)
	crit.text = "Crit: " + str(Global.crit) + "%" + "   |   Cost to Upgrade: " + str(critCost)
	gamble.text = "Gamble for a Random Stat Increase   |   Cost to Use: " + str(gambleCost)
	money.text = "Mahni: " + str(Global.money)

func _on_grenadebuy_pressed() -> void:
	Global.grenade += 1
	Global.money -= 40
	check_money()
	check_items()
	update_items()
	
func _on_grenadesell_pressed() -> void:
	Global.grenade -= 1
	Global.money += 20
	check_money()
	check_items()
	update_items()

func _on_bombbuy_2_pressed() -> void:
	Global.bomb += 1
	Global.money -= 100
	check_money()
	check_items()
	update_items()

func _on_bombsell_2_pressed() -> void:
	Global.bomb -= 1
	Global.money += 50
	check_money()
	check_items()
	update_items()

func _on_nukebuy_3_pressed() -> void:
	Global.nuke += 1
	Global.money -= 200
	check_money()
	check_items()
	update_items()

func _on_nukesell_3_pressed() -> void:
	Global.nuke -= 1
	Global.money += 100
	check_money()
	check_items()
	update_items()

func _on_potionbuy_4_pressed() -> void:
	Global.potion += 1
	Global.money -= 40
	check_money()
	check_items()
	update_items()

func _on_potionsell_4_pressed() -> void:
	Global.potion -= 1
	Global.money += 20
	check_money()
	check_items()
	update_items()

func _on_fullhealbuy_5_pressed() -> void:
	Global.fheal += 1
	Global.money -= 300
	check_money()
	check_items()
	update_items()

func _on_fullhealsell_5_pressed() -> void:
	Global.fheal -= 1
	Global.money += 150
	check_money()
	check_items()
	update_items()

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://fight" + str(Global.world) + "-" + str(Global.level) + ".tscn")

func _on_ahp_pressed() -> void:
	Global.hp += 1
	Global.money -= hpCost
	hpCost *= 2
	check_money()
	update_stats()

func _on_asp_pressed() -> void:
	Global.sp += 1
	Global.money -= spCost
	spCost *= 2
	check_money()
	update_stats()

func _on_aatk_pressed() -> void:
	Global.atk += 1
	Global.money -= atkCost
	atkCost *= 2
	check_money()
	update_stats()

func _on_adef_pressed() -> void:
	Global.def += 1
	Global.money -= defCost
	defCost *= 2
	check_money()
	update_stats()

func _on_aspd_pressed() -> void:
	Global.spd += 1
	Global.money -= spdCost
	spdCost *= 2
	check_money()
	update_stats()

func _on_acrit_pressed() -> void:
	Global.crit += 1
	Global.money -= critCost
	critCost *= 2
	check_money()
	update_stats()

func _on_agamble_pressed() -> void:
	Global.money -= gambleCost
	gambleCost *= 2
	var stat = rng.randf_range(0, 6)
	if(stat < 1):
		Global.hp += 1
	elif(stat < 2):
		Global.sp += 1
	elif(stat < 3):
		Global.atk += 1
	elif(stat < 4):
		Global.def += 1
	elif(stat < 5):
		Global.spd += 1
	elif(stat <= 6):
		Global.crit += 1
	check_money()
	update_stats()
