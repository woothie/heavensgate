/world/New()
	admin_verbs_admin += /client/proc/Freeze
	admin_verbs_admin += /client/proc/Freeze_Mech
	admin_verbs_admin += /client/proc/fillspace
	admin_verbs_admin += /client/proc/clean
	admin_verbs_admin += /client/proc/nuke

	return ..()

/client/proc/Freeze(mob/living/M as mob in mob_list)
	set category = "Admin"
	set name = "Freeze"

	if (holder && mob && istype(M))
		if (M.paralysis)
			M.AdjustParalysis(-2147483647)
			M.blinded = 0
			M.lying = 0
			M.stat = 0

			M.show_message("<b> <font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>", 2)
			message_admins("\blue [key_name_admin(usr)] unfroze [M.name]/[M.ckey]")
			log_admin("[key_name(usr)] unfroze [M.name]/[M.ckey]")
		else
			M.AdjustParalysis(2147483647)
			M.show_message("<b><font color= red>You have been frozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>", 2)
			message_admins("\blue [key_name_admin(usr)] froze [M.name]/[M.ckey]")
			log_admin("[key_name(usr)] froze [M.name]/[M.ckey]")

/client/proc/Freeze_Mech(obj/mecha/M as obj in world)
	set category = "Admin"
	set name = "Freeze mech"

	if (holder && mob && istype(M))
		if (M.can_move == 1)
			M.can_move = 0

			if(M.occupant)
				M.removeVerb(/obj/mecha/verb/eject)

				M.occupant.show_message("<b><font color= red>You have been frozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>", 2)

				message_admins("\blue [key_name_admin(usr)] froze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
				log_admin("[key_name(usr)] froze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
			else
				message_admins("\blue [key_name_admin(usr)] froze an empty [M.name]")
				log_admin("[key_name(usr)] froze an empty [M.name]")
		else if(M.can_move == 0)
			M.can_move = 1
			if(M.occupant)
				M.addVerb(/obj/mecha/verb/eject)

				M.occupant.show_message("<b><font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>", 2)

				message_admins("\blue [key_name_admin(usr)] unfroze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
				log_admin("[key_name(usr)] unfroze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
			else
				message_admins("\blue [key_name_admin(usr)] unfroze an empty [M.name]")
				log_admin("[key_name(usr)] unfroze an empty [M.name]")

/client/proc/fillspace()
	set category = "Special Verbs"
	set name = "Fill space with plating"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/area/location = usr.loc.loc
	if(location.name != "Space")
		for(var/turf/space/S in location)
			S.ChangeTurf(/turf/simulated/floor/plating)
	if(location.name == "Space")
		for(var/turf/space/S in range(2,usr.loc))
			S.ChangeTurf(/turf/simulated/floor/plating)

/client/proc/clean()
	set category = "Special Verbs"
	set name = "Clean Station"


	var/i = 0
	for(var/obj/Obj in world)
		if(istype(Obj,/obj/effect/decal/cleanable))
			i++

	if(!i)
		usr << "No /obj/effect/decal/cleanable located in world."
		return
	if(alert("There are [i] cleanable objects in the world. Do you want to delete them?",,"Yes", "No") == "Yes")
		world << "<br><br><font color = red size = 2><b>A Staff member is cleaning the world.<br>Expect a tad bit of lag.</b></font><br>"
		sleep 15
		for(var/obj/Obj in world)
			if(istype(Obj,/obj/effect/decal/cleanable))
				del(Obj)
		log_admin("[key_name(usr)] cleaned the world ([i] objects deleted) ")
		message_admins("\blue [key_name(usr)] cleaned the world ([i] objects deleted) ")

/client/proc/nuke()
	set category = "Admin"
	set name = "Nuke the Station"

	if(!holder)
		src << "Only administrators may use this command."
		return

	if(alert("This will destroy the station with a nuke. Are you sure you wish to kill everyone?",,"Yes","No")=="No")
		return

	if(!ticker)
		alert("huh...what are you doing...the game hasn't even started yet...")
		return
	if(!ticker.mode)
		alert("huh...what are you doing...the game hasn't even started yet...")
		return
	else



		message_admins("\red [ckey] decided to blow up the station.")
		set_security_level("gamma")
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				M << sound('sound/ai/spanomalies.ogg')

		sleep(201)

		ticker.mode:explosion_in_progress = 1
		for(var/mob/M in player_list)
			M << 'sound/machines/Alarm.ogg'
		world << " "
		world << "\red Impact in 10"
		for (var/i=9 to 1 step -1)
			sleep(10)
			var/msg = i
			world << "\red[msg]"
		sleep(10)
		if(ticker)
			ticker.station_explosion_cinematic(0,null)
			if(ticker.mode)
				ticker.mode:station_was_nuked = 1
				ticker.mode:explosion_in_progress = 0