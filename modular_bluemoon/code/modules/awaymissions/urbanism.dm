/turf/closed/mineral/mesarock
	name = "rock"
	icon = 'icons/turf/mining.dmi'
	smooth_icon = 'icons/turf/walls/rock_wall.dmi'
	icon_state = "rockyash"
	smooth = SMOOTH_MORE|SMOOTH_BORDER
	canSmoothWith = list (/turf/closed)
	var/resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	explosion_block = 50
	wave_explosion_block = INFINITY

/turf/closed/mineral/mesarock/rust_heretic_act()
	return

/turf/closed/mineral/mesarock/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/closed/mineral/mesarock/acid_act(acidpwr, acid_volume, acid_id)
	return FALSE

/turf/closed/mineral/mesarock/acid_melt()
	return

/turf/closed/mineral/mesarock/Melt()
	to_be_destroyed = FALSE
	return src

/turf/closed/mineral/mesarock/singularity_act()
	return

/turf/closed/mineral/mesarock/attackby(obj/item/pickaxe/I, mob/user, params)
	return

/turf/closed/mineral/mesarock/attack_hand(mob/user)
	return

/turf/closed/mineral/mesarock/gets_drilled()
	return

/turf/closed/mineral/mesarock/attack_animal(mob/living/simple_animal/user, list/modifiers)
	return

/turf/closed/mineral/mesarock/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	return

/turf/closed/mineral/mesarock/attack_hulk(mob/living/carbon/human/H)
	return FALSE

/turf/closed/mineral/mesarock/ex_act(severity, target, origin)
	return

/obj/machinery/power/floodlight/urbanismlight
	name = "Floodlight"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "oldfloodlight"
	anchored = TRUE
	armor = list(MELEE = 30, BULLET =30, LASER = 20, ENERGY = 10, BOMB = 30, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)

/obj/machinery/power/floodlight/urbanismlight/mesaspec
	icon_state = "oldfloodlight_on"
	layer = 4
	light_range = 15
	light_color = "#ffffdd"
	max_integrity = 9999999


/obj/structure/closet/crate/urbanismcrate
	name = "military crate"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "milcrate"

/obj/structure/closet/crate/large/urbanismcratelarge
	name = "big box"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "box"

/obj/structure/closet/crate/large/urbanismcratelarge/mil
	name = "big military box"
	icon_state = "boxmil"

/obj/structure/urbanismdamagedbarrel
	name = "Old rusty barrel"
	desc = "An old barrel with some junk in"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "drumfire"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 30, BULLET =30, LASER = 20, ENERGY = 10, BOMB = 30, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)

/obj/structure/reagent_dispensers/urbanismbarrel
	name = "Barrel"
	desc = "Typical barrel. Contains... Something"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "barrel"
	anchored = TRUE
	armor = list(MELEE = 60, BULLET =50, LASER = 10, ENERGY = 10, BOMB = 30, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)

/obj/structure/reagent_dispensers/urbanismbarrel/red
	icon_state = "redbarrel"
	reagent_id = /datum/reagent/fuel
	tank_volume = 300

/obj/structure/barricade/urbanism
	name = "Barricade"
	desc = "Basic barricade meant to protect idiots like you from danger."
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "crowd_barrier"
	anchored = TRUE
	density = TRUE
	pass_flags_self = LETPASSTHROW
	max_integrity = 280
	proj_pass_rate = 20
	climbable = TRUE
	armor = list(MELEE = 30, BULLET =40, LASER = 10, ENERGY = 10, BOMB = 30, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)

/obj/structure/barricade/urbanism/roadblock
	resistance_flags = INDESTRUCTIBLE
	icon_state = "concrete"

/obj/structure/urbanismpile
	name = "Trash Crate"
	desc = "Crate full of trash... Found someone?"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "dumpsteropen_halffull"
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	density = TRUE

/obj/structure/urbanismtire
	name = "Tire"
	desc = "Tire for cars and fireplaces"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "shina"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 20, BULLET =40, LASER = 10, ENERGY = 10, BOMB = 30, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)

/obj/structure/urbanismpower
	name = "Power Line"
	desc = "Эта необычная старая вышка обеспечивает электричеством то место, где вы сейчас находитесь"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism_structure32x64.dmi'
	icon_state = "powerline"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 50, BULLET =40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	layer = SPACEVINE_LAYER

/obj/structure/urbanismpower/transformer
	name = "Power transformer"
	desc = "электротехническое устройство в сетях электроснабжения с двумя или более обмотками, который посредством электромагнитной индукции преобразует одну величину переменного напряжения и тока в другую величину переменного напряжения и тока, той же частоты без изменения её передаваемой мощности"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism_structure32x64.dmi'
	icon_state = "powertransformer"

/obj/structure/urbanismbigcrate
	name = "Big boxes"
	desc = "One big box with one smaller on it. Honestly, they are empty"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism_structure32x64.dmi'
	icon_state = "crate"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 50, BULLET =40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	layer = SPACEVINE_LAYER

/obj/structure/urbanismbigcrate/alt
	name = "heavy boxes"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "boxalt"


/obj/structure/urbanismcars
	name = "Damaged car"
	desc = "Just lost in time broken (and bit rusty) vehicle"
	icon = 'modular_bluemoon/icons/obj/urbanism/vehicles140x140.dmi'
	icon_state = "car_wreck"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 70, BULLET =60, LASER = 50, ENERGY = 80, BOMB = 50, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)
	layer = SPACEVINE_LAYER

/obj/structure/urbanismradio
	name = "Radio"
	desc = "Big rusty radio tower"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism_structure32x64.dmi'
	icon_state = "radio"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 50, BULLET =40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	layer = SPACEVINE_LAYER


/obj/structure/urbanismdisplay
	name = "Black mesa based display"
	desc = "Looks like black mesa BIOS is sucks."
	icon = 'modular_bluemoon/icons/obj/urbanism/mesa_display.dmi'
	icon_state = "display_broken"
	anchored = TRUE
	density = FALSE
	armor = list(MELEE = 50, BULLET =40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	light_range = 5
	light_color = "#2652e2"
	max_integrity = 9999999
	layer = SPACEVINE_LAYER

/obj/structure/urbanismdisplay/urbanismchalk
	name = "Big chalkboard"
	desc = "Here is many of symbols and text... You barely can understand this smart words and scientific formulas"
	icon = 'modular_bluemoon/icons/obj/urbanism/mesa_display.dmi'
	icon_state = "chalkboard"
	anchored = TRUE
	density = FALSE
	armor = list(MELEE = 50, BULLET =40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	light_range = FALSE
	light_color = FALSE
	max_integrity = FALSE

/obj/structure/urbanismmachines
	name = "old machine"
	desc = "some kind of old (and sometimes broken) machine"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "server_desrtoyed"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 30, BULLET =50, LASER = 30, ENERGY = 20, BOMB = 70, BIO = 15, RAD = 10, FIRE = 40, ACID = 30)

/obj/structure/urbanismmachines/server
	name = "old server"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism_structure32x64.dmi'
	icon_state = "server"

/obj/structure/urbanismmounted
	name = "Mounted kind of machine"
	desc = "here's many terminals and generators... Be careful"
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "terminal_broken"
	anchored = TRUE
	density = FALSE
	armor = list(MELEE = 30, BULLET =50, LASER = 30, ENERGY = 20, BOMB = 70, BIO = 15, RAD = 10, FIRE = 40, ACID = 30)

/obj/structure/urbanismbillboard
	name = "Big billboard"
	desc = "YOUR AD COULD BE HERE!"
	icon = 'modular_bluemoon/icons/obj/urbanism/bilboards.dmi'
	icon_state = "bilboard1"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 80, BULLET =80, LASER = 70, ENERGY = 60, BOMB = 80, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	light_range = FALSE
	light_color = FALSE
	max_integrity = FALSE
	layer = SPACEVINE_LAYER


/obj/structure/rockpilemesa
	name = "large rocks"
	icon_state = "rocks"
	icon = 'modular_bluemoon/icons/obj/urbanism/stone.dmi'
	icon_state = "stone1"
	color = "#f79668"

/obj/effect/turf_decal/misc/brokenwalls
	name = "crushed wall"
	icon = 'modular_bluemoon/icons/obj/urbanism/decals.dmi'
	icon_state = "brokenwall2"

/obj/effect/turf_decal/misc/brokenwalls/alt
	icon_state = "brokenwall1"


/obj/effect/turf_decal/weather/rock
	name = "rocks"
	icon = 'modular_bluemoon/icons/obj/urbanism/decals.dmi'
	icon_state = "rock"

/obj/structure/mesaflora
	name = "bush"
	desc = "A wild plant that is found in jungles."
	icon = 'modular_bluemoon/icons/obj/urbanism/flora.dmi'
	icon_state = "flora1"
	anchored = TRUE
	density = FALSE

/obj/structure/deadmesa
	name = "Damaged body"
	desc = "Horrific consequences of Resonance Cascade."
	icon = 'modular_bluemoon/icons/obj/urbanism/deadhuman.dmi'
	icon_state = "deadhecu"
	anchored = TRUE
	density = FALSE
	armor = list(MELEE = 50, BULLET =40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	var/loot_amount = 2
	var/scavenge_time = 5 SECONDS
	var/can_use_hands = TRUE
	var/looted = FALSE
	var/list/loot = list(
		/obj/item/ammo_box/magazine/p90 = 10,
		/obj/item/ammo_box/magazine/mp5 = 10,
		/obj/item/grenade/frag = 5,
		/obj/item/ammo_box/magazine/scar = 8,
		/obj/item/ammo_box/magazine/fal/r10 = 8,
		/obj/item/clothing/shoes/jackboots = 15,
		/obj/item/storage/firstaid/regular = 5,
		/obj/item/ammo_box/magazine/m50 = 7,
		/obj/item/ammo_box/magazine/pistolm9mm = 12,
		/obj/item/clothing/gloves/combat = 10,
		/obj/item/gun/ballistic/automatic/pistol/hl9mm = 3
	)

/obj/structure/deadmesa/examine(mob/user)
	. = ..()

/obj/structure/deadmesa/attack_hand(mob/user)
	if(!user)
		return
	if(looted)
		to_chat(user, span_warning("Этот труп уже обыскан."))
		return
	. = ..()
	if(!looted)
		looted = TRUE
		desc = "Horrific consequences of Resonance Cascade. Этот труп уже обыскан."

/obj/structure/deadmesa/ComponentInitialize()
	. = ..()
	if(loot)
		AddElement(/datum/element/scavenging, loot_amount, loot, null, scavenge_time, can_use_hands, null, null, FALSE, NO_LOOT_RESTRICTION, 1)

/obj/structure/deadmesa/attackby(obj/item/I, mob/user, params)
	if(looted)
		to_chat(user, span_warning("Этот труп уже обыскан."))
		return
	. = ..()
	if(!looted)
		looted = TRUE
		desc = "Horrific consequences of Resonance Cascade. Этот труп уже обыскан."

/obj/structure/deadmesa/hecughost
	name = "Призрак лидера отряда HECU"
	desc = "Он точно потерялся... И он точно перепутал гейт Blackmesa с ihategordon. Появится ли blackmesa и тут? Что значит призрак этого парня? Зачем вы читаете его описание?"
	icon_state = "Hecughost"


/obj/structure/urbanismeffect
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanismmisc.dmi'
	icon_state = "red_big"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	move_resist = INFINITY
	obj_flags = 0

	vis_flags = VIS_INHERIT_PLANE

/obj/structure/urbanismeffect/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	return

/obj/structure/urbanismeffect/fire_act(exposed_temperature, exposed_volume)
	return

/obj/structure/urbanismeffect/acid_act()
	return

/obj/structure/urbanismeffect/blob_act(obj/structure/blob/B)
	return

/obj/structure/urbanismeffect/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	return FALSE

/obj/structure/urbanismeffect/experience_pressure_difference()
	return

/obj/structure/urbanismeffect/singularity_act()
	return FALSE

/obj/structure/urbanismeffect/ex_act(severity, target, origin)
	return

/obj/structure/urbanismeffect/ConveyorMove()
	return

/obj/structure/urbanismeffect/abstract

//заебала эта хуета с сломанными стейтами блять.
/obj/structure/flora/grass/snowgrass
	name = "snowy grass"
	desc = "A patch of overgrown grass."
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowgrass"

/obj/structure/urbanismhuge
	name = "huge construction"
	desc = "Oh my god, what a huge construction is this?"
	icon = 'modular_bluemoon/icons/obj/urbanism/hugeshit.dmi'
	icon_state = "huge1"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 100, BULLET =100, LASER = 100, ENERGY = 60, BOMB = 80, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	light_range = FALSE
	light_color = FALSE
	max_integrity = FALSE
	layer = SPACEVINE_LAYER


/obj/structure/urbanismmachinery
	name = "heavy machinery"
	desc = "Huge piece of machinery, probably used in construction works."
	icon = 'modular_bluemoon/icons/obj/urbanism/communication.dmi'
	icon_state = "communication"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 100, BULLET =100, LASER = 100, ENERGY = 60, BOMB = 80, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	light_range = FALSE
	light_color = FALSE
	max_integrity = FALSE
	layer = SPACEVINE_LAYER

/obj/structure/urbanismfabricator
	name = "heavy machinery"
	desc = "Huge piece of machinery, probably used in construction works."
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanismmachinery.dmi'
	icon_state = "hugem1"
	anchored = TRUE
	density = TRUE
	armor = list(MELEE = 100, BULLET =100, LASER = 100, ENERGY = 60, BOMB = 80, BIO = 10, RAD = 0, FIRE = 50, ACID = 50)
	light_range = FALSE
	light_color = FALSE
	max_integrity = FALSE
	layer = SPACEVINE_LAYER

/obj/machinery/negotiations_radio
	name = "negotiations radio"
	desc = "An old radio."
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "radiohecu"
	anchored = TRUE
	density = TRUE
	var/list/negotiation_sounds = list(
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter1.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter2.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter3.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter4.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter6.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter7.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter8.ogg',
		'modular_bluemoon/sound/creatures/mesa/hecuchatter/chatter9.ogg'
	)
	var/next_play_time = 0

/obj/machinery/negotiations_radio/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/machinery/negotiations_radio/process()
	if(world.time >= next_play_time)
		icon_state = "radiohecu_talking"
		var/sound_to_play = pick(negotiation_sounds)
		playsound(src, sound_to_play, 70, FALSE, 7, 3)
		addtimer(CALLBACK(src, .proc/reset_icon), 2 SECONDS)
		next_play_time = world.time + rand(10 SECONDS, 25 SECONDS)

/obj/machinery/negotiations_radio/proc/reset_icon()
	icon_state = initial(icon_state)

/obj/machinery/negotiations_radio/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/microwaveexplosive
	name = "suspicious microwave"
	desc = "This microwave looks... off. Better not touch it."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	density = TRUE
	anchored = TRUE

/obj/structure/microwaveexplosive/attack_hand(mob/user)
	. = ..()

	playsound(src, 'modular_bluemoon/sound/creatures/mesa/madsci/microwaveboom.ogg', 100, FALSE)


	for(var/obj/structure/mad_scientist/scientist in range(5, src))
		playsound(scientist, 'modular_bluemoon/sound/creatures/mesa/madsci/microwavefuck.ogg', 150, FALSE)

	explosion(src, 0, 0, 1, 1, flame_range =1)

	new /obj/effect/hotspot(get_turf(src))

	icon_state = "mwbloodyo"
	new /obj/structure/urbanismeffect(get_turf(src))

/obj/structure/mad_scientist
	name = "mad scientist"
	desc = "A deranged scientist who seems to be working on something dangerous."
	icon = 'modular_bluemoon/icons/mob/mesa_mobs.dmi'
	icon_state = "madscientist"
	density = TRUE
	anchored = TRUE

/obj/structure/mad_scientist/attack_hand(mob/user)
	. = ..()

	// Play mad scientist sound
	playsound(src, 'modular_bluemoon/sound/creatures/mesa/madsci/scimad.ogg', 100, FALSE)

//Super idol 的笑容 都沒你的甜
//八月正午的陽光 都沒你耀眼
//熱愛105度的你
//滴滴清純的蒸餾水

/obj/structure/fence/nocut
	name = "reinforced fence"
	desc = "A chain link fence reinforced to prevent cutting."
	cuttable = FALSE


/obj/structure/reagent_dispensers/urbanismbarrel/radium
	name = "Radium barrel"
	desc = "Barrel filled with radium. Very dangerous."
	icon_state = "radiumbarrel"
	reagent_id = /datum/reagent/radium
	tank_volume = 300
	var/rad_strength = 1000

/obj/structure/reagent_dispensers/urbanismbarrel/radium/Initialize(mapload)
	. = ..()
	var/datum/component/radioactive/Comp
	AddComponent(/datum/component/radioactive, 0, src, 0, TRUE)
	Comp = GetComponent(/datum/component/radioactive)
	Comp.set_strength(rad_strength)

// =============================================================================
// URBANISM GENERATOR SYSTEM
// Special generator that can be activated by players to spawn loot or open doors
// =============================================================================

/obj/structure/urbanism_generator
	name = "generator"
	desc = "A strange generator. Activate it with an empty hand."
	icon = 'modular_bluemoon/icons/obj/urbanism/urbanism.dmi'
	icon_state = "generatorold"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	max_integrity = 9999999

	// Activation settings
	var/activation_time = 60 SECONDS
	var/active_duration = 60 SECONDS
	var/damage_threshold = 50 // Damage needed to interrupt activation

	// State tracking
	var/activating = FALSE
	var/active = FALSE
	var/activation_start_time = 0
	var/next_mob_spawn_time = 0
	var/damage_taken = 0

	// Mob wave settings
	var/spawn_mobs = FALSE
	var/list/mob_types = list()
	var/mob_spawn_interval = 10 SECONDS
	var/max_mobs_per_wave = 5

	// Reward settings
	var/reward_type = null
	var/blastdoor_id = null

/obj/structure/urbanism_generator/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/urbanism_generator/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/urbanism_generator/process()
	if(!active)
		return

	if(world.time >= activation_start_time + active_duration)
		finish_activation()
		return

	// Spawn mobs during activation
	if(spawn_mobs && mob_types && mob_types.len)
		if(world.time >= next_mob_spawn_time)
			spawn_mob_wave()

/obj/structure/urbanism_generator/attack_hand(mob/user)
	if(!user)
		return

	if(active)
		to_chat(user, span_warning("Генератор уже активирован!"))
		return

	if(activating)
		to_chat(user, span_warning("Генератор уже запускается!"))
		return

	// Check if user has empty hands
	if(user.get_active_held_item())
		to_chat(user, span_warning("Вам нужны пустые руки для активации генератора."))
		return

	start_activation(user)

/obj/structure/urbanism_generator/proc/start_activation(mob/user)
	if(!src || !user)
		return

	activating = TRUE
	damage_taken = 0
	to_chat(user, span_notice("Вы начинаете активировать генератор..."))

	playsound(src, 'modular_bluemoon/sound/creatures/mesa/generator/generator_start.ogg', 50, TRUE)

	if(do_after(user, activation_time, target = src, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_HELD_ITEM | IGNORE_INCAPACITATED))
		if(QDELETED(src) || QDELETED(user))
			activating = FALSE
			return

		begin_active_phase()
	else
		activating = FALSE
		to_chat(user, span_warning("Активация прервана!"))

/obj/structure/urbanism_generator/proc/begin_active_phase()
	if(!src)
		return

	activating = FALSE
	active = TRUE
	activation_start_time = world.time
	damage_taken = 0
	next_mob_spawn_time = world.time + mob_spawn_interval

	visible_message(span_boldnotice("Генератор активирован!"))

	// Open blastdoor immediately if this generator is linked to one
	if(blastdoor_id)
		open_blastdoor()

	// Play active sound
	playsound(src, 'modular_bluemoon/sound/creatures/mesa/generator/generator_sputter.ogg', 50, TRUE)

/obj/structure/urbanism_generator/proc/finish_activation()
	if(!src)
		return

	active = FALSE
	icon_state = "generatorold"
	visible_message(span_boldnotice("Генератор завершил работу!"))

	// Give reward
	if(reward_type)
		spawn_reward()

/obj/structure/urbanism_generator/proc/spawn_reward()
	if(!src || !reward_type)
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	new reward_type(T)
	visible_message(span_notice("Из генератора выпал предмет!"))

/obj/structure/urbanism_generator/proc/open_blastdoor()
	if(!src || !blastdoor_id)
		return

	// Find and open blastdoor with matching ID.
	// Many door subclasses declare `id` (poddoor, brig/window doors, windowdoor),
	// so iterate atoms and cast to the known subclasses before accessing `id`.
	for(var/obj/machinery/door/poddoor/D in GLOB.machines)
		if(D && D.id == blastdoor_id)
			D.open()
			visible_message(span_notice("Дверь [blastdoor_id] открылась!"))
			return
	for(var/obj/machinery/door/window/brigdoor/W in GLOB.machines)
		if(W && W.id == blastdoor_id)
			W.open()
			visible_message(span_notice("Дверь [blastdoor_id] открылась!"))
			return
	// Note: do not iterate the generic /obj/machinery/door/window class because
	// it does not declare `id` — brigdoor subclass above covers window doors with IDs.

/obj/structure/urbanism_generator/proc/get_spawn_count_for_difficulty()
	if(!src)
		return 1

	var/max_count = max(1, max_mobs_per_wave)
	var/difficulty = 0
	var/datum/ai_director/zombie_mission/director = GLOB.zombie_director
	if(director)
		difficulty = director.difficulty_level

	switch(difficulty)
		if(0)
			return rand(1, min(2, max_count))
		if(1)
			return rand(1, min(3, max_count))
		if(2)
			return rand(2, min(4, max_count))
		if(3)
			return rand(2, min(5, max_count))
		if(4)
			return rand(3, min(6, max_count))
		if(5)
			return rand(3, min(7, max_count))
		else
			return rand(4, max_count)

/obj/structure/urbanism_generator/proc/spawn_mob_wave()
	if(!src)
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	if(!mob_types || !mob_types.len)
		return

	var/mobs_to_spawn = get_spawn_count_for_difficulty()
	if(mobs_to_spawn < 1)
		mobs_to_spawn = 1

	for(var/i = 1; i <= mobs_to_spawn; i++)
		var/mob_type = pick(mob_types)
		if(!mob_type)
			continue

		var/turf/spawn_turf = get_step(T, pick(GLOB.cardinals))
		if(!spawn_turf)
			continue
		if(spawn_turf.density || spawn_turf.is_blocked_turf())
			continue

		var/mob/living/M = new mob_type(spawn_turf)
		if(!M)
			continue

		new /obj/effect/temp_visual/dir_setting/ninja/phase(spawn_turf)
		playsound(spawn_turf, 'sound/magic/Teleport_app.ogg', 50, TRUE)

	next_mob_spawn_time = world.time + mob_spawn_interval

/obj/structure/urbanism_generator/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if(!src)
		return

	if(!active && !activating)
		return ..()

	damage_taken += damage_amount

	if(damage_taken >= damage_threshold)
		interrupt_activation()

	return ..()

/obj/structure/urbanism_generator/proc/interrupt_activation()
	if(!src)
		return

	active = FALSE
	activating = FALSE
	icon_state = "generatorold"
	damage_taken = 0

	visible_message(span_danger("Генератор был повреждён и остановлен!"))
	playsound(src, 'modular_bluemoon/sound/creatures/mesa/generator/generator_sputter.ogg', 50, TRUE)

// =============================================================================
// GENERATOR WITH REWARD
// Spawns a loot item after activation
// =============================================================================

/obj/structure/urbanism_generator/reward
	name = "supply generator"
	desc = "A generator that dispenses supplies when activated."
	reward_type = /obj/item/storage/firstaid/regular
	spawn_mobs = TRUE
	mob_types = list(
		/mob/living/simple_animal/hostile/infected,
		/mob/living/simple_animal/hostile/infected/bruiser
	)

/obj/structure/urbanism_generator/reward/weapon
	name = "weapon generator"
	reward_type = /obj/item/gun/ballistic/automatic/pistol/hl9mm

/obj/structure/urbanism_generator/reward/medical
	name = "medical generator"
	reward_type = /obj/item/storage/firstaid/regular

// =============================================================================
// GENERATOR AS BUTTON
// Opens blastdoor after activation, no reward
// =============================================================================

/obj/structure/urbanism_generator/button
	name = "door generator"
	desc = "A generator that opens a blastdoor when activated."
	blastdoor_id = "urbanism_door_1"
	reward_type = null
	spawn_mobs = TRUE
	mob_types = list(
		/mob/living/simple_animal/hostile/infected,
		/mob/living/simple_animal/hostile/infected/bruiser
	)

/obj/structure/urbanism_generator/button/alt
	name = "secondary door generator"
	blastdoor_id = "urbanism_door_2"

/obj/structure/urbanism_generator/continuous
	name = "hive generator"
	desc = "A generator that continuously spawns infected while active."
	reward_type = null
	spawn_mobs = TRUE
	mob_types = list(
		/mob/living/simple_animal/hostile/infected,
		/mob/living/simple_animal/hostile/infected/bruiser
	)
	mob_spawn_interval = 10 SECONDS
	max_mobs_per_wave = 2
	active_duration = 120 SECONDS

/turf/closed/wall/r_wall/blackmesa
	name = "indestructible reinforced wall"
	desc = "An extremely reinforced wall that cannot be dismantled by any means."
	icon = 'icons/turf/walls/reinforced_wall.dmi'
	icon_state = "r_wall"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/turf/closed/wall,
		/turf/closed/wall/r_wall,
		/turf/closed/wall/r_wall/blackmesa,
		/turf/closed/wall/r_wall/rust,
		/turf/closed/wall/rust
	)
	var/resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/turf/closed/wall/r_wall/blackmesa/try_decon(obj/item/W, mob/user, turf/T)
	return FALSE

/turf/closed/wall/r_wall/blackmesa/try_destroy(obj/item/I, mob/user, turf/T)
	return FALSE

/turf/closed/wall/r_wall/blackmesa/dismantle_wall(devastated = 0, explode = 0)
	return

/turf/closed/wall/r_wall/blackmesa/attack_animal(mob/living/simple_animal/M)
	return

/turf/closed/wall/r_wall/blackmesa/attack_hulk(mob/living/carbon/human/H)
	return FALSE
