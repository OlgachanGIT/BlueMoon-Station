/mob/living/simple_animal/hostile/syndicate
	var/use_health_icons = FALSE
	var/icon_base = ""
	var/list/ally_death_phrases = list("У НАС ПОТЕРИ!", "НЕСЁМ ПОТЕРИ!", "ТЕРЯЕМ БОЙЦОВ!", "МЫ ОТОМСТИМ ЗА ТЕБЯ!", "НАМ НУЖНО БОЛЬШЕ ОГНЕВОЙ МОЩИ!")
	var/list/player_death_phrases = list("УБИТ!", "ОДНИМ МЕНЬШЕ!", "ХА! ПОЛУЧИЛ, УРОД?", "МИРУ СТАЛО ЧИЩЕ БЕЗ ТЕБЯ!", "СДОХНИ, МУСОР!")
	var/list/aggro_shout_phrases = list("ВИЖУ ЦЕЛЬ!", "КОНТАКТ!", "ВОТ ТЫ ГДЕ, УРОД!", "ОГОНЬ ПО ГОТОВНОСТИ!", "ЗАМЕТИЛ ДВИЖЕНИЕ!", "УБЛЮДОК, ТЕБЕ КОНЕЦ!", "КОНТАКТ С ГРАЖДАНСКИМ!")
	var/death_comment_cooldown = 0

/obj/item/ammo_casing/c22lr/fortificator
	name = ".22 Long rifle bullet casing (fortificator)"


/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator
	parent_type = /mob/living/simple_animal/hostile/syndicate/ranged/order_base
	name = "Order Fortificator"
	desc = "This guy in heavy armour looks at you..."
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	icon_state = "fortificator0"
	use_health_icons = TRUE
	icon_base = "fortificator"
	loot = list(/obj/effect/decal/cleanable/blood)
	del_on_death = 0
	health = 200
	maxHealth = 200
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	projectilesound = 'modular_bluemoon/sound/weapons/mesa/scar.ogg'
	rapid = 20
	aggro_vision_range = 9
	casingtype = /obj/item/ammo_casing/c22lr/fortificator/autodelete
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	deathmessage = "gets discombobulated and fucking dies."
	icon_dead = "fortificator_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	sentience_type = SENTIENCE_BOSS
	var/has_dropped_ammo = FALSE
	magazine_size = 100
	magazine_current = 100
	reload_sound = 'modular_bluemoon/sound/weapons/mesa/scar.ogg'
	reload_say_phrases = list("Касета ёбнула!", "МАГАЗИН МЕНЯЮ! ЖМИТЕ ГАДА!", "СКИДЫВАЮ КОРОБ!")
	dropped_mag_type = /obj/item/ammo_box/magazine/mm712x82

/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator/death(gibbed)
	if(!gibbed && !has_dropped_ammo && prob(80))
		has_dropped_ammo = TRUE
		new /obj/item/ammo_box/magazine/ak47(get_turf(src))
	. = ..()

/obj/item/ammo_casing/c22lr/fortificator/autodelete
	Initialize()
		. = ..()
		QDEL_IN(src, 50)

/mob/living/simple_animal/hostile/syndicate/ranged/order_base
	var/alert_cooldown_time = 0
	var/magazine_size = 30
	var/magazine_current = 30
	var/reload_time = 3 SECONDS
	var/reloading = FALSE
	var/reload_sound = 'modular_bluemoon/sound/creatures/skihell/cover.ogg'
	var/list/reload_say_phrases = list("Reloading!", "Cover me!", "Out of ammo!")
	var/dropped_mag_type = null

/mob/living/simple_animal/hostile/syndicate/ranged/order_base/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(handle_mob_death))

/mob/living/simple_animal/hostile/syndicate/ranged/order_base/proc/handle_mob_death(datum/source, mob/living/L, gibbed)
	SIGNAL_HANDLER
	if(stat != CONSCIOUS || world.time < death_comment_cooldown || !L || L == src)
		return
	if(get_dist(src, L) > 7 || !can_see(src, L, 7))
		return

	if(faction_check_mob(L, TRUE))
		say(pick(ally_death_phrases))
		death_comment_cooldown = world.time + 10 SECONDS
	else if(L.client)
		say(pick(player_death_phrases))
		death_comment_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/syndicate/ranged/order_base/Aggro()
	var/static/list/alert_sounds = list(
		'modular_bluemoon/sound/creatures/skihell/mob1.ogg',
		'modular_bluemoon/sound/creatures/skihell/mob2.ogg',
		'modular_bluemoon/sound/creatures/skihell/mob6.ogg',
		'modular_bluemoon/sound/creatures/skihell/mob17.ogg',
	)
	if(world.time > alert_cooldown_time)
		playsound(src, pick(alert_sounds), 70)
		if(prob(80))
			say(pick(aggro_shout_phrases))
		alert_cooldown_time = world.time + 10 SECONDS
	..()

/mob/living/simple_animal/hostile/syndicate/ranged/order_base/OpenFire(atom/A)
	if(reloading)
		return
	if(magazine_current <= 0)
		reload()
		return
	..()

/mob/living/simple_animal/hostile/syndicate/ranged/order_base/proc/reload()
	if(reloading || magazine_current == magazine_size)
		return
	reloading = TRUE
	visible_message("<span class='warning'><b>[src]</b> begins reloading!</span>")
	say(pick(reload_say_phrases))
	playsound(src, reload_sound, 70)
	addtimer(CALLBACK(src, PROC_REF(finish_reload)), reload_time)

/mob/living/simple_animal/hostile/syndicate/ranged/order_base/proc/finish_reload()
	magazine_current = magazine_size
	reloading = FALSE
	visible_message("<span class='notice'><b>[src]</b> finished reloading.</span>")

/mob/living/simple_animal/hostile/syndicate/ranged/order_base/Shoot(atom/targeted_atom)
	if(magazine_current <= 0)
		if(!reloading)
			reload()
		return
	. = ..()
	magazine_current--

/mob/living/simple_animal/hostile/syndicate/melee/order_base
	var/alert_cooldown_time = 0

/mob/living/simple_animal/hostile/syndicate/proc/order_injury_logic(amount)
	if(amount > 0 && prob(25))
		var/static/list/agony_sounds = list(
			'modular_bluemoon/smiley/sounds/emotes/agony_male_5.ogg',
			'modular_bluemoon/smiley/sounds/emotes/agony_male_6.ogg',
			'modular_bluemoon/smiley/sounds/emotes/agony_male_8.ogg'
		)
		playsound(src, pick(agony_sounds), 50, 0)

/mob/living/simple_animal/hostile/syndicate/proc/update_order_icon()
	if(stat != CONSCIOUS || !use_health_icons || !icon_base)
		return
	if(health / maxHealth > 0.7)
		icon_state = "[icon_base]3"
	else if(health / maxHealth > 0.5)
		icon_state = "[icon_base]2"
	else if(health / maxHealth > 0.3)
		icon_state = "[icon_base]1"

/mob/living/simple_animal/hostile/syndicate/melee/order_base/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(handle_mob_death))

/mob/living/simple_animal/hostile/syndicate/melee/order_base/proc/handle_mob_death(datum/source, mob/living/L, gibbed)
	SIGNAL_HANDLER
	if(stat != CONSCIOUS || world.time < death_comment_cooldown || !L || L == src)
		return
	if(get_dist(src, L) > 7 || !can_see(src, L, 7))
		return

	if(faction_check_mob(L, TRUE))
		say(pick(ally_death_phrases))
		death_comment_cooldown = world.time + 10 SECONDS
	else if(L.client)
		say(pick(player_death_phrases))
		death_comment_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/syndicate/melee/order_base/Aggro()
	var/static/list/alert_sounds = list(
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert01.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert03.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert04.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert05.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert06.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert07.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert08.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecu/hg_alert10.ogg'
	)
	if(world.time > alert_cooldown_time)
		playsound(src, pick(alert_sounds), 70)
		if(prob(80))
			say(pick(aggro_shout_phrases))
		alert_cooldown_time = world.time + 10 SECONDS
	..()


/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator/adjustHealth(amount, updating_health = TRUE, ...)
	if(stat == DEAD)
		return
	. = ..()
	update_order_icon()
	order_injury_logic(amount)

/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator/Move(atom/newloc)
	return FALSE

/mob/living/simple_animal/hostile/syndicate/ranged/orderfortificator/AttackingTarget()
	return FALSE


//reinforcer


/mob/living/simple_animal/hostile/syndicate/melee/orderreinforcer
	parent_type = /mob/living/simple_animal/hostile/syndicate/melee/order_base
	name = "Order Reinforcer"
	desc = "How i supposed to destroy this goddamn shield?"
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	melee_damage_lower = 20
	melee_damage_upper = 20
	armour_penetration = 35
	icon_state = "reinforcer0"
	use_health_icons = TRUE
	icon_base = "reinforcer"
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
	sentience_type = SENTIENCE_BOSS
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
	update_order_icon()
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
		var/static/list/shield_sounds = list(
			'modular_bluemoon/sound/weapons/shield/ric1.ogg',
			'modular_bluemoon/sound/weapons/shield/ric2.ogg',
			'modular_bluemoon/sound/weapons/shield/ric3.ogg',
			'modular_bluemoon/sound/weapons/shield/ric5.ogg'
		)
		playsound(src, pick(shield_sounds), 80, 0)
		return BULLET_ACT_BLOCK
	return ..()

//combatant

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant
	parent_type = /mob/living/simple_animal/hostile/syndicate/ranged/order_base
	name = "Order combatant"
	magazine_size = 45
	magazine_current = 45
	dropped_mag_type = /obj/item/ammo_box/magazine/wt550m9
	reload_sound = 'modular_bluemoon/sound/creatures/skihell/cover.ogg'
	reload_say_phrases = list("Перезаряжаюсь!", "Прикрой меня!", "Я ПУСТОЙ!", "ПЕРЕЗАРЯЖАЮСЬ!")
	desc = "REACTUS GRANATUS!!!"
	icon = 'modular_bluemoon/icons/mob/skihell.dmi'
	icon_state = "combatant0"
	use_health_icons = TRUE
	icon_base = "combatant"
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
	sentience_type = SENTIENCE_BOSS
	var/grenade_cooldown = 10 SECONDS
	var/last_grenade_throw = 0
	var/hiding_behind_sandbag = FALSE

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/Initialize(mapload)
	. = ..()
	last_grenade_throw = world.time

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/Life()
	. = ..()
	if(stat != CONSCIOUS)
		return

	if(target)
		if(!hiding_behind_sandbag)
			var/obj/structure/barricade/sandbags/closest_sandbag
			var/min_dist = 6
			for(var/obj/structure/barricade/sandbags/S in view(5, src))
				var/dist = get_dist(src, S)
				if(dist < min_dist)
					var/turf/T = get_turf(S)
					if(T && !T.density)
						min_dist = dist
						closest_sandbag = S

			if(closest_sandbag)
				var/turf/T = get_turf(closest_sandbag)
				if(get_dist(src, T) > 0)
					walk_to(src, T, 0, move_to_delay)
				else
					walk(src, 0) // Stop walking if reached
				hiding_behind_sandbag = TRUE
				stop_automated_movement = TRUE
	else if(hiding_behind_sandbag)
		hiding_behind_sandbag = FALSE
		stop_automated_movement = FALSE
		walk(src, 0)

	if(stop_automated_movement && !hiding_behind_sandbag) // If we aren't hiding or throwing grenade
		return

	// Check for incoming grenades and dodge
	for(var/obj/item/grenade/G in oview(3, src))
		if(G.throwing && get_dist(src, G) <= 2)
			dodge_grenade(G)
			break

	if(target && world.time > last_grenade_throw + grenade_cooldown)
		var/dist = get_dist(src, target)
		if(dist >= 3 && dist <= 9 && can_see(src, target, aggro_vision_range))
			throw_grenade(target)

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/proc/dodge_grenade(obj/item/grenade/G)
	var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	var/turf/T = get_step(src, pick(dirs))
	if(T && !T.density)
		visible_message("<span class='warning'>[src] dodges the incoming grenade!</span>")
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1)
		forceMove(T)

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/proc/throw_grenade(mob/living/L)
	if(!L || QDELETED(L))
		return

	last_grenade_throw = world.time
	stop_automated_movement = TRUE

	// Enhanced visual and audio warning
	var/obj/effect/temp_visual/TV = new /obj/effect/temp_visual/decoy/fading(loc, 2 SECONDS)
	TV.color = "#ff0000"
	visible_message("<span class='danger'>[src] begins charging a grenade throw!</span>")
	playsound(src, 'sound/magic/lightning_chargeup.ogg', 70, 1)

	set_light(3, 1, "#ff0000")
	addtimer(CALLBACK(src, PROC_REF(reset_light)), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(do_throw), L), 2 SECONDS)

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/proc/reset_light()
	set_light(0)

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/proc/do_throw(mob/living/L)
	stop_automated_movement = FALSE
	if(!L || QDELETED(L) || stat != CONSCIOUS || !can_see(src, L, aggro_vision_range))
		return

	visible_message("<span class='danger'>[src] hurls a frag grenade with deadly precision!</span>")
	playsound(get_turf(src), 'modular_bluemoon/sound/creatures/skihell/shielddodge.ogg', 70, 1)

	// Create and throw grenade
	var/obj/item/grenade/syndieminibomb/concussion/combatant/G = new(src.loc)
	G.throw_at(L, 7, 2, src)
	addtimer(CALLBACK(G, /obj/item/grenade/proc/prime), 25)

	// Add smoke effect at throw location
	var/turf/throw_turf = get_turf(src)
	addtimer(CALLBACK(src, PROC_REF(create_smoke), throw_turf), 10)

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/proc/create_smoke(turf/T)
	if(T)
		var/datum/effect_system/smoke_spread/bad/smoke = new
		smoke.set_up(3, T)
		smoke.start()

/mob/living/simple_animal/hostile/syndicate/ranged/ordercombatant/adjustHealth(amount, updating_health = TRUE, ...)
	. = ..()
	update_order_icon()
	order_injury_logic(amount)

/obj/item/grenade/syndieminibomb/concussion/combatant
	icon_state = "concussion_active"
	ex_heavy = 0
	ex_light = 4
	ex_flame = 2

//prometheus


/mob/living/simple_animal/hostile/syndicate/ranged/orderprometheus
	parent_type = /mob/living/simple_animal/hostile/syndicate/ranged/order_base
	name = "Order Prometheus"
	magazine_size = 60
	magazine_current = 60
	reload_sound = 'modular_bluemoon/sound/weapons/mesa/sweetvoice.ogg'
	reload_say_phrases = list("Кончилось топливо!", "Меняю топливный бак!", "СЕЙЧАС ВЫ СГОРИТЕ, ЕРЕТИКИ!")
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
	sentience_type = SENTIENCE_BOSS

/mob/living/simple_animal/hostile/syndicate/ranged/orderprometheus/adjustHealth(amount)
	. = ..()
	order_injury_logic(amount)

/mob/living/simple_animal/hostile/syndicate/ranged/orderprometheus/death(gibbed)
	if(prob(30))
		explosion(src, devastation_range = -1, heavy_impact_range = 1, light_impact_range = 2, flash_range = 3, flame_range = 3)
	return ..()



//saggitarius

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius
	parent_type = /mob/living/simple_animal/hostile/syndicate/ranged/order_base
	name = "Order Saggitarius"
	magazine_size = 20
	magazine_current = 20
	dropped_mag_type = /obj/item/ammo_box/magazine/m556
	reload_sound = 'modular_bluemoon/sound/weapons/mesa/sniper_bolt1.ogg'
	reload_say_phrases = list("Я пуст...", "Они же не видели меня?...", "Меняю позицию... Я пуст...")
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
	sentience_type = SENTIENCE_BOSS
	var/stealthed = FALSE
	var/next_roll_time = 0
	var/roll_cooldown = 10
	var/stealth_recover_chance = 30
	var/stealth_recover_delay = 3 SECONDS

/mob/living/simple_animal/hostile/syndicate/ranged/ordersaggitarius/Initialize()
	. = ..()
	ally_death_phrases = list("Ты был хорошим инструментом...", "Глупая смерть.", "Покойся в тенях.")
	player_death_phrases = list("Одна пуля - один свидетель.", "Ты даже не видел меня.", "Тьма забирает тебя.")

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
	order_injury_logic(amount)

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

	var/turf/current_turf = src.loc
	var/turf/destination = current_turf
	for(var/i = 1, i <= roll_distance, i++)
		var/turf/next = get_step(destination, dir)
		if(!next || next.density || isgroundlessturf(next) || istype(next, /turf/open/chasm))
			break
		destination = next

	if(destination == current_turf)
		return

	visible_message("<span class='notice'><b>[src]</b> quickly rolls to the side!</span>")
	playsound(get_turf(src), 'sound/mecha/neostep1.ogg', 200, 1)

	throw_at(destination, roll_distance, roll_speed, spin = FALSE, diagonals_first = TRUE)


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
	parent_type = /mob/living/simple_animal/hostile/syndicate/ranged/order_base
	name = "Dux"
	magazine_size = 15
	magazine_current = 15
	dropped_mag_type = /obj/item/ammo_box/magazine/m50
	reload_sound = 'modular_bluemoon/sound/creatures/skihell/shit.ogg'
	reload_say_phrases = list("БЛЯДЬ! ПЕРЕЗАРЯЖАЮ!", "СУКА! МНЕ МАГАЗИНЫ НУЖНЫ!", "СДОХНИ! ПРОСТО... УМРИ!", "СЛЕДУЮЩИЙ МАГАЗИН БУДЕТ ПОСЛЕДНИЙ ДЛЯ ТЕБЯ!")
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
	sentience_type = SENTIENCE_BOSS
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
	parent_type = /mob/living/simple_animal/hostile/syndicate/ranged/order_base
	name = "Order holy hands medic"
	magazine_size = 10
	magazine_current = 10
	reload_sound = 'sound/rig/longbeep.ogg'
	reload_say_phrases = list("Рукавицы разрядились!", "Не могу прикрывать! Я разряжен!", "Я на нуле!")
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
	sentience_type = SENTIENCE_BOSS
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

	proc/start_healing(mob/living/target)
		if(!target || target.stat == DEAD)
			return

		healing_target = target
		current_beam = Beam(target, icon_state="medbeam", time=5 MINUTES, maxdistance=healing_range, beam_type=/obj/effect/ebeam/medical)
		if(current_beam)
			RegisterSignal(current_beam, COMSIG_PARENT_QDELETING, PROC_REF(beam_died))
			beam_healing()

	proc/beam_healing()
		if(stat != CONSCIOUS || !healing_target || !isliving(healing_target) || healing_target.stat == DEAD || !current_beam || QDELETED(current_beam))
			stop_healing()
			return

		if(healing_target.health >= healing_target.maxHealth || get_dist(src, healing_target) > healing_range || !can_see(src, healing_target, healing_range))
			stop_healing(healing_target.health >= healing_target.maxHealth)
			return

		target = null // Don't attack while healing
		var/mob/living/L = healing_target
		L.adjustBruteLoss(-5)
		L.adjustFireLoss(-5)
		L.adjustToxLoss(-2)
		L.adjustOxyLoss(-2)

		new /obj/effect/temp_visual/heal(get_turf(L), "#80F5FF")

		addtimer(CALLBACK(src, PROC_REF(beam_healing)), 1 SECONDS)

	proc/beam_died()
		SIGNAL_HANDLER
		stop_healing()

	proc/stop_healing(finished = FALSE)
		if(current_beam)
			UnregisterSignal(current_beam, COMSIG_PARENT_QDELETING)
			QDEL_NULL(current_beam)
		healing_target = null
		if(finished && finished != COMSIG_PARENT_QDELETING)
			last_heal = world.time - heal_cooldown
		else
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

//sniper

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper
	parent_type = /mob/living/simple_animal/hostile/syndicate/ranged/order_base
	name = "Order Sniper"
	magazine_size = 5
	magazine_current = 5
	desc = "A stationary sniper with precise ranged attacks."
	icon = 'modular_bluemoon/icons/mob/skihellbosses.dmi'
	icon_state = "phantasma"
	icon_dead = "phantasma_dead"
	del_on_death = 0
	health = 120
	maxHealth = 120
	projectilesound = 'modular_bluemoon/sound/weapons/acr_fire.ogg'
	rapid = 1
	aggro_vision_range = 40
	vision_range = 40
	projectiletype = /obj/item/projectile/bullet/a308
	casingtype = /obj/item/ammo_casing/a308
	death_sound = 'modular_bluemoon/sound/creatures/skihell/death.ogg'
	deathmessage = "gets discombobulated and fucking dies."
	icon_dead = "sniper_dead"
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	sentience_type = SENTIENCE_BOSS
	reload_say_phrases = list("Перезяражаюсь! Прикрой!", "Одна пуля - один труп...", "Дозаряжаю!")
	var/aiming = FALSE
	var/aim_time = 1.5 SECONDS
	var/last_aim = 0
	var/datum/beam/current_beam = null
	var/atom/aiming_target = null
	var/grace_time = 0.6 SECONDS
	var/lose_target_time = 0

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/MoveToTarget(list/possible_targets)
	stop_automated_movement = TRUE
	if(!target || !CanAttack(target))
		LoseTarget()
		return FALSE
	if(target in possible_targets)
		var/turf/T = get_turf(src)
		if(target.z != T.z)
			LoseTarget()
			return FALSE
		// Snipping the adjacency check to ensure we shoot across 1-tile chasms
		if(ranged_cooldown <= world.time)
			OpenFire(target)
		return TRUE
	LoseTarget()
	return FALSE

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/Move(atom/newloc)
	return FALSE

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/OpenFire(atom/A)
	if(reloading)
		return
	if(magazine_current <= 0)
		reload()
		return
	if(aiming || world.time < last_aim + aim_time)
		return
	start_aiming(A)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/proc/los_check(atom/target)
	var/turf/user_turf = get_turf(src)
	var/turf/target_turf = get_turf(target)
	if(!user_turf || !target_turf || user_turf.z != target_turf.z)
		return FALSE

	for(var/turf/T in getline(user_turf, target_turf))
		if(T == user_turf || T == target_turf)
			continue
		if(T.opacity)
			return FALSE
		if(T.density && !isgroundlessturf(T) && !istype(T, /turf/open/chasm))
			return FALSE
		for(var/atom/movable/AM in T)
			if(AM == target || AM == src || AM.invisibility > see_invisible)
				continue
			if(AM.opacity)
				return FALSE
			if(AM.density)
				if(isgroundlessturf(T) || istype(T, /turf/open/chasm)) // Ignore density of objects on chasms/space
					continue
				if(AM.pass_flags_self & (PASSTABLE|PASSGLASS|PASSGRILLE|LETPASSTHROW))
					continue
				if(istype(AM, /obj/structure/barricade/sandbags) || istype(AM, /obj/structure/window))
					continue
				return FALSE
	return TRUE

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/proc/start_aiming(atom/target)
	if(!target || aiming)
		return
	if(!los_check(target))
		return
	aiming = TRUE
	aiming_target = target
	lose_target_time = world.time
	// Increased time slightly to ensure beam doesn't expire before fire_shot
	current_beam = Beam(target, icon_state="blood", time=aim_time + 2, maxdistance=aggro_vision_range, beam_type=/obj/effect/ebeam/laser)
	if(current_beam)
		RegisterSignal(current_beam, COMSIG_PARENT_QDELETING, PROC_REF(beam_died))
	visible_message("<span class='danger'>[src] takes aim at [target]!</span>")
	aim_process(target, world.time + aim_time)

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/proc/beam_died()
	SIGNAL_HANDLER
	if(aiming)
		last_aim = world.time // Ensure cooldown if beam is lost
	stop_aiming()

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/proc/aim_process(atom/target, end_time)
	if(!aiming || target != aiming_target || (src.target && target != src.target))
		stop_aiming()
		return
	if(!target || QDELETED(target) || !los_check(target))
		if(aiming)
			last_aim = world.time // Cooldown on LOS loss
		stop_aiming()
		return
	lose_target_time = world.time
	if(world.time >= end_time)
		fire_shot(target)
		return
	addtimer(CALLBACK(src, PROC_REF(aim_process), target, end_time), 2)

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/proc/fire_shot(atom/target)
	if(!target || !aiming)
		stop_aiming()
		return
	if(!los_check(target))
		stop_aiming()
		return
	stop_aiming()
	last_aim = world.time

	Shoot(target)
	visible_message("<span class='danger'>[src] fires a precise shot!</span>")

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/proc/stop_aiming()
	aiming = FALSE
	aiming_target = null
	if(current_beam)
		var/datum/beam/B = current_beam
		current_beam = null
		UnregisterSignal(B, COMSIG_PARENT_QDELETING)
		qdel(B)

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/Destroy()
	stop_aiming()
	return ..()

/mob/living/simple_animal/hostile/syndicate/ranged/ordersniper/death(gibbed)
	if(!gibbed)
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(3, 1, src)
		sparks.start()
		playsound(get_turf(src), 'sound/magic/Repulse.ogg', 100, 1)
		animate(src, alpha = 0, time = 5)
		QDEL_IN(src, 5)
	return ..()

/obj/effect/ebeam/laser
	name = "laser beam"

