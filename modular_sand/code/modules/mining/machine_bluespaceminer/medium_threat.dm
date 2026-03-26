/// Instability [BSM_INSTABILITY_TIER_MEDIUM]–[BSM_INSTABILITY_TIER_HIGH): minor hazards.

GLOBAL_LIST_INIT(bsm_medium_threat_pool, list(
	/datum/bsm_instability_effect/medium/plasma_burp = 70,
	/datum/bsm_instability_effect/medium/pressure_ping = 30,
))

/datum/bsm_instability_effect/medium

/datum/bsm_instability_effect/medium/plasma_burp

/datum/bsm_instability_effect/medium/plasma_burp/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/center = get_turf(machine)
	if(!center)
		return
	playsound(machine, 'sound/effects/bamf.ogg', 60, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	machine.visible_message(span_warning("Блюспейс-майнер срыгивает облако плазмы!"))
	for(var/turf/open/open_turf in range(1, center))
		if(!open_turf.air)
			continue
		open_turf.air.adjust_moles(GAS_PLASMA, rand(15, 35))
		open_turf.air_update_turf()

/datum/bsm_instability_effect/medium/pressure_ping

/datum/bsm_instability_effect/medium/pressure_ping/trigger(obj/machinery/mineral/bluespace_miner/machine)
	playsound(machine, 'sound/machines/chime.ogg', 55, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	machine.visible_message(span_warning("Скачок давления вокруг [machine] бьёт по ушам!"))
	for(var/mob/living/carbon/human/H in hearers(7, machine))
		H.adjustEarDamage(rand(1, 3), rand(0, 1))
