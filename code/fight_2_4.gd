extends Node2D

# -------------------------
# Original Combat UI References
# -------------------------
@onready var grenade = $grenade
@onready var bomb = $bomb
@onready var nuke = $nuke
@onready var potion = $potion
@onready var fheal = $fheal
@onready var stats = $stats
@onready var hp = $hp
@onready var atk = $atk
@onready var sp = $sp
@onready var def = $def
@onready var spd = $spd
@onready var crit = $crit
@onready var ehp = $ehp
@onready var esp = $esp
@onready var useGrenade = $useGrenade
@onready var useBomb = $useBomb
@onready var useNuke = $useNuke
@onready var usePotion = $usePotion
@onready var useFullHeal = $useFullHeal
@onready var uhp = $uhp
@onready var usp = $usp
@onready var uatk = $uatk
@onready var udef = $udef
@onready var uspd = $uspd
@onready var ucrit = $ucrit
@onready var mattack = $mattack
@onready var guard = $guard
@onready var GUARDLABEL = $GUARDLABEL
@onready var enemyDamage = $DamageNumberSpot
@onready var playerDamage = $PlayerDamageNumberSpot
@onready var timer = $Timer

# -------------------------
# DIALOGUE UI REFERENCES (Shared)
# -------------------------
@onready var dialogue_panel = $DialoguePanel
@onready var dialogue_label = $DialoguePanel/DialogueBox
@onready var next_button    = $DialoguePanel/NextButton

# -------------------------
# Variables
# -------------------------
var rng = RandomNumberGenerator.new()
var aguard = 0

# Handle editing enemy here
var enemyHP = 100
var enemyCurrentHP = 100
var enemySP = 30
var enemyCurrentSP = 30
var enemyAtk = 10
var enemyDef = 10
var enemySpd = 10
var enemyCrit = 10
var tempHP = 0
var tempSP = 0

var specialAttack = false

# -------------------------
# GENERAL DIALOGUE FUNCTIONS (for in–combat messages)
# -------------------------
var in_dialogue := false

func show_general_dialogue(text: String) -> void:
	# Use this for one–line quick messages during combat
	dialogue_label.text = text
	dialogue_panel.visible = true
	in_dialogue = true
	disable_combat_buttons(true)
	
func hide_general_dialogue_box() -> void:
	dialogue_panel.visible = false
	in_dialogue = false
	disable_combat_buttons(false)

# -------------------------
# BOSS DIALOGUE FUNCTIONS (for boss conversation)
# -------------------------
var boss_dialogue_lines: Array[String] = [
	"HANDS UP!",
	"I DON'T SPARE TRAITORS!",
	"YOU WERE OUR BEST CADET. NOW YOU TURN YOUR BACK ON THE CORPORATION?",
	"ENOUGH! FACE MY RIFLE AND DIE!",
]
var boss_dialogue_index: int = 0

func start_boss_dialogue() -> void:
	boss_dialogue_index = 0
	boss_show_current_dialogue_line()

func boss_show_current_dialogue_line() -> void:
	if boss_dialogue_index < boss_dialogue_lines.size():
		# Use bbcode_text for formatting if desired:
		dialogue_label.text = boss_dialogue_lines[boss_dialogue_index]
		dialogue_panel.visible = true
		in_dialogue = true
		disable_combat_buttons(true)
	else:
		# End of boss dialogue; hide panel
		hide_general_dialogue_box()

func boss_on_NextButton_pressed() -> void:
	boss_dialogue_index += 1
	boss_show_current_dialogue_line()

# -------------------------
# Input Handling for Boss Dialogue (using arrow button and key advance)
# -------------------------
func _input(event: InputEvent) -> void:
	if in_dialogue:
		# For boss dialogue, let the NextButton or ui_accept advance it.
		# Here, if ui_accept is pressed, we call boss_on_NextButton_pressed.
		if event.is_action_pressed("ui_accept"):
			boss_on_NextButton_pressed()

# -------------------------
# ORIGINAL COMBAT FUNCTIONS (unchanged except using the renamed dialogue functions)
# -------------------------
func enemy_attack():
	await get_tree().create_timer(1.5).timeout
	#They are defeated go to shop
	if enemyCurrentHP <= 0:
		Global.ip += 1
		Global.stats += 3
		Global.currentSP = Global.sp + Global.isp
		Global.money += 50
		Global.world += 1
		Global.level = 1
		show_general_dialogue("All hail... the Corporation...")
		await get_tree().create_timer(3.5).timeout
		get_tree().change_scene_to_file("res://shop.tscn")
	else:
		var cAttack = rng.randf_range(0, 10)
		if(specialAttack == true):
			specialAttack = false
			var eAtk = enemyAtk * 3
			var multiplier = rng.randf_range(0.8, 1.2)
			if(aguard > 0):
				eAtk = eAtk * multiplier - ((Global.def + Global.idef) * 1.5) * 0.5
			else:
				eAtk = eAtk * multiplier - (Global.def + Global.idef) * 0.5
			var critical = rng.randf_range(0, 100)
			if(critical <= enemyCrit):
				eAtk *= 1.5
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			else:
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			enemyCurrentSP -= 5
			show_general_dialogue("Boss performed a strong attack for %d damage!" % int(eAtk))
		if(cAttack > 7 && enemyCurrentSP >= 10):
			var eAtk = 0
			specialAttack = true
			var critical = rng.randf_range(0, 100)
			if(critical <= enemyCrit):
				eAtk *= 1.5
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			else:
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			enemyCurrentSP -= 5
			show_general_dialogue("Boss performed a strong attack for %d damage!" % int(eAtk))
		elif(cAttack > 5 && enemyCurrentSP >= 3):
			var eAtk = enemyAtk * 2
			var multiplier = rng.randf_range(0.8, 1.2)
			if(aguard > 0):
				eAtk = eAtk * multiplier - ((Global.def + Global.idef) * 1.5) * 0.5
			else:
				eAtk = eAtk * multiplier - (Global.def + Global.idef) * 0.5
			var critical = rng.randf_range(0, 100)
			if(critical <= enemyCrit):
				eAtk *= 1.5
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			else:
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			enemyCurrentSP -= 3
			show_general_dialogue("Boss performed a special attack for %d damage!" % int(eAtk))
		elif(cAttack > 3 && enemyCurrentSP >= 2):
			var eAtk = enemyAtk * 1.5
			var multiplier = rng.randf_range(0.8, 1.2)
			if(aguard > 0):
				eAtk = eAtk * multiplier - ((Global.def + Global.idef) * 1.5) * 0.5
			else:
				eAtk = eAtk * multiplier - (Global.def + Global.idef) * 0.5
			var critical = rng.randf_range(0, 100)
			if(critical <= enemyCrit):
				eAtk *= 1.5
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			else:
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			enemyCurrentSP -= 2
			show_general_dialogue("Boss performed a special attack for %d damage!" % int(eAtk))
		else:
			var eAtk = enemyAtk
			var multiplier = rng.randf_range(0.8, 1.2)
			if(aguard > 0):
				eAtk = eAtk * multiplier - ((Global.def + Global.idef) * 1.5) * 0.5
			else:
				eAtk = eAtk * multiplier - (Global.def + Global.idef) * 0.5
			var critical = rng.randf_range(0, 100)
			if(critical <= enemyCrit):
				eAtk *= 1.5
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			else:
				Global.currentHP = clamp(Global.currentHP - eAtk, 0, Global.hp + Global.ihp)
				Damage.displayNumber(eAtk, playerDamage.global_position, critical)
			show_general_dialogue("Boss performed a weak attack for %d damage!" % int(eAtk))
		aguard -= 1
		update_labels()
		await get_tree().create_timer(1.5).timeout
		hide_general_dialogue_box()
		if(Global.currentHP <= 0):
			get_tree().change_scene_to_file("res://lose.tscn")

func _ready() -> void:
	update_stats()
	update_sp_moves()
	tempHP = Global.currentHP
	Global.currentHP = Global.hp + Global.ihp
	tempHP = Global.currentHP - tempHP
	tempHP *= -1
	tempSP = Global.currentSP
	Global.currentSP = Global.sp + Global.isp
	tempSP = Global.currentSP - tempSP
	tempSP *= -1
	update_labels()
	update_items()
	update_sp_moves()
	dialogue_panel.visible = false
	# Start boss dialogue at the beginning with a slight delay if needed
	await get_tree().create_timer(0.5).timeout
	start_boss_dialogue()


func update_items():
	if Global.grenade < 1:
		useGrenade.disabled = true
	if Global.bomb < 1:
		useBomb.disabled = true
	if Global.nuke < 1:
		useNuke.disabled = true
	if Global.potion < 1:
		usePotion.disabled = true
	if Global.fheal < 1:
		useFullHeal.disabled = true

func update_sp_moves():
	if Global.currentSP < 3:
		mattack.disabled = true
		guard.disabled = true
	elif Global.currentSP < 5:
		mattack.disabled = true
	else:
		mattack.disabled = false
		guard.disabled = false

func update_stats():
	if Global.stats < 1:
		uhp.disabled = true
		usp.disabled = true
		uatk.disabled = true
		udef.disabled = true
		uspd.disabled = true
		ucrit.disabled = true

func update_labels():
	grenade.text = "Grenades: " + str(Global.grenade)
	bomb.text = "Bombs: " + str(Global.bomb)
	nuke.text = "Nukes: " + str(Global.nuke)
	potion.text = "Potions: " + str(Global.potion)
	fheal.text = "Full Heals: " + str(Global.fheal)
	stats.text = "Stats: " + str(Global.stats)
	hp.text = "HP: " + str(round(Global.currentHP)) + "/" + str(Global.hp + Global.ihp)
	sp.text = "SP: " + str(round(Global.currentSP)) + "/" + str(Global.sp + Global.isp)
	atk.text = "Attack: " + str(Global.atk + Global.iatk)
	if aguard < 1:
		def.text = "Defense: " + str(Global.def + Global.idef)
		GUARDLABEL.text = "Guard: Inactive"
	else:
		def.text = "Defense: " + str(round((Global.def + Global.idef) * 1.5))
		GUARDLABEL.text = "Guard: Active"
	spd.text = "Speed: " + str(Global.spd + + Global.ispd)
	crit.text = "Crit: " + str(Global.crit + + Global.icrit) + "%"
	ehp.text = "HP: " + str(round(enemyCurrentHP)) + "/" + str(enemyHP)
	esp.text = "SP: " + str(round(enemyCurrentSP)) + "/" + str(enemySP)

func _on_use_grenade_pressed() -> void:
	enemyCurrentHP = clamp(enemyCurrentHP - 20, 0, enemyHP)
	Damage.displayNumber(20, enemyDamage.global_position, false)
	Global.grenade -= 1
	update_labels()
	update_items()
	show_general_dialogue("Player used Grenade for 20 damage!")
	enemy_attack()

func _on_use_bomb_pressed() -> void:
	enemyCurrentHP = clamp(enemyCurrentHP - 50, 0, enemyHP)
	Damage.displayNumber(50, enemyDamage.global_position, false)
	Global.bomb -= 1
	update_labels()
	update_items()
	show_general_dialogue("Player used Bomb for 50 damage!")
	enemy_attack()

func _on_use_nuke_pressed() -> void:
	enemyCurrentHP = clamp(enemyCurrentHP - 100, 0, enemyHP)
	Damage.displayNumber(100, enemyDamage.global_position, false)
	Global.nuke -= 1
	update_labels()
	update_items()
	show_general_dialogue("Player used Nuke for 100 damage!")
	enemy_attack()

func _on_use_potion_pressed() -> void:
	Global.currentHP = clamp(Global.hp + Global.ihp + 20, 0, Global.hp + Global.ihp)
	Damage.displayNumber(-20, playerDamage.global_position, false)
	Global.potion -= 1
	update_labels()
	update_items()
	show_general_dialogue("Player healed 20 HP with a Potion!")
	enemy_attack()

func _on_use_full_heal_pressed() -> void:
	tempHP = Global.currentHP
	Global.currentHP = Global.hp + Global.ihp
	tempHP = Global.currentHP - tempHP
	tempHP *= -1
	Damage.displayNumber(tempHP, playerDamage.global_position, false)
	tempSP = Global.currentSP
	Global.currentSP = Global.sp + Global.isp
	tempSP = Global.currentSP - tempSP
	tempSP *= -1
	Damage.displayNumber(tempSP, playerDamage.global_position, false)
	Global.fheal -= 1
	update_labels()
	update_items()
	update_sp_moves()
	show_general_dialogue("Player used a Full Heal! HP and SP restored.")
	enemy_attack()

func _on_uhp_pressed() -> void:
	Global.hp += 1
	Global.stats -= 1
	update_labels()
	update_stats()

func _on_usp_pressed() -> void:
	Global.sp += 1
	Global.stats -= 1
	update_labels()
	update_stats()

func _on_uatk_pressed() -> void:
	Global.atk += 1
	Global.stats -= 1
	update_labels()
	update_stats()

func _on_udef_pressed() -> void:
	Global.def += 1
	Global.stats -= 1
	update_labels()
	update_stats()

func _on_uspd_pressed() -> void:
	Global.spd += 1
	Global.stats -= 1
	update_labels()
	update_stats()

func _on_ucrit_pressed() -> void:
	Global.crit += 1
	Global.stats -= 1
	update_labels()
	update_stats()

func _on_attack_pressed() -> void:
	var first = false
	if Global.spd + Global.ispd > enemySpd:
		first = true
	elif enemySpd > Global.spd + Global.ispd:
		first = false
	else:
		var tie = rng.randf_range(0, 1)
		if tie <= 0.5:
			first = true
		else:
			first = false

	if first:
		var tattack = Global.atk + Global.iatk
		var multiplier = rng.randf_range(0.8, 1.2)
		tattack = tattack * multiplier - enemyDef * 0.5
		var critical = rng.randf_range(0, 100)
		if critical <= Global.crit + Global.icrit:
			tattack *= 1.5
			enemyCurrentHP = clamp(enemyCurrentHP - tattack, 0, enemyHP)
			Damage.displayNumber(tattack, enemyDamage.global_position, critical)
		else:
			enemyCurrentHP = clamp(enemyCurrentHP - tattack, 0, enemyHP)
			Damage.displayNumber(tattack, enemyDamage.global_position, critical)
		show_general_dialogue("Player attacked first for %d damage!" % int(tattack))
		enemy_attack()
	else:
		enemy_attack()
		var tattack2 = Global.atk + Global.iatk
		var multiplier2 = rng.randf_range(0.8, 1.2)
		tattack2 = tattack2 * multiplier2 - enemyDef * 0.5
		var critical2 = rng.randf_range(0, 100)
		if critical2 <= Global.crit + Global.icrit:
			tattack2 *= 1.5
			enemyCurrentHP = clamp(enemyCurrentHP - tattack2, 0, enemyHP)
			Damage.displayNumber(tattack2, enemyDamage.global_position, critical2)
		else:
			enemyCurrentHP = clamp(enemyCurrentHP - tattack2, 0, enemyHP)
			Damage.displayNumber(tattack2, enemyDamage.global_position, critical2)
		show_general_dialogue("Enemy attacked first!\nThen Player countered for %d damage." % int(tattack2))
	update_labels()

func _on_mattack_pressed() -> void:
	var first = false
	if Global.spd + Global.ispd > enemySpd:
		first = true
	elif enemySpd > Global.spd + Global.ispd:
		first = false
	else:
		var tie = rng.randf_range(0, 1)
		if tie <= 0.5:
			first = true
		else:
			first = false

	if first:
		var tattack = Global.atk + Global.iatk
		var multiplier = rng.randf_range(0.8, 1.2)
		tattack = tattack * multiplier
		var critical = rng.randf_range(0, 100)
		if critical <= Global.crit + Global.icrit:
			tattack *= 1.5
		enemyCurrentHP = clamp(enemyCurrentHP - tattack, 0, enemyHP)
		Damage.displayNumber(tattack, enemyDamage.global_position, critical)
		show_general_dialogue("Player used a strong skill for %d damage!" % int(tattack))
		enemy_attack()
	else:
		enemy_attack()
		var tattack2 = Global.atk + Global.iatk
		var multiplier2 = rng.randf_range(0.8, 1.2)
		tattack2 = tattack2 * multiplier2
		var critical2 = rng.randf_range(0, 100)
		if critical2 <= Global.crit + Global.icrit:
			tattack2 *= 1.5
		enemyCurrentHP = clamp(enemyCurrentHP - tattack2, 0, enemyHP)
		Damage.displayNumber(tattack2, enemyDamage.global_position, critical2)
		show_general_dialogue("Player used a strong skill for %d damage, after enemy moved!" % int(tattack2))
	Global.currentSP -= 5
	update_labels()
	update_sp_moves()

func _on_guard_pressed() -> void:
	var first = false
	if Global.spd + Global.ispd > enemySpd:
		first = true
	elif enemySpd > Global.spd + Global.ispd:
		first = false
	else:
		var tie = rng.randf_range(0, 1)
		if tie <= 0.5:
			first = true
		else:
			first = false

	if first:
		aguard = 3
		show_general_dialogue("Player is guarding!")
		enemy_attack()
	else:
		enemy_attack()
		aguard = 3
		show_general_dialogue("Player started guarding after the enemy's move!")
	Global.currentSP -= 3
	update_labels()
	update_sp_moves()
	
func disable_combat_buttons(disable: bool) -> void:
	# Example of disabling or enabling relevant combat buttons
	$attack.disabled = disable
	$mattack.disabled = disable
	$guard.disabled = disable
	useGrenade.disabled = disable or (Global.grenade < 1)
	useBomb.disabled = disable or (Global.bomb < 1)
	useNuke.disabled = disable or (Global.nuke < 1)
	usePotion.disabled = disable or (Global.potion < 1)
	useFullHeal.disabled = disable or (Global.fheal < 1)
	# etc. for all other actions you want to freeze


func _on_run_pressed() -> void:
	Global.level += 1
	show_general_dialogue("Player ran away from the fight!")
	get_tree().change_scene_to_file("res://shop.tscn")


func _on_next_button_pressed() -> void:
	pass # Replace with function body.
