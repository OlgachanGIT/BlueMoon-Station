/// Sector instability at or above BSM_INSTABILITY_TIER_HIGH: anomalies, portal storms, spawners, aimed meteors, core detonation.

#define BSM_HIGH_WEIGHT_ANOMALY 50
#define BSM_HIGH_WEIGHT_PORTAL 25
#define BSM_HIGH_WEIGHT_SPAWNER 20
#define BSM_HIGH_WEIGHT_METEOR 15
#define BSM_HIGH_WEIGHT_CORE_EXPLOSION 12

/// Marker for aimed meteor in the high-tier pickweight list (not a typepath).
#define BSM_HIGH_THREAT_METEOR "bsm_high_threat_aimed_meteor"
/// Cascading bluespace failure: warning, delay, then explosion (same flow as /obj/machinery/vending/inteq_vendomat wrench on station).
#define BSM_HIGH_THREAT_CORE_EXPLOSION "bsm_high_threat_core_explosion"

/proc/bsm_get_high_threat_pool()
	var/static/list/pool
	if(pool)
		return pool
	pool = list()
	for(var/anom_type in subtypesof(/datum/round_event_control/anomaly))
		pool[anom_type] = BSM_HIGH_WEIGHT_ANOMALY
	var/static/list/portal_storms = list(
		/datum/round_event_control/portal_storm_inteq,
		/datum/round_event_control/portal_storm_narsie,
		/datum/round_event_control/portal_storm_clown,
		/datum/round_event_control/portal_storm_necros,
		/datum/round_event_control/portal_storm_funclaws,
		/datum/round_event_control/portal_storm_clock,
	)
	for(var/path in portal_storms)
		pool[path] = BSM_HIGH_WEIGHT_PORTAL
	for(var/spawner_path in subtypesof(/datum/round_event_control/spawners))
		pool[spawner_path] = BSM_HIGH_WEIGHT_SPAWNER
	pool[BSM_HIGH_THREAT_METEOR] = BSM_HIGH_WEIGHT_METEOR
	pool[BSM_HIGH_THREAT_CORE_EXPLOSION] = BSM_HIGH_WEIGHT_CORE_EXPLOSION
	return pool

/proc/bsm_spawn_meteor_at_miner(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/target = machine ? get_turf(machine) : null
	if(!target)
		return
	var/z = target.z
	var/startSide = pick(GLOB.cardinals)
	var/turf/pickedstart = spaceDebrisStartLoc(startSide, z)
	if(!pickedstart)
		return
	var/directionstring = "из неизвестного направления"
	switch(startSide)
		if(NORTH)
			directionstring = "с северной стороны"
		if(SOUTH)
			directionstring = "с южной стороны"
		if(EAST)
			directionstring = "с восточной стороны"
		if(WEST)
			directionstring = "с западной стороны"
	var/area/impact_area = get_area(target)
	var/area_name = impact_area?.name || "неизвестный сектор"
	priority_announce(
		"Крупный метеорит зафиксирован на курсе столкновения с [station_name()] — подход [directionstring]. Сенсоры связывают объект с нестабильностью блюспейс-майнеров; ожидаемая зона поражения: [area_name]. Инженерному отделу: подготовить ремонтные бригады.",
		"ВНИМАНИЕ: МЕТЕОРЫ",
		"meteors",
		has_important_message = TRUE,
	)
	var/meteor_type = pickweight(GLOB.meteors_threatening)
	new meteor_type(pickedstart, target)

/// Announced delayed detonation; mirrors inteq_vendomat: alert + beep + sparks, then explosion after 2s.
/proc/bsm_catastrophic_miner_explosion(obj/machinery/mineral/bluespace_miner/machine)
	if(QDELETED(machine))
		return
	var/turf/T = get_turf(machine)
	if(!T)
		return
	var/area/impact_area = get_area(T)
	var/area_name = impact_area?.name || "неизвестный сектор"
	priority_announce(
		"Каскадное блюспейс-разрушение в [area_name]. Силовой контур блюспейс-майнера [station_name()] теряет стабильность — ожидается детонация. Эвакуируйте персонал из зоны и готовьте инженерный ответ.",
		"ВНИМАНИЕ: КРИТИЧЕСКИЙ СБОЙ БЛЮСПЕЙС-МАЙНЕРА",
		'sound/machines/nuke/confirm_beep.ogg',
		has_important_message = TRUE,
	)
	machine.balloon_alert_to_viewers("КАТАСТРОФИЧЕСКИЙ СБОЙ СИЛОВОГО КОНТУРА!")
	playsound(T, 'sound/machines/nuke/confirm_beep.ogg', 65, TRUE, 1)
	do_sparks(3, TRUE, machine)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(bsm_explosion_miner_finish), machine), 2 SECONDS)

/proc/bsm_explosion_miner_finish(obj/machinery/mineral/bluespace_miner/machine)
	if(QDELETED(machine))
		return
	var/turf/T = get_turf(machine)
	if(!T)
		qdel(machine)
		return
	// Same radii as inteq_vendomat station wrench trap.
	explosion(T, 2, 4, 5, 8)
	if(!QDELETED(machine))
		qdel(machine)

/// Turf in the same area as the bluespace miner (mining "arena") for events that support spawn_location.
/proc/bsm_spawner_turf_near_miner(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return null
	var/area/mine_area = get_area(center)
	if(!mine_area)
		return center
	var/datum/anomaly_placer/placer = new()
	var/list/valid_turfs = list()
	for(var/turf/try_turf as anything in get_area_turfs(mine_area))
		if(!placer.is_valid_destination(try_turf))
			continue
		valid_turfs += try_turf
	if(length(valid_turfs))
		return pick(valid_turfs)
	for(var/turf/T in range(3, center))
		if(placer.is_valid_destination(T))
			return T
	return center

/proc/bsm_fire_high_threat_pick(obj/machinery/mineral/bluespace_miner/machine, picked)
	if(picked == BSM_HIGH_THREAT_METEOR)
		bsm_spawn_meteor_at_miner(machine)
		return
	if(picked == BSM_HIGH_THREAT_CORE_EXPLOSION)
		bsm_catastrophic_miner_explosion(machine)
		return
	if(ispath(picked, /datum/bsm_instability_effect))
		var/datum/bsm_instability_effect/effect = new picked()
		effect.trigger(machine)
		return
	var/datum/round_event_control/event_control = new picked()
	var/datum/round_event/running_event = event_control.runEvent(FALSE, increase_occurrences = FALSE)
	if(picked == /datum/round_event_control/spawners/nether && istype(running_event, /datum/round_event/spawners))
		var/datum/round_event/spawners/spawner_event = running_event
		spawner_event.spawn_location = bsm_spawner_turf_near_miner(machine)
