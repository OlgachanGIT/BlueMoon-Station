GLOBAL_LIST_INIT(bsm_low_threat_pool, list(
	/datum/bsm_instability_effect/low/plush_delight = 5,
	/datum/bsm_instability_effect/low/lambda_resonance = 5,
	/datum/bsm_instability_effect/low/crowbar_echo = 10,
	/datum/bsm_instability_effect/low/xen_snark_chitter = 10,
	/datum/bsm_instability_effect/low/portal_cake_rift = 10,
	/datum/bsm_instability_effect/low/prism_rainbow = 5,
	/datum/bsm_instability_effect/low/voids_embrace = 5,
))

/datum/bsm_instability_effect/low

/datum/bsm_instability_effect/low/proc/play_bluespace_sparks(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/T = get_turf(machine)
	if(!T)
		return
	playsound(T, 'sound/effects/sparks4.ogg', 100, 1)
	var/datum/effect_system/spark_spread/quantum/sparks = new
	sparks.set_up(10, 1, T)
	sparks.attach(T)
	sparks.start()

/datum/bsm_instability_effect/low/plush_delight

/datum/bsm_instability_effect/low/plush_delight/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/drop = get_turf(machine)
	if(!drop)
		return
	if(!LAZYLEN(GLOB.valid_plushie_paths))
		return
	var/plush_type = pick(GLOB.valid_plushie_paths)
	new plush_type(drop)
	playsound(machine, pick(GLOB.otherworld_sounds), 88, TRUE, 3)
	play_bluespace_sparks(machine)
	machine.balloon_alert_to_viewers("плюшка из разлома!")
	machine.visible_message(span_notice("Рядом с [machine] мерцает крошечный блюспейс-разлом, из которого выпадает мягкая игрушка!"))

/datum/bsm_instability_effect/low/lambda_resonance

/datum/bsm_instability_effect/low/lambda_resonance/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/T = get_turf(machine)
	if(!T)
		return
	playsound(T, 'modular_bluemoon/sound/ambience/mesa/mesaxenlab.ogg', 62, TRUE, 3)
	play_bluespace_sparks(machine)
	machine.balloon_alert_to_viewers("λ-гул из ниоткуда!")
	machine.visible_message(span_notice("Слышен гул, будто λ-резонанс из чужого отчёта — ЦК бы не оценило, но вреда ноль."))

/datum/bsm_instability_effect/low/crowbar_echo

/datum/bsm_instability_effect/low/crowbar_echo/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/T = get_turf(machine)
	if(!T)
		return
	playsound(T, 'modular_bluemoon/sound/weapons/mesa/crowbar2.ogg', 78, TRUE, 3)
	play_bluespace_sparks(machine)
	machine.balloon_alert_to_viewers("стук монтировки!")
	machine.visible_message(span_notice("Где-то в шуме блюспейса проступает стук монтировки по металлу."))

/datum/bsm_instability_effect/low/xen_snark_chitter

/datum/bsm_instability_effect/low/xen_snark_chitter/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/T = get_turf(machine)
	if(!T)
		return
	playsound(T, 'modular_bluemoon/sound/creatures/mesa/snark/snark2.ogg', 72, TRUE, 3)
	play_bluespace_sparks(machine)
	machine.balloon_alert_to_viewers("треск снарка?")
	machine.visible_message(span_notice("Из разлома доносится треск мелкой твари с другого пласта реальности — она явно не добралась до вас."))

/datum/bsm_instability_effect/low/portal_cake_rift

/datum/bsm_instability_effect/low/portal_cake_rift/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/drop = get_turf(machine)
	if(!drop)
		return
	new /obj/item/reagent_containers/food/snacks/cakeslice/plain(drop)
	playsound(machine, 'modular_bluemoon/sound/creatures/mesa/headcrab/die1.ogg', 58, TRUE, 3)
	play_bluespace_sparks(machine)
	machine.balloon_alert_to_viewers("Still Alive, huh?")
	machine.visible_message(span_notice("Блюспейс-майнер выдавливает ломтик торта. Протокол испытаний Aperture неприменим — сладкое настоящее."))

#define BSM_LOW_EFFECT_DURATION 20 SECONDS
#define BSM_VOIDS_HEART_PULSES 40

/datum/bsm_instability_effect/low/prism_rainbow/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/T = get_turf(machine)
	if(!T)
		return
	play_bluespace_sparks(machine)
	machine.bsm_rainbow_until = world.time + BSM_LOW_EFFECT_DURATION
	machine.update_icon()
	machine.balloon_alert_to_viewers("радужная вспышка!")
	machine.visible_message(span_notice("Корпус [machine] долго переливается всеми цветами — ослепительно, но безвредно."))

/datum/bsm_instability_effect/low/voids_embrace/trigger(obj/machinery/mineral/bluespace_miner/machine)
	var/turf/T = get_turf(machine)
	if(!T)
		return
	playsound(T, 'sound/ambience/VoidsEmbrace.ogg', 72, TRUE, 6)
	play_bluespace_sparks(machine)
	var/pulse_spacing = BSM_LOW_EFFECT_DURATION / BSM_VOIDS_HEART_PULSES
	for(var/i in 1 to BSM_VOIDS_HEART_PULSES)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(bsm_voids_embrace_heart_tick), machine), (i - 1) * pulse_spacing)
	if(machine.bs_core)
		machine.bs_core.obj_integrity = min(machine.bs_core.obj_integrity + 10, machine.bs_core.max_integrity)
		machine.update_icon()
	machine.balloon_alert_to_viewers("объятия пустоты...")
	machine.visible_message(span_notice("Вокруг [machine] долго взмывают призрачные сердца, а блюспейс-ядро на миг стабилизируется."))

/proc/bsm_voids_embrace_heart_tick(obj/machinery/mineral/bluespace_miner/machine)
	if(QDELETED(machine))
		return
	var/turf/heart_turf = get_turf(machine)
	if(!heart_turf)
		return
	new /obj/effect/temp_visual/heart(heart_turf)

#undef BSM_LOW_EFFECT_DURATION
#undef BSM_VOIDS_HEART_PULSES
