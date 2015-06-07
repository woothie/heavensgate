//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspacehelmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	flags_inv = HIDEFACE
	permeability_coefficient = 0.01
	pressure_resistance = 200 * ONE_ATMOSPHERE
	armor = list(melee = 65, bullet = 50, laser = 50,energy = 25, bomb = 50, bio = 100, rad = 50)
	species_fit = list("Vox")

//Captain's space suit This is not the proper path but I don't currently know enough about how this all works to mess with it.
/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive Nanotrasen armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	species_fit = list("Vox")
	w_class = 4
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags = FPRINT
	pressure_resistance = 200 * ONE_ATMOSPHERE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy, /obj/item/weapon/gun/projectile, /obj/item/ammo_storage, /obj/item/ammo_casing, /obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_nitrogen)
	slowdown = 1.5
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)
	flags_inv = HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7