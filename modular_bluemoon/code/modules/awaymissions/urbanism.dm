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
