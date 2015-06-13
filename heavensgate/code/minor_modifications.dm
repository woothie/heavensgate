/obj/item/clothing/under/color/orange
	name = "orange prisoner jumpsuit"

// Prevent intercepts from being sent
/datum/game_mode/send_intercept()
/datum/game_mode/epidemic/send_intercept()
/datum/game_mode/rp_revolution/send_intercept()

/obj/structure/bed/chair/command
	icon = '../icon/obj/objects.dmi'
	icon_state = "bridge"

///turf/simulated/floor/steps
//	name = "steps"
//	icon_state = "ramptop"

/datum/preferences/spawnpoint = "Cryogenic Storage"

/datum/spawnpoint/cryo
	msg = "has completed cryogenic transfer"