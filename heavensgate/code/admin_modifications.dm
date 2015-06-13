/world/New()
	admin_verbs_admin += /client/proc/Freeze
	admin_verbs_admin += /client/proc/Freeze_Mech

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
