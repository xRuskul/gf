extends Spatial
class_name Weapon_Manager

enum{
	Slot_1,
	Slot_2
}

var item_slot := [Slot_1, Slot_2]
var current_slot
var current_weapon := [0]

var wep = null
var wep2 = null

func _ready() -> void:
	current_slot = item_slot[Slot_1]

func _process(delta: float) -> void:
	pass

func Swap_Weapon():
	if current_slot == 0:
		current_slot = item_slot[Slot_2]
		if wep != null:
			wep.hide()
		if wep2 != null:
			wep2.show()
		current_weapon[0] = wep2
		print(current_slot)
		print(current_weapon)
	elif current_slot == 1:
		current_slot = item_slot[Slot_1]
		if wep2 != null:
			wep2.hide()
		if wep != null:
			wep.show()
		current_weapon[0] = wep
		print(current_slot)
		print(current_weapon)

func Pickup_Weapon():
	if current_slot == 0 && wep == null:
		wep = self.get_child(0)
		current_weapon[0] = wep
		wep.transform = self.transform
	elif current_slot == 0 && wep != null && wep2 == null:
		current_slot = 1
		wep2 = self.get_child(1)
		wep.hide()
		current_weapon[0] = wep2
		wep2.transform = self.transform
	elif current_slot == 1 && wep != null && wep2 == null:
		wep2 = self.get_child(1)
		current_weapon[0] = wep2
		wep2.transform = self.transform
	
	if current_slot == 1 && wep2 == null:
		wep2 = self.get_child(0)
		current_weapon[0] = wep2
		wep2.transform = self.transform
	elif current_slot == 1 && wep2 != null && wep == null:
		current_slot = 0
		wep = self.get_child(1)
		wep2.hide()
		current_weapon[0] = wep
		wep.transform = self.transform
	elif current_slot == 0 && wep2 != null && wep == null:
		wep = self.get_child(1)
		current_weapon[0] = wep
		wep.transform = self.transform
	print("Picked up Weapon")

func Drop_Weapon():
	if current_slot == 0 && wep != null:
		self.remove_child(wep)
		get_parent().add_child(wep)
		wep.set_as_toplevel(true)
		current_weapon = [0]
		wep = null
		print("Dropped Weapon")
	elif current_slot == 1 && wep2 != null:
		self.remove_child(wep2)
		get_parent().add_child(wep2)
		wep2.set_as_toplevel(true)
		current_weapon = [0]
		wep2 = null
		print("Dropped Weapon")

func Shoot():
	if current_slot == 0 && wep != null:
		wep._shoot()
	elif current_slot == 1 && wep2 != null:
		wep2._shoot()

func Reload():
	if current_slot == 0 && wep != null:
		wep._reload()
	elif current_slot == 1 && wep2 != null:
		wep2._reload()
