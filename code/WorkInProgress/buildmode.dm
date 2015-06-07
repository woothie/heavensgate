/proc/togglebuildmode(mob/M as mob in player_list)
	set name = "Toggle Build Mode"
	set category = "Special Verbs"
	if(M.client)
		if(M.client.buildmode)
			log_admin("[key_name(usr)] has left build mode.")
			M.client.buildmode = 0
			M.client.show_popup_menus = 1
			var/obj/effect/bmode/buildholder/holder = null
			for(var/obj/effect/bmode/buildholder/H in buildmodeholders)
				if(H.cl == M.client)
					holder = H
					break
			if(holder) holder.buildmode.copycat = null
			if(M.client.buildmode_objs && M.client.buildmode_objs.len)
				for(var/BM in M.client.buildmode_objs)
					returnToPool(BM)
		else
			log_admin("[key_name(usr)] has entered build mode.")
			M.client.buildmode = 1
			M.client.show_popup_menus = 0

			var/obj/effect/bmode/buildholder/hold = getFromPool(/obj/effect/bmode/buildholder)
			hold.builddir = getFromPool(/obj/effect/bmode/builddir,hold)
			hold.buildhelp = getFromPool(/obj/effect/bmode/buildhelp,hold)
			hold.buildmode = getFromPool(/obj/effect/bmode/buildmode,hold)
			hold.buildquit = getFromPool(/obj/effect/bmode/buildquit,hold)
			M.client.screen += list(hold.builddir,hold.buildhelp,hold.buildmode,hold.buildquit)
			hold.cl = M.client
			M.client.buildmode_objs |= list(hold,hold.builddir,hold.buildhelp,hold.buildmode,hold.buildquit)

/obj/effect/bmode//Cleaning up the tree a bit
	density = 1
	anchored = 1
	layer = 20
	dir = NORTH
	icon = 'icons/misc/buildmode.dmi'
	var/obj/effect/bmode/buildholder/master = null

/obj/effect/bmode/New()
	..()
	master = loc

/obj/effect/bmode/Destroy()
	..()
	if(master && master.cl)
		master.cl.buildmode_objs &= ~src
		master.cl.screen -= src

/obj/effect/bmode/builddir
	icon_state = "build"
	screen_loc = "NORTH,WEST"
	Click()
		switch(dir)
			if(NORTH)
				dir = EAST
			if(EAST)
				dir = SOUTH
			if(SOUTH)
				dir = WEST
			if(WEST)
				dir = SOUTHWEST
			if(SOUTHWEST)
				dir = NORTH
		return 1

/obj/effect/bmode/buildhelp
	icon = 'icons/misc/buildmode.dmi'
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"
	Click()
		switch(master.cl.buildmode)
			if(1)
				usr << "<span class='notice'>***********************************************************</span>"
				usr << "<span class='notice'>Left Mouse Button        = Construct / Upgrade</span>"
				usr << "<span class='notice'>Right Mouse Button       = Deconstruct / Delete / Downgrade</span>"
				usr << "<span class='notice'>Left Mouse Button + ctrl = R-Window</span>"
				usr << "<span class='notice'>Left Mouse Button + alt  = Airlock</span>"
				usr << ""
				usr << "<span class='notice'>Use the button in the upper left corner to</span>"
				usr << "<span class='notice'>change the direction of built objects.</span>"
				usr << "<span class='notice'>***********************************************************</span>"
			if(2)
				usr << "<span class='notice'>***********************************************************</span>"
				usr << "<span class='notice'>Right Mouse Button on buildmode button = Set object type</span>"
				usr << "<span class='notice'>Left Mouse Button on turf/obj          = Place objects</span>"
				usr << "<span class='notice'>Right Mouse Button                     = Delete objects</span>"
				usr << ""
				usr << "<span class='notice'>Use the button in the upper left corner to</span>"
				usr << "<span class='notice'>change the direction of built objects.</span>"
				usr << "<span class='notice'>***********************************************************</span>"
			if(3)
				usr << "<span class='notice'>***********************************************************</span>"
				usr << "<span class='notice'>Right Mouse Button on buildmode button = Select var(type) & value</span>"
				usr << "<span class='notice'>Left Mouse Button on turf/obj/mob      = Set var(type) & value</span>"
				usr << "<span class='notice'>Right Mouse Button on turf/obj/mob     = Reset var's value</span>"
				usr << "<span class='notice'>***********************************************************</span>"
			if(4)
				usr << "<span class='notice'>***********************************************************</span>"
				usr << "<span class='notice'>Left Mouse Button on turf/obj/mob      = Select</span>"
				usr << "<span class='notice'>Right Mouse Button on turf/obj/mob     = Throw</span>"
				usr << "<span class='notice'>***********************************************************</span>"
		return 1

/obj/effect/bmode/buildquit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

	Click()
		togglebuildmode(master.cl.mob)
		return 1

var/global/list/obj/effect/bmode/buildholder/buildmodeholders = list()
/obj/effect/bmode/buildholder
	density = 0
	anchored = 1
	var/client/cl = null
	var/obj/effect/bmode/builddir/builddir = null
	var/obj/effect/bmode/buildhelp/buildhelp = null
	var/obj/effect/bmode/buildmode/buildmode = null
	var/obj/effect/bmode/buildquit/buildquit = null
	var/atom/movable/throw_atom = null

obj/effect/bmode/buildholder/New()
	..()
	buildmodeholders |= src

/obj/effect/bmode/buildholder/Destroy()
	..()
	cl.screen -= list(builddir,buildhelp,buildmode,buildquit)
	cl.buildmode_objs &= ~list(builddir,buildhelp,buildmode,buildquit,src)
	buildmodeholders -= src

/obj/effect/bmode/buildmode
	icon_state = "buildmode1"
	screen_loc = "NORTH,WEST+2"
	var/varholder = "name"
	var/valueholder = "derp"
	var/objholder = /obj/structure/closet
	var/atom/copycat

/obj/effect/bmode/buildmode/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("left"))
		switch(master.cl.buildmode)
			if(1)
				master.cl.buildmode = 2
				src.icon_state = "buildmode2"
			if(2)
				master.cl.buildmode = 3
				src.icon_state = "buildmode3"
			if(3)
				master.cl.buildmode = 4
				src.icon_state = "buildmode4"
			if(4)
				master.cl.buildmode = 1
				src.icon_state = "buildmode1"

	else if(pa.Find("right"))
		switch(master.cl.buildmode)
			if(1)
				return 1
			if(2)
				copycat = null
				objholder = text2path(input(usr,"Enter typepath:" ,"Typepath","/obj/structure/closet"))
				if(!ispath(objholder))
					objholder = /obj/structure/closet
					alert("That path is not allowed.")
				else
					if(ispath(objholder,/mob) && !check_rights(R_DEBUG,0))
						objholder = /obj/structure/closet
			if(3)
				var/list/locked = list("vars", "key", "ckey", "client", "firemut", "ishulk", "telekinesis", "xray", "virus", "viruses", "cuffed", "ka", "last_eaten", "urine")

				master.buildmode.varholder = input(usr,"Enter variable name:" ,"Name", "name")
				if(master.buildmode.varholder in locked && !check_rights(R_DEBUG,0))
					return 1
				var/thetype = input(usr,"Select variable type:" ,"Type") in list("text","number","mob-reference","obj-reference","turf-reference")
				if(!thetype) return 1
				switch(thetype)
					if("text")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", "value") as text
					if("number")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", 123) as num
					if("mob-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as mob in mob_list
					if("obj-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as obj in world
					if("turf-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as turf in world
	return 1

/proc/build_click(var/mob/user, buildmode, params, var/obj/object)
	var/obj/effect/bmode/buildholder/holder = null
	for(var/obj/effect/bmode/buildholder/H in buildmodeholders)
		if(H.cl == user.client)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)
	var/turf/RT = get_turf(object)
	switch(buildmode)
		if(1)
			if(istype(object,/turf) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				if(istype(object,/turf/space))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					log_admin("[key_name(usr)] made a floor at [formatJumpTo(T)]")
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					log_admin("[key_name(usr)] made a wall at [formatJumpTo(T)]")
					return
				else if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall/r_wall)
					log_admin("[key_name(usr)] made a rwall at [formatJumpTo(T)]")
					return
			else if(pa.Find("right"))
				if(istype(object,/turf/simulated/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/floor)
					log_admin("[key_name(usr)] removed a wall at [formatJumpTo(T)]")
					return
				else if(istype(object,/turf/simulated/floor))
					var/turf/T = object
					T.ChangeTurf(/turf/space)
					log_admin("[key_name(usr)] removed flooring at [formatJumpTo(T)]")
					return
				else if(istype(object,/turf/simulated/wall/r_wall))
					var/turf/T = object
					T.ChangeTurf(/turf/simulated/wall)
					log_admin("[key_name(usr)] downgraded an rwall at [formatJumpTo(T)]")
					return
				else if(istype(object,/obj))
					del(object)
					return
			else if(istype(object,/turf) && pa.Find("alt") && pa.Find("left"))
				new/obj/machinery/door/airlock(get_turf(object))
				log_admin("[key_name(usr)] made an airlock at [formatJumpTo(RT)]")
			else if(istype(object,/turf) && pa.Find("ctrl") && pa.Find("left"))
				log_admin("[key_name(usr)] made a window at [formatJumpTo(RT)]")
				switch(holder.builddir.dir)
					if(NORTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.dir = NORTH
					if(SOUTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.dir = SOUTH
					if(EAST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.dir = EAST
					if(WEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
						WIN.dir = WEST
					if(SOUTHWEST)
						new/obj/structure/window/full/reinforced(get_turf(object))
		if(2)
			if(pa.Find("left"))
				if(holder.buildmode.copycat)
					if(isturf(holder.buildmode.copycat))
						var/turf/T = get_turf(object)
						T.ChangeTurf(holder.buildmode.copycat.type)
						spawn(1)
							T.icon = holder.buildmode.copycat.icon
							T.icon_state = holder.buildmode.copycat.icon_state
							T.dir = holder.builddir.dir
							if(holder.buildmode.copycat.overlays.len)
								T.overlays.len = 0
								for(var/i = 1; i <= holder.buildmode.copycat.overlays.len; i++)
									var/datum/thing = holder.buildmode.copycat.overlays[i]
									T.overlays += thing
							if(holder.buildmode.copycat.underlays.len)
								T.underlays.len = 0
								for(var/i = 1; i <= holder.buildmode.copycat.underlays.len; i++)
									var/datum/thing = holder.buildmode.copycat.underlays[i]
									T.underlays += thing
					else
						var/atom/movable/A = new holder.buildmode.copycat.type(get_turf(object))
						if(istype(A))
							A.dir = holder.builddir.dir
							A.icon = holder.buildmode.copycat.icon
							A.gender = holder.buildmode.copycat.gender
							A.name = holder.buildmode.copycat.name
							A.icon_state = holder.buildmode.copycat.icon_state
							A.alpha = holder.buildmode.copycat.alpha
							A.color = holder.buildmode.copycat.color
							A.maptext = holder.buildmode.copycat.maptext
							A.maptext_height = holder.buildmode.copycat.maptext_height
							A.maptext_width = holder.buildmode.copycat.maptext_width
							A.light_color = holder.buildmode.copycat.light_color
							A.luminosity = holder.buildmode.copycat.luminosity
							A.molten = holder.buildmode.copycat.molten
							A.pixel_x = holder.buildmode.copycat.pixel_x
							A.pixel_y = holder.buildmode.copycat.pixel_y
							A.invisibility = holder.buildmode.copycat.invisibility
							if(holder.buildmode.copycat.overlays.len)
								A.overlays.len = 0
								for(var/i = 1; i <= holder.buildmode.copycat.overlays.len; i++)
									var/datum/thing = holder.buildmode.copycat.overlays[i]
									A.overlays += thing
							if(holder.buildmode.copycat.underlays.len)
								A.underlays.len = 0
								for(var/i = 1; i <= holder.buildmode.copycat.underlays.len; i++)
									var/datum/thing = holder.buildmode.copycat.underlays[i]
									A.underlays += thing
					log_admin("[key_name(usr)] made a [holder.buildmode.copycat.type] at [formatJumpTo(RT)]")
				else
					if(ispath(holder.buildmode.objholder,/turf))
						var/turf/T = get_turf(object)
						T.ChangeTurf(holder.buildmode.objholder)
					else
						var/obj/A = new holder.buildmode.objholder (get_turf(object))
						if(istype(A))
							A.dir = holder.builddir.dir
					log_admin("[key_name(usr)] made a [holder.buildmode.objholder] at [formatJumpTo(RT)]")
			else if(pa.Find("right"))
				log_admin("[key_name(usr)] deleted a [object] at [formatJumpTo(RT)]")
				if(isobj(object)) del(object)
			else if(pa.Find("middle"))
				if(istype(object,/mob) && !check_rights(R_DEBUG,0))
					usr << "<span class='notice'>You don't have sufficient rights to clone [object.type]</span>"
				else
					if(ismob(object))
						holder.buildmode.objholder = object.type
						usr << "<span class='info'>You will now build [object.type] when clicking.</span>"
					else
						holder.buildmode.copycat = object
						usr << "<span class='info'>You will now build a lookalike of [object] when clicking.</span>"

		if(3)
			if(pa.Find("left")) //I cant believe this shit actually compiles.
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = holder.buildmode.valueholder
				else
					usr << "<span class='warning'>[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'</span>"
			if(pa.Find("right"))
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = initial(object.vars[holder.buildmode.varholder])
				else
					usr << "<span class='warning'>[initial(object.name)] does not have a var called '[holder.buildmode.varholder]'</span>"

		if(4)
			if(pa.Find("left"))
				log_admin("[key_name(usr)] is selecting [object] for throwing at [formatJumpTo(RT)]")
				holder.throw_atom = object
			if(pa.Find("right"))
				if(holder.throw_atom)
					holder.throw_atom.throw_at(object, 10, 1)
					log_admin("[key_name(usr)] is throwing a [holder.throw_atom] at [object] - [formatJumpTo(RT)]")
