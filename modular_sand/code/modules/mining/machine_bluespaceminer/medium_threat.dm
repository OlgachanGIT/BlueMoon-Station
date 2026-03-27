GLOBAL_LIST_INIT(bsm_medium_threat_pool, list(
	/datum/bsm_instability_effect/medium/plasma_burp = 5,
	/datum/bsm_instability_effect/medium/nitrogen_burp = 10,
	/datum/bsm_instability_effect/medium/co2_vent = 10,
	/datum/bsm_instability_effect/medium/water_vapor_gust = 10,
	/datum/bsm_instability_effect/medium/cold_snap = 10,
	/datum/bsm_instability_effect/medium/nitrous_whiff = 10,
	/datum/bsm_instability_effect/medium/pressure_ping = 5,
))

/datum/bsm_instability_effect/medium

/datum/bsm_instability_effect/medium/plasma_burp

/datum/bsm_instability_effect/medium/plasma_burp/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	playsound(machine, 'sound/effects/bamf.ogg', 60, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	machine.balloon_alert_to_viewers("плазма!")
	machine.visible_message(span_warning("Блюспейс-майнер срыгивает облако плазмы!"))
	for(var/turf/open/open_turf in range(1, center))
		if(!open_turf.air)
			continue
		open_turf.air.adjust_moles(GAS_PLASMA, rand(15, 35))
		open_turf.air_update_turf()

/datum/bsm_instability_effect/medium/nitrogen_burp

/datum/bsm_instability_effect/medium/nitrogen_burp/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	playsound(machine, 'sound/effects/bamf.ogg', 55, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	machine.balloon_alert_to_viewers("холодный азот!")
	machine.visible_message(span_warning("Из блюспейс-майнера вырывается холодный азот!"))
	for(var/turf/open/open_turf in range(1, center))
		if(!open_turf.air)
			continue
		open_turf.air.adjust_moles(GAS_N2, rand(45, 85))
		open_turf.air_update_turf()

/datum/bsm_instability_effect/medium/co2_vent

/datum/bsm_instability_effect/medium/co2_vent/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	playsound(machine, 'sound/effects/bamf.ogg', 48, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	machine.balloon_alert_to_viewers("выброс CO₂!")
	machine.visible_message(span_warning("Блюспейс-майнер выпускает углекислый газ!"))
	for(var/turf/open/open_turf in range(1, center))
		if(!open_turf.air)
			continue
		open_turf.air.adjust_moles(GAS_CO2, rand(20, 45))
		open_turf.air_update_turf()

/datum/bsm_instability_effect/medium/water_vapor_gust

/datum/bsm_instability_effect/medium/water_vapor_gust/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	playsound(machine, 'sound/effects/bamf.ogg', 42, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	machine.balloon_alert_to_viewers("пар!")
	machine.visible_message(span_warning("Вокруг [machine] на секунду сгущается пар!"))
	for(var/turf/open/open_turf in range(1, center))
		if(!open_turf.air)
			continue
		open_turf.air.adjust_moles(GAS_H2O, rand(25, 55))
		open_turf.air_update_turf()

/datum/bsm_instability_effect/medium/cold_snap

/datum/bsm_instability_effect/medium/cold_snap/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	playsound(machine, 'sound/effects/glassbr1.ogg', 72, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	machine.balloon_alert_to_viewers("криогенный скачок!")
	machine.visible_message(span_warning("Блюспейс обрушивается в криогенный разряд — воздух вокруг [machine] на мгновение проваливается ниже нуля!"))
	for(var/turf/open/open_turf in range(3, center))
		if(!open_turf.air)
			continue
		var/new_temp = max(TCMB + 5, open_turf.air.return_temperature() - rand(75, 130))
		open_turf.air.set_temperature(new_temp)
		open_turf.air_update_turf()

/datum/bsm_instability_effect/medium/nitrous_whiff

/datum/bsm_instability_effect/medium/nitrous_whiff/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	playsound(machine, 'sound/effects/bamf.ogg', 40, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	machine.balloon_alert_to_viewers("сладкий газ...")
	machine.visible_message(span_warning("Сладковатый запах — в разломе мелькает закись азота!"))
	for(var/turf/open/open_turf in range(1, center))
		if(!open_turf.air)
			continue
		open_turf.air.adjust_moles(GAS_NITROUS, rand(8, 18))
		open_turf.air_update_turf()

/datum/bsm_instability_effect/medium/pressure_ping

/datum/bsm_instability_effect/medium/pressure_ping/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	machine.balloon_alert_to_viewers("скачок давления!")
	machine.visible_message(span_warning("Скачок давления и ослепительная вспышка от [machine]!"))
	do_sparks(rand(4, 8), FALSE, machine)
	playsound(center, 'sound/weapons/flashbang.ogg', 90, TRUE, 8, 0.9)
	new /obj/effect/dummy/lighting_obj (center, LIGHT_COLOR_WHITE, 9, 4, 2)
	var/obj/item/grenade/flashbang/simulated = new(center)
	simulated.flashbang_mobs(center, 7)
	qdel(simulated)
