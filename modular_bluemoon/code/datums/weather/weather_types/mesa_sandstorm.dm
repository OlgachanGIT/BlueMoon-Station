/datum/weather/ash_storm/mesa_sandstorm
	name = "sandstorm"
	desc = "A localized sandstorm is kicking up dust across the surface."

	telegraph_message = "<span class='boldwarning'>Ветер усиливается, поднимая тучи песка с поверхности.</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_ash"

	weather_message = "<span class='userdanger'><i>Вас окутывает плотная песчаная буря!</i></span>"
	weather_overlay = "ash_storm"
	weather_color = "#d2b48c"

	end_message = "<span class='boldannounce'>Ветер стихает, и песок оседает на землю.</span>"
	end_duration = 300
	end_overlay = "light_ash"

	aesthetic = FALSE
	probability = 0

	weather_duration_lower = 1800
	weather_duration_upper = 3600

	area_type = /area/awaymission/ihategordon/outsideofmesa
	protect_indoors = TRUE
	protected_areas = list(/area/awaymission/ihategordon/rocks)

/datum/weather/ash_storm/mesa_sandstorm/start()
	. = ..()
	SSblackmesa_events.mesa_announce("Внимание! Зафиксирована интенсивная песчаная буря в Секторе H. Видимость критически низкая. Всем находиться в помещениях!", "Sandstorm Warning", 'modular_bluemoon/sound/ambience/mesa/BMAS2.ogg')

/datum/weather/ash_storm/mesa_sandstorm/wind_down()
	for(var/mob/living/L in GLOB.mob_living_list)
		L.remove_movespeed_modifier(/datum/movespeed_modifier/mesa_storm)
		L.clear_fullscreen("mesa_storm")
	return ..()

/datum/weather/ash_storm/mesa_sandstorm/weather_act(mob/living/L)
	if(is_ash_immune(L))
		L.remove_movespeed_modifier(/datum/movespeed_modifier/mesa_storm)
		L.clear_fullscreen("mesa_storm")
		return

	L.add_movespeed_modifier(/datum/movespeed_modifier/mesa_storm)
	L.overlay_fullscreen("mesa_storm", /atom/movable/screen/fullscreen/tiled/mesa_sandstorm)

/datum/weather/ash_storm/mesa_sandstorm/process()
	if(aesthetic || (stage != MAIN_STAGE))
		return
	for(var/mob/living/L in GLOB.mob_living_list)
		var/turf/mob_turf = get_turf(L)
		var/area/mob_area = get_area(L)
		if(!mob_turf || !(mob_turf.z in impacted_z_levels) || !mob_area || !(mob_area in impacted_areas))
			L.remove_movespeed_modifier(/datum/movespeed_modifier/mesa_storm)
			L.clear_fullscreen("mesa_storm")
		else if(can_weather_act(L))
			weather_act(L)

/datum/weather/ash_storm/mesa_sandstorm/end()
	for(var/mob/living/L in GLOB.mob_living_list)
		L.remove_movespeed_modifier(/datum/movespeed_modifier/mesa_storm)
		L.clear_fullscreen("mesa_storm")
	return ..()

/datum/weather/ash_storm/mesa_rain
	name = "rain"
	desc = "A rare rain shower in the sector."

	telegraph_message = "<span class='notice'>Небо затягивают тучи, в воздухе пахнет озоном.</span>"
	weather_message = "<span class='notice'>Начинается дождь, омывая пустынную землю.</span>"
	end_message = "<span class='notice'>Дождь прекращается, оставляя за собой лишь лужи и туман.</span>"

	weather_overlay = "rain_high"
	telegraph_overlay = "rain_high"
	end_overlay = "rain_high"

	overlay_plane = -5

	aesthetic = TRUE
	probability = 0

	area_type = /area/awaymission/ihategordon/outsideofmesa
	protect_indoors = TRUE
	protected_areas = list(/area/awaymission/ihategordon/rocks)

/datum/weather/ash_storm/mesa_rain/start()
	. = ..()
	for(var/z_level in impacted_z_levels)
		for(var/mob/player as anything in SSmobs.clients_by_zlevel[z_level])
			player.overlay_fullscreen("rain_mist", /atom/movable/screen/fullscreen/tiled/rain_mist)

/datum/weather/ash_storm/mesa_rain/process()
	if(stage != MAIN_STAGE)
		return
	for(var/mob/living/L in GLOB.mob_living_list)
		var/turf/mob_turf = get_turf(L)
		var/area/mob_area = get_area(L)
		if(!mob_turf || !(mob_turf.z in impacted_z_levels) || !mob_area || !(mob_area in impacted_areas))
			L.clear_fullscreen("rain_mist")
		else
			L.overlay_fullscreen("rain_mist", /atom/movable/screen/fullscreen/tiled/rain_mist)

/datum/weather/ash_storm/mesa_rain/wind_down()
	for(var/mob/living/L in GLOB.mob_living_list)
		L.clear_fullscreen("rain_mist")
	return ..()

/datum/weather/ash_storm/mesa_rain/end()
	for(var/mob/player in GLOB.player_list)
		player.clear_fullscreen("rain_mist")
	return ..()


/atom/movable/screen/fullscreen/tiled/mesa_sandstorm
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "cloudy"
	color = "#d2b48c"
	alpha = 150

/atom/movable/screen/fullscreen/tiled/rain_mist
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "cloudy"
	color = "#87ceeb"
	alpha = 120
