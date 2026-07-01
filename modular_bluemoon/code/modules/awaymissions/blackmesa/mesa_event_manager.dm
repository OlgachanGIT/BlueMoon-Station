GLOBAL_VAR_INIT(zombie_director, null)

// =============================================================================
// FORWARD DECLARATIONS (ПРОТОТИПЫ)
// =============================================================================
/datum/ai_director/zombie_mission

// =============================================================================
// MAIN SUBSYSTEM
// =============================================================================
SUBSYSTEM_DEF(blackmesa_events)
	name = "Black Mesa Events"
	runlevels = RUNLEVEL_GAME
	wait = 3000
	var/list/event_controls = list()
	var/day_phase = 0 // 0=Evening, 1=Night, 2=Morning, 3=Day
	var/phase_timer = 2 // Change every 2 fires (10 minutes)
	var/zombie_director_ref

/datum/controller/subsystem/blackmesa_events/Initialize(time, zlevel)
	for(var/type in typesof(/datum/round_event_control/blackmesa))
		if(type == /datum/round_event_control/blackmesa)
			continue
		var/datum/round_event_control/E = new type()
		if(!E.typepath)
			continue
		event_controls += E


	initialize_zombie_director()
	zombie_director_ref = GLOB.zombie_director
	return ..()

/datum/controller/subsystem/blackmesa_events/fire(resumed = FALSE)
	// Mission load check
	var/list/mission_areas = get_areas(/area/awaymission/ihategordon, TRUE)
	if(!mission_areas.len)
		return

	// Day/Night Cycle
	phase_timer--
	if(phase_timer <= 0)
		phase_timer = 2
		cycle_day_night()

	if(!length(event_controls))
		return

	// Get current difficulty level from zombie director
	var/current_difficulty = 0
	if(GLOB.zombie_director)
		var/datum/ai_director/zombie_mission/D = GLOB.zombie_director
		if(D)
			current_difficulty = D.difficulty_level

	var/list/possible_events = list()
	for(var/datum/round_event_control/E in event_controls)
		if(E.max_occurrences > 0 && E.occurrences >= E.max_occurrences)
			continue
		// Check if event meets difficulty requirement
		if(istype(E, /datum/round_event_control/blackmesa))
			var/datum/round_event_control/blackmesa/BE = E
			if(BE.min_difficulty_level > current_difficulty)
				continue
		possible_events += E

	if(!length(possible_events))
		return

	var/list/event_weights = list()
	for(var/datum/round_event_control/E in possible_events)
		event_weights[E] = E.weight

	var/datum/round_event_control/selected = pickweight(event_weights)
	if(selected)
		selected.runEvent(random = TRUE)

/datum/controller/subsystem/blackmesa_events/proc/cycle_day_night()
	day_phase = (day_phase + 1) % 4
	var/new_color = "#f88d66"
	var/announce_text = ""
	var/announce_title = ""

	switch(day_phase)
		if(0) // Evening
			new_color = "#f88d66"
			announce_text = "Внимание! Наступает вечер. Рекомендуется включить дополнительное освещение. ВНИМАНИЕ! состояние сектора ухудшается. Всем немедленно проследовать к ближайшим выходам из сектора."
			announce_title = "Evening Approach"
		if(1) // Night
			new_color = "#071130"
			announce_text = "Внимание! Наступает ночь. Всем сотрудникам заступивших на ночную смену приступить к работе. ВНИМАНИЕ! Состояние сектора всё ещё критично. Требуется немедленная эвакуация"
			announce_title = "Nightfall"
		if(2) // Morning
			new_color = "#1c1c30"
			announce_text = "Внимание! Наступает утро. Начало дневной смены через 30 минут. ВНИМАНИЕ! Состояние сектора остаётся критичным. Всем сотрудникам рекомендуется следовать указаниям военных подразделений HECU"
			announce_title = "Morning"
		if(3) // Day
			new_color = "#fff8b8"
			announce_text = "Внимание! Наступил день. Большая часть систем выведена из строя. Рекомендуется проведение немедленной эвакуации с сектора "
			announce_title = "Daytime"

	update_mesa_lights(new_color)
	mesa_announce(announce_text, announce_title, 'modular_bluemoon/sound/ambience/mesa/timeevent.ogg')

/datum/controller/subsystem/blackmesa_events/proc/update_mesa_lights(color)
	for(var/obj/machinery/power/floodlight/urbanismlight/mesaoutside/L in GLOB.machines)
		L.light_color = color
		L.set_light(L.light_range, L.light_power, color)

/datum/controller/subsystem/blackmesa_events/proc/mesa_announce(text, title = "", sound = null)
	if(!text)
		return
	var/announcement = "<h1 class='alert'>Black Mesa Announcement System</h1>"
	if(title)
		announcement += "<br><h2 class='alert'>[html_encode(title)]</h2>"
	announcement += "<br>[span_alert("[html_encode(text)]")]<br>"

	var/s = sound ? sound(sound) : null
	for(var/mob/M in GLOB.player_list)
		if(isnewplayer(M))
			continue
		var/area/A = get_area(M)
		if(istype(A, /area/awaymission/ihategordon) || istype(A, /area/command/gateway))
			to_chat(M, announcement)
			if(s && M.client && (M.client.prefs.toggles & SOUND_ANNOUNCEMENTS))
				SEND_SOUND(M, s)

/datum/controller/subsystem/blackmesa_events/proc/initialize_zombie_director()
	if(!GLOB.zombie_director)
		GLOB.zombie_director = new /datum/ai_director/zombie_mission()

