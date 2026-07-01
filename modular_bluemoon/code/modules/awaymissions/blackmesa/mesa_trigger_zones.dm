// =============================================================================
// BLACK MESA TRIGGER ZONES
// Progressive difficulty system for ihategordon mission
// =============================================================================

// Trigger zone object - when a living player crosses it, difficulty increases
/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger
	name = "Difficulty Trigger Zone"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	invisibility = 0 // Visible for debugging, can be made invisible later
	anchored = TRUE
	density = FALSE
	var/trigger_id = 1 // 1-8 for progressive difficulty
	var/triggered = FALSE

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/Initialize(mapload)
	. = ..()
	if(trigger_id < 1 || trigger_id > 8)
		trigger_id = 1
	log_world("Black Mesa Trigger Zone #[trigger_id] initialized at [src]")

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/Crossed(atom/movable/AM)
	. = ..()
	if(triggered)
		return
	if(!AM)
		return
	// Only trigger for living players (not mobs or ghosts)
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	if(!L.client)
		return
	if(L.stat == DEAD)
		return

	// Trigger the difficulty increase
	triggered = TRUE
	log_world("Black Mesa Trigger Zone #[trigger_id] activated by [L]")
	increase_difficulty(trigger_id)

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/proc/increase_difficulty(trigger_level)
	if(!trigger_level)
		return
	if(!GLOB.zombie_director)
		log_world("ERROR: zombie_director is null when triggering difficulty")
		return

	var/datum/ai_director/zombie_mission/D = GLOB.zombie_director
	if(!D)
		return

	// Increase difficulty level in director
	D.difficulty_level = trigger_level

	// Announce the difficulty increase
	var/message = "ВНИМАНИЕ! Зафиксировано продвижение вглубь комплекса. Уровень угрозы повышен до [trigger_level]."
	SSblackmesa_events.mesa_announce(message, "Threat Level Increased", 'modular_bluemoon/sound/ambience/mesa/BMAS2.ogg')

	log_world("Black Mesa difficulty increased to level [trigger_level]")

// Define 8 trigger zones
/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger1
	name = "Difficulty Trigger 1"
	trigger_id = 1

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger2
	name = "Difficulty Trigger 2"
	trigger_id = 2

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger3
	name = "Difficulty Trigger 3"
	trigger_id = 3

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger4
	name = "Difficulty Trigger 4"
	trigger_id = 4

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger5
	name = "Difficulty Trigger 5"
	trigger_id = 5

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger6
	name = "Difficulty Trigger 6"
	trigger_id = 6

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger7
	name = "Difficulty Trigger 7"
	trigger_id = 7

/obj/effect/landmark/awaymission/blackmesa/difficulty_trigger/trigger8
	name = "Difficulty Trigger 8"
	trigger_id = 8
