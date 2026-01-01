/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator
	name = "Order Fortificator"
	desc = "This guy in heavy armour looks at you..."
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	icon_state = "fortificator0"
	loot = list(/obj/effect/decal/cleanable/blood)
	del_on_death = 0
	health = 200
	maxHealth = 200
	projectilesound = 'modular_bluemoon/sound/weapons/mesa/scar.ogg'
	rapid = 18
	aggro_vision_range = 9
	casingtype = /obj/item/ammo_casing/c22lr
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	deathmessage = "gets discombobulated and fucking dies."
	icon_dead = "fortificator_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	var/has_dropped_ammo = FALSE

/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator/death(gibbed)
	if(!gibbed && !has_dropped_ammo && prob(80))
		has_dropped_ammo = TRUE
		new /obj/item/ammo_box/magazine/ak47(get_turf(src))
	. = ..()

/obj/item/ammo_casing/c10mm/autodelete
	Initialize()
		. = ..()
		QDEL_IN(src, 50)


/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator/adjustHealth(amount, updating_health = TRUE, ...)
	if(stat == DEAD)
		return
	. = ..()
	update_icons()
	if(health / maxHealth > 0.7)
		icon_state = "fortificator3"
	else if(health / maxHealth > 0.5)
		icon_state = "fortificator2"
	else if(health / maxHealth > 0.3)
		icon_state = "fortificator1"
	if(amount > 0)
		if(prob(25))
			var/static/list/sounds = list(
				'modular_bluemoon/smiley/sounds/emotes/agony_male_5.ogg',
				'modular_bluemoon/smiley/sounds/emotes/agony_male_6.ogg',
				'modular_bluemoon/smiley/sounds/emotes/agony_male_8.ogg'
			)
			playsound(src, pick(sounds), 50, 0)

/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator/Move(atom/newloc)
	return FALSE


//reinforcer


/mob/living/simple_animal/hostile/syndicate/melee/orderreinforcer
	name = "Order Reinforcer"
	desc = "How i supposed to destroy this goddamn shield?"
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	melee_damage_lower = 20
	melee_damage_upper = 20
	armour_penetration = 35
	icon_state = "reinforcer0"
	loot = list(/obj/effect/decal/cleanable/blood)
	del_on_death = 0
	health = 150
	maxHealth = 150
	aggro_vision_range = 10
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	deathmessage = "gets discombobulated and fucking dies."
	icon_dead = "reinforcer_dead"
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	attack_sound = 'sound/weapons/slam.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	sharpness = SHARP_NONE
	var/has_dropped_shield = FALSE

/mob/living/simple_animal/hostile/syndicate/melee/orderreinforcer/death(gibbed)
	if(!gibbed && !has_dropped_shield && prob(15))
		has_dropped_shield = TRUE
		new /obj/item/shield/police(get_turf(src))
	. = ..()

/mob/living/simple_animal/hostile/syndicate/melee/orderreinforcer/AttackingTarget()
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		var/turf/T = get_step_away(L, src)
		if(T)
			L.throw_at(T, 3, 2, src)

/mob/living/simple_animal/hostile/syndicate/melee/orderreinforcer/adjustHealth(amount, updating_health = TRUE, ...)
	. = ..()
	if(health / maxHealth > 0.7)
		icon_state = "reinforcer3"
	else if(health / maxHealth > 0.5)
		icon_state = "reinforcer2"
	else if(health / maxHealth > 0.3)
		icon_state = "reinforcer1"
	update_icons()
	if(amount > 0)
		if(prob(25))
			var/static/list/sounds = list(
				'modular_bluemoon/smiley/sounds/emotes/agony_male_5.ogg',
				'modular_bluemoon/SmiLeY/sounds/trip_blast.wav'
			)
			playsound(src, pick(sounds), 50, 0)

/mob/living/simple_animal/hostile/syndicate/melee/orderreinforcer/bullet_act(obj/item/projectile/Proj)
	if(prob(40))
		visible_message("<span class='danger'>[src] blocks [Proj] with its shield!</span>")
		playsound(src, 'modular_bluemoon/sound/creatures/skihell/shielddodge.ogg', 80, 0)
		return BULLET_ACT_BLOCK
	return ..()

//combatant

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant
	name = "Order combatant"
	desc = "REACTUS GRANATUS!!!"
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	icon_state = "combatant0"
	loot = list(/obj/effect/decal/cleanable/blood)
	del_on_death = 0
	health = 100
	maxHealth = 100
	projectilesound = 'modular_bluemoon/sound/weapons/acr_fire.ogg'
	rapid = 2
	aggro_vision_range = 10
	casingtype = /obj/item/ammo_casing/c10mm
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	deathmessage = "gets discombobulated and fucking dies."
	icon_dead = "combatant_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	var/has_thrown_grenade = FALSE

	New()
		..()
		spawn(0)
			ai_loop()


	proc/ai_loop()
		while(src && src.stat != DEAD)
			var/mob/living/target = find_target()

			if(target && !has_thrown_grenade)
				throw_grenade(target)
				has_thrown_grenade = TRUE

			sleep(5)
		return

	proc/find_target()
		var/mob/living/best = null
		var/dist = 999

		for(var/mob/living/M in oview(aggro_vision_range, src))
			if(!is_valid_throw_target(M))
				continue

			var/d = get_dist(src, M)
			if(d < dist)
				dist = d
				best = M

		return best

	proc/is_valid_throw_target(mob/living/T)
		if(!T || QDELETED(T))
			return FALSE
		if(T.stat != CONSCIOUS)
			return FALSE
		if(T == src)
			return FALSE
		if(T.faction && src.faction && (T.faction & src.faction))
			return FALSE
		return TRUE

	proc/throw_grenade(mob/living/target)
		if(!target || QDELETED(target))
			return

		visible_message("<span class='danger'>[src] throws a frag grenade!</span>")
		playsound(get_turf(src), 'modular_bluemoon/sound/creatures/skihell/shielddodge.ogg', 70, 1)

		var/turf/T = get_turf(target)
		var/obj/item/grenade/syndieminibomb/concussion/combatant/G = new(src.loc)

		if(G)
			G.throw_at(T, 6, 2, src)
			addtimer(CALLBACK(G, /obj/item/grenade/proc/prime), 25)

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/adjustHealth(amount, updating_health = TRUE, ...)
	. = ..()
	update_icons()

	if(health / maxHealth > 0.7)
		icon_state = "combatant3"
	else if(health / maxHealth > 0.5)
		icon_state = "combatant2"
	else if(health / maxHealth > 0.3)
		icon_state = "combatant1"

	if(amount > 0)
		if(prob(25))
			var/static/list/sounds = list(
				'modular_bluemoon/smiley/sounds/emotes/agony_male_5.ogg',
				'modular_bluemoon/smiley/sounds/emotes/agony_male_6.ogg',
				'modular_bluemoon/smiley/sounds/emotes/agony_male_8.ogg'
			)
			playsound(src, pick(sounds), 50, 0)

/obj/item/grenade/syndieminibomb/concussion/combatant
	icon_state = "concussion_active"
	ex_heavy = 0
	ex_light = 4
	ex_flame = 2

//prometheus


/mob/living/simple_animal/hostile/syndicate/ranged/orderprometheus
	name = "Order Prometheus"
	desc = "I love see this world... in fire"
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	icon_state = "prometheus"
	del_on_death = 1
	health = 110
	maxHealth = 110
	projectilesound = 'modular_bluemoon/sound/weapons/acr_fire.ogg'
	rapid = 2
	aggro_vision_range = 10
	projectiletype = /obj/item/projectile/bullet/incendiary/m2a100
	casingtype = FALSE
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	deathmessage = "gets discombobulated and fucking dies."
	icon_dead = "prometheus_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0



//saggitarius

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius
	name = "Order Saggitarius"
	desc = "Sometimes I feel like I am being watched..."
	icon = 'modular_bluemoon/icons/mob/skihellbosses.dmi'
	icon_state = "saggitarius"
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	deathmessage = "gets discombobulated and fucking dies."
	icon_dead = "saggitariusdead"
	del_on_death = 0
	health = 170
	maxHealth = 170
	casingtype = /obj/item/ammo_casing/c10mm
	projectilesound = 'modular_bluemoon/sound/weapons/acr_fire.ogg'
	move_to_delay = 3
	rapid = 3
	aggro_vision_range = 10
	retreat_distance = 4
	minimum_distance = 4
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	var/stealthed = FALSE
	var/next_roll_time = 0
	var/roll_cooldown = 10
	var/stealth_recover_chance = 30
	var/stealth_recover_delay = 3 SECONDS

//навал кода

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/proc/enter_stealth()
	if(stealthed || stat != CONSCIOUS)
		return
	stealthed = TRUE
	animate(src, alpha = 40, time = 10)
	visible_message("<span class='notice'>[src] fades into partial invisibility.</span>")
	playsound(get_turf(src), 'sound/rig/stealthrig_turn_off.ogg', 250, 1)

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/proc/exit_stealth()
	if(!stealthed)
		return
	stealthed = FALSE
	animate(src, alpha = 255, time = 10)
	visible_message("<span class='warning'>[src] becomes visible again!</span>")
	playsound(get_turf(src), 'sound/rig/loudbeep.ogg', 250, 1)

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/proc/try_reenter_stealth()
	if(prob(stealth_recover_chance) && !stealthed && stat == CONSCIOUS)
		enter_stealth()

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(stealthed && amount > 0)
		exit_stealth()
		addtimer(CALLBACK(src, /mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/proc/try_reenter_stealth), stealth_recover_delay)
	. = ..(amount, updating_health, forced)

//додж

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/proc/combat_roll()
	if(world.time < next_roll_time || !target)
		return
	next_roll_time = world.time + roll_cooldown

	var/roll_distance = rand(5, 6)
	var/roll_speed = 1

	var/dir_to_target = get_dir(src, target)

	var/list/perp_dirs = list()
	switch(dir_to_target)
		if(NORTH, SOUTH)
			perp_dirs = list(EAST, WEST)
		if(EAST, WEST)
			perp_dirs = list(NORTH, SOUTH)
		if(NORTHEAST, SOUTHWEST)
			perp_dirs = list(NORTHWEST, SOUTHEAST)
		if(NORTHWEST, SOUTHEAST)
			perp_dirs = list(NORTHEAST, SOUTHWEST)

	var/dir = pick(perp_dirs)

	var/turf/target_turf = get_step(src, dir)
	for(var/i = 2, i <= roll_distance, i++)
		var/turf/next = get_step(target_turf, dir)
		if(!next)
			break
		target_turf = next

	if(!target_turf)
		return

	visible_message("<span class='notice'><b>[src]</b> quickly rolls to the side!</span>")
	playsound(get_turf(src), 'sound/mecha/neostep1.ogg', 200, 1)

	throw_at(target_turf, roll_distance, roll_speed, spin = FALSE, diagonals_first = TRUE)


//лайфовое

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/Life()
	. = ..()
	if(stat != CONSCIOUS)
		return

	if(target && !stealthed)
		enter_stealth()

	if(target && prob(70))
		combat_roll()

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/death(gibbed)
	exit_stealth()
	. = ..()

//dux

/mob/living/simple_animal/hostile/syndicate/ranged/dux
	name = "Dux"
	desc = "Dangerous and extremely blood cold order unit. dux is known for causing intense fear and hallucinations in its victims."
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	icon_state = "dux"
	health = 300
	maxHealth = 300
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	projectilesound = 'modular_bluemoon/kovac_shitcode/sound/weapons/deagle.ogg'
	deathmessage = "Телепортируется в инное измерение."
	casingtype = /obj/item/ammo_casing/a50AE
	projectiletype = /obj/item/projectile/bullet/a357/ap
	rapid = 1
	del_on_death = 0
	aggro_vision_range = 12
	del_on_death = 0
	loot = list(/obj/item/ectoplasm)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	var/datum/proximity_monitor/advanced/demoraliser/demoraliser_monitor
	var/fear_check_range = 6
	var/fear_check_interval = 40
	var/next_fear_check = 0

	Initialize(mapload = FALSE)
		. = ..(mapload)
		if(mapload)
			return
		if(!istype(src, /mob/living))
			return
		if(!demoraliser_monitor)
			demoraliser_monitor = new /datum/proximity_monitor/advanced/demoraliser(src, fear_check_range)
		next_fear_check = world.time

	Life()
		. = ..()
		if(world.time >= next_fear_check)
			next_fear_check = world.time + fear_check_interval
			if(demoraliser_monitor)
				for(var/atom/A in oview(fear_check_range, src))
					if(isliving(A) && istype(A, /mob/living/carbon/human) && isturf(A.loc))
						var/mob/living/carbon/human/H = A
						if(H.stat != CONSCIOUS)
							continue
						if(!H.mind)
							continue
						if(H.is_blind())
							continue
						var/reaction = rand(1,5)
						switch(reaction)
							if(1)
								H.Confused(15)
								H.pointed(src)
								H.say("МОЯ ГОЛОВА! ПРЕКРАТИ!", forced="phobia")
								SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "dux_fear", /datum/mood_event/dux_scared)
							if(2)
								H.emote("tremble")
								H.Jitter(15)
								H.say("ХВАТИТ!!! ХВАТИТ-ХВАТИТ-ХВАТИТ!!!", forced = "phobia")
								H.pointed(src)
								SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "dux_fear", /datum/mood_event/dux_scared)
							if(3)
								H.emote("scream")
								H.Jitter(15)
								H.say("Уберите! Уберите его от меня!", forced = "phobia")
								H.pointed(src)
								SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "dux_fear", /datum/mood_event/dux_scared)
							if(4)
								H.emote("shiver")
								H.stuttering += 15
								H.pointed(src)
								SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "dux_fear", /datum/mood_event/dux_scared)
							if(5)
								H.Confused(20)
								H.emote("pale")
								SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "dux_fear", /datum/mood_event/dux_scared)

	Destroy()
		if(demoraliser_monitor)
			QDEL_NULL(demoraliser_monitor)
		. = ..()


	death(gibbed)
		if(!gibbed)
			var/datum/effect_system/spark_spread/sparks = new
			sparks.set_up(3, 1, src)
			sparks.start()
			playsound(get_turf(src), 'sound/magic/Repulse.ogg', 100, 1)
			animate(src, alpha = 0, time = 5)
			QDEL_IN(src, 5)
		return ..()

/datum/mood_event/dux_scared
	description = span_boldwarning("МОЯ ГОЛОВА!!! УБЕРИТЕ ЭТУ ТВАРЬ ОТ МЕНЯ СЕЙЧАС ЖЕ!!!! \n")
	mood_change = -25
	timeout = 2 MINUTES

//holy hands

/mob/living/simple_animal/hostile/syndicate/ranged/medic
	name = "Order holy hands medic"
	desc = "Strange order unit with big gas ballons on his back and strange gloves that emit soft cyan light."
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	icon_state = "holyhands"
	icon_dead = "holyhands_dead"
	loot = list(/obj/item/ectoplasm)
	maxHealth = 150
	health = 150
	melee_damage_lower = 5
	melee_damage_upper = 5
	obj_damage = 0
	del_on_death = 0
	casingtype =  /obj/item/ammo_casing/energy/electrode
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	var/healing_range = 8
	var/heal_cooldown = 10 SECONDS
	var/last_heal = 0
	var/mob/living/healing_target = null
	var/datum/beam/current_beam = null

	Initialize()
		. = ..()
		last_heal = world.time

	Life()
		. = ..()
		if(world.time < last_heal + heal_cooldown)
			return

		var/mob/living/closest_wounded = null
		var/closest_dist = healing_range + 1

		for(var/mob/living/L in view(healing_range, src))
			if(L == src || L.stat == DEAD)
				continue
			if(!faction_check_mob(L, TRUE))
				continue
			if(L.health >= L.maxHealth)
				continue

			var/dist = get_dist(src, L)
			if(dist < closest_dist)
				closest_dist = dist
				closest_wounded = L

		if(closest_wounded && !current_beam)
			start_healing(closest_wounded)
			last_heal = world.time

	proc/start_healing(mob/living/target)
		if(!target || target.stat == DEAD)
			return

		healing_target = target
		// Используем Beam() вместо beam()
		current_beam = Beam(target, icon_state="medbeam", time=100, maxdistance=healing_range, beam_type=/obj/effect/ebeam/medical)
		if(current_beam)
			beam_healing()

	proc/beam_healing()
		if(!healing_target || !isliving(healing_target) || healing_target.stat == DEAD || !current_beam)
			stop_healing()
			return

		if(isliving(healing_target))
			var/mob/living/L = healing_target
			L.adjustBruteLoss(-5)
			L.adjustFireLoss(-5)
			L.adjustToxLoss(-2)
			L.adjustOxyLoss(-2)

			new /obj/effect/temp_visual/heal(get_turf(L), "#80F5FF")

		addtimer(CALLBACK(src, PROC_REF(beam_healing)), 1 SECONDS)

	proc/stop_healing()
		healing_target = null
		QDEL_NULL(current_beam)
		last_heal = world.time

	Destroy()
		stop_healing()
		return ..()

	death(gibbed)
		if(!gibbed)
			var/datum/effect_system/spark_spread/sparks = new
			sparks.set_up(3, 1, src)
			sparks.start()
			playsound(get_turf(src), 'sound/magic/Repulse.ogg', 100, 1)
			animate(src, alpha = 0, time = 5)
			QDEL_IN(src, 5)
		return ..()


/mob/living/simple_animal/hostile/syndicate/ranged/medic/adjustHealth(amount, updating_health = TRUE, ...)
	. = ..()
	update_icons()
	if(health / maxHealth > 0.3)
		icon_state = "holyhands1"
	if(amount > 0)
		if(prob(40))
			var/static/list/sounds = list(
				'sound/rig/longbeep.ogg',
				'sound/rig/loudbeep.ogg'
			)
			playsound(src, pick(sounds), 100, 0)
