// =============================================================================
// BLACK MESA ZOMBIE HORDE SYSTEM
// AI Director controlled zombie waves for ihategordon mission
// =============================================================================

// Parent infected mob type
/mob/living/simple_animal/hostile/infected
	name = "infected"
	desc = "A horrific creature that was once human."
	icon = 'modular_bluemoon/icons/mob/mesa_mobs.dmi'
	icon_state = "scientist_zombie"
	icon_living = "scientist_zombie"
	icon_dead = "zombie_dead"
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	faction = list(FACTION_XEN)
	turns_per_move = 1
	maxHealth = 100
	health = 100
	speed = 2
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/creatures/zombie_attack.ogg'
	speak = list('sound/creatures/zombie_idle1.ogg', 'sound/creatures/zombie_idle2.ogg', 'sound/creatures/zombie_idle3.ogg')
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	robust_searching = 1
	search_objects = 1
	wanted_objects = list(/obj/structure/urbanism_generator)
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	gold_core_spawnable = NO_SPAWN
	density = TRUE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	var/is_runner = FALSE
	// Allow zombies to climb tables and stack on same tile
	pass_flags = PASSTABLE
	pass_flags_self = NONE

/mob/living/simple_animal/hostile/infected/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/swarming)
	// Initialize wanted_objects typecache at runtime to avoid constant-expression compile errors
	wanted_objects = typecacheof(wanted_objects, TRUE)

/mob/living/simple_animal/hostile/infected/death(gibbed)
	. = ..(gibbed)
	if(!ckey)
		toggle_ai(AI_OFF)

/mob/living/simple_animal/hostile/infected/Aggro()
	. = ..()
	if(speak && speak.len && prob(30))
		playsound(src, pick(speak), 70, TRUE)

/mob/living/simple_animal/hostile/infected/Bump(atom/A)
	. = ..()
	// Fence climbing mechanic
	if(istype(A, /obj/structure/fence))
		var/obj/structure/fence/F = A
		if(!F || !F.density)
			return
		// Check if we can climb over
		if(prob(60) && !stat)
			visible_message("<span class='danger'>[src] starts climbing over [F]!</span>")
			// Climbing delay similar to table climbing
			if(do_after(src, 15, target = F))
				if(QDELETED(src) || QDELETED(F))
					return
				visible_message("<span class='danger'>[src] climbs over [F]!</span>")
				var/turf/target_turf = get_step(F, src.dir)
				if(target_turf && !target_turf.density)
					forceMove(target_turf)

// =============================================================================
// TIER 1: RUNNER ZOMBIE (DEPRECATED - No longer spawned)
// Fast, low HP, high sight, dense-stacking, can climb fences
// =============================================================================
/mob/living/simple_animal/hostile/infected/runner
	name = "runner infected"
	desc = "A fast-moving infected creature. It moves with terrifying speed."
	icon = 'modular_bluemoon/icons/mob/mesa_mobs.dmi'
	icon_state = "hecu_zombie"
	icon_living = "hecu_zombie"
	maxHealth = 60
	health = 60
	speed = 0
	melee_damage_lower = 8
	melee_damage_upper = 12
	sight = 20
	robust_searching = 1
	is_runner = TRUE

// =============================================================================
// TIER 2: BRUISER ZOMBIE
// Slower, high HP, standard sight, normal movement
// =============================================================================
/mob/living/simple_animal/hostile/infected/bruiser
	name = "bruiser infected"
	desc = "A heavily built infected creature with thick muscle mass. It can take a lot of punishment."
	icon = 'modular_bluemoon/icons/mob/gonome.dmi'
	icon_state = "former_gonome"
	icon_living = "former_gonome"
	icon_dead = "former_dead"
	maxHealth = 300
	health = 300
	speed = 3
	melee_damage_lower = 15
	melee_damage_upper = 25
	sight = 9
	robust_searching = 1
	environment_smash = ENVIRONMENT_SMASH_WALLS
	harm_intent_damage = 20
	obj_damage = 40

/mob/living/simple_animal/hostile/infected/bruiser/Aggro()
	. = ..()
	if(speak && speak.len && prob(40))
		playsound(src, pick(speak), 80, TRUE)

/mob/living/simple_animal/hostile/infected/bruiser/alt
	icon_state = "former_gonome_alt"
	icon_living = "former_gonome_alt"
