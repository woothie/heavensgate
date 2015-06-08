/obj/item/stack/tile/plasteel
	name = "floor tile"
	singular_name = "floor tile"
	desc = "Those could work as a pretty decent throwing weapon"
	icon_state = "tile"
	force = 6.0
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = CONDUCT

/obj/item/stack/tile/plasteel/New(var/loc, var/amount=null)
	..()
	src.pixel_x = rand(1, 14)
	src.pixel_y = rand(1, 14)
	return

/obj/item/stack/tile/plasteel/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/plasteel
	build_type = /obj/item/stack/tile/plasteel

/obj/item/stack/tile/plasteel/proc/build(turf/S as turf)
	if (istype(S,/turf/space))
		S.ChangeTurf(/turf/simulated/floor/plating/airless)
	else
		S.ChangeTurf(/turf/simulated/floor/plating)
	return