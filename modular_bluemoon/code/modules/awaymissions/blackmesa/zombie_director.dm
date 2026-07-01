// =============================================================================
// BLACK MESA ZOMBIE AI DIRECTOR (FIXED & OPTIMIZED)
// Controls zombie wave spawning for ihategordon mission
// =============================================================================

/datum/ai_director/zombie_mission
	var/wave_timer = 1200
	var/max_wave_interval = 6000
	var/last_wave_time = 0
	var/current_wave_number = 0
	var/list/active_zombies = list()
	var/horde_music_playing = FALSE
	var/horde_music_start_time = 0
	var/horde_music_duration = 12000 // 2 minutes in deciseconds
	var/horde_music_cutoff_threshold = 5 // Stop music if fewer than this many zombies remain
	var/difficulty_level = 0 // 0-8, increases when players cross trigger zones

	// Whitelist and blacklist areas
	var/list/excluded_areas = list(
		/area/awaymission/ihategordon/hecu_abandoned_camp,
		/area/awaymission/ihategordon/rocks,
		/area/awaymission/ihategordon/outsideofmesa,
		/area/awaymission/ihategordon/secret_rooms,
		/area/awaymission/ihategordon/underground_tunnels,
		/area/awaymission/ihategordon/sectorhnorthoffices,
		/area/awaymission/ihategordon/opposing/end,
		/area/awaymission/ihategordon/opposing/comlpex,
		/area/awaymission/ihategordon/opposing,
		/area/awaymission/ihategordon/outsideofmesa/restricted_zone,
		/area/awaymission/ihategordon/science_tunnel,
		/area/awaymission/ihategordon/gonome,
		/area/awaymission/ihategordon/sec_armory,
		/area/awaymission/ihategordon/tram_tunnel,
		/area/awaymission/ihategordon/entrance,
		/area/awaymission/ihategordon/dorm_rooms,
		/area/awaymission/ihategordon/hecu_camp_hall,
		/area/awaymission/ihategordon/hecu_camp_medbay,
		/area/awaymission/ihategordon/sci_medbay
	)

/datum/ai_director/zombie_mission/New()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/datum/ai_director/zombie_mission/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	active_zombies.Cut()
	. = ..()

/datum/ai_director/zombie_mission/process()
	if(!src)
		return
	if(!SSblackmesa_events)
		return

	var/list/mission_areas = get_areas(/area/awaymission/ihategordon, TRUE)
	if(!mission_areas || !mission_areas.len)
		return

	if(world.time - last_wave_time >= wave_timer)
		attempt_spawn_wave()

	if(horde_music_playing)
		manage_horde_music()

/datum/ai_director/zombie_mission/proc/attempt_spawn_wave()
	if(!src)
		return
	var/time_since_last = world.time - last_wave_time
	if(time_since_last < wave_timer)
		return

	wave_timer = rand(600, max_wave_interval)

	var/list/alive_players = get_alive_players_in_mission()
	if(!alive_players || !alive_players.len)
		log_world("[src] No alive players in mission, skipping wave")
		return

	var/threat_level = calculate_threat_level(alive_players.len)
	if(!threat_level || threat_level <= 0)
		log_world("[src] Invalid threat level: [threat_level]")
		return

	log_world("[src] Attempting to spawn wave with threat=[threat_level]")
	spawn_zombie_wave(threat_level, alive_players)

	last_wave_time = world.time
	current_wave_number++

/datum/ai_director/zombie_mission/proc/get_alive_players_in_mission()
	if(!src)
		return list()
	var/list/players = list()
	var/list/valid_areas = get_mesa_areas()
	if(!valid_areas || !valid_areas.len)
		log_world("[src] No valid mesa areas found")
		return players

	for(var/mob/living/L in GLOB.player_list)
		if(!L || !L.client || L.stat == DEAD)
			continue
		var/area/A = get_area(L)
		if(!A)
			continue
		if(A in valid_areas)
			players += L
			log_world("[src] Found player [L] in area [A]")

	log_world("[src] Total alive players in mission: [players.len]")
	return players

/datum/ai_director/zombie_mission/proc/get_mesa_areas()
	if(!src)
		return list()
	var/list/source_areas = get_areas(/area/awaymission/ihategordon, TRUE)
	if(!source_areas || !source_areas.len)
		return list()

	var/list/areas = list()

	for(var/area/A in source_areas)
		if(!A || !A.contents || !A.contents.len)
			continue
		var/valid = TRUE
		for(var/EA in excluded_areas)
			if(ispath(A.type, EA))
				valid = FALSE
				break
		if(valid)
			areas += A
	return areas

/datum/ai_director/zombie_mission/proc/calculate_threat_level(player_count)
	if(!player_count)
		player_count = 1
	// Progressive threat based on difficulty level
	// Level 0: 3-4 zombies (no horde music)
	// Level 1-2: 5-8 zombies
	// Level 3-4: 10-15 zombies
	// Level 5-6: 15-22 zombies
	// Level 7-8: 20-30 zombies (max)
	var/threat
	switch(difficulty_level)
		if(0)
			threat = rand(3, 4)
		if(1)
			threat = rand(5, 8)
		if(2)
			threat = rand(7, 10)
		if(3)
			threat = rand(10, 15)
		if(4)
			threat = rand(12, 18)
		if(5)
			threat = rand(15, 22)
		if(6)
			threat = rand(18, 25)
		if(7)
			threat = rand(20, 28)
		if(8)
			threat = rand(25, 30)
		else
			threat = rand(3, 4)
	return threat

/datum/ai_director/zombie_mission/proc/spawn_zombie_wave(threat_level, list/players)
	if(!threat_level || threat_level <= 0)
		return
	if(!players || !players.len)
		return
	if(!src)
		return

	var/zombies_to_spawn = threat_level
	var/list/spawned_zombies = list()

	log_world("[src] Starting zombie wave: threat=[threat_level], players=[players.len]")

	// Gradual spawning: spawn in batches of 3-5 zombies
	var/batch_size = rand(3, 5)
	var/zombies_spawned = 0

	while(zombies_spawned < zombies_to_spawn)
		var/remaining = zombies_to_spawn - zombies_spawned
		var/current_batch = min(batch_size, remaining)

		for(var/i = 1 to current_batch)
			var/turf/spawn_turf = find_valid_spawn_turf(players)
			if(!spawn_turf)
				log_world("[src] Failed to find spawn turf for zombie #[zombies_spawned + i]")
				continue

			var/mob_type
			if(prob(70))
				mob_type = /mob/living/simple_animal/hostile/infected
			else
				mob_type = prob(50) ? /mob/living/simple_animal/hostile/infected/bruiser : /mob/living/simple_animal/hostile/infected/bruiser/alt

			if(!mob_type)
				continue

			var/mob/living/simple_animal/hostile/infected/Z = new mob_type(spawn_turf)
			if(Z)
				spawned_zombies += Z
				active_zombies += Z
				new /obj/effect/temp_visual/dir_setting/ninja/phase(spawn_turf)
				playsound(spawn_turf, 'sound/magic/Teleport_app.ogg', 50, TRUE)
				log_world("[src] Spawned zombie #[zombies_spawned + i] at [spawn_turf]")

		zombies_spawned += current_batch

		// If more zombies to spawn, wait before next batch
		if(zombies_spawned < zombies_to_spawn)
			sleep(20) // Wait 2 seconds between batches

	if(spawned_zombies.len > 0)
		// Only play horde music if difficulty level > 0
		if(difficulty_level > 0)
			start_horde_music()

	log_world("[src] Wave complete: spawned=[spawned_zombies.len]")
	announce_wave(spawned_zombies.len)

/datum/ai_director/zombie_mission/proc/find_valid_spawn_turf(list/players)
	if(!src)
		return null
	if(!players || !players.len)
		return null

	var/list/valid_areas = get_mesa_areas()
	if(!valid_areas || !valid_areas.len)
		return null

	for(var/i = 1 to 100)
		var/mob/living/target = pick(players)
		if(!target)
			continue
		var/turf/center = get_turf(target)
		if(!center)
			continue

		var/list/nearby_turfs = list()
		for(var/turf/T in range(20, center))
			if(!T)
				continue
			var/dist = get_dist(T, center)
			if(dist >= 6 && dist <= 20)
				nearby_turfs += T

		if(!nearby_turfs || !nearby_turfs.len)
			continue

		var/turf/T = pick(nearby_turfs)
		if(!T)
			continue

		var/area/A = get_area(T)
		if(!A || !(A in valid_areas))
			continue

		if(T.density)
			continue

		if(T.is_blocked_turf())
			continue

		if(!can_reach_player(T, center))
			continue

		return T

	return null

/datum/ai_director/zombie_mission/proc/can_reach_player(turf/start_turf, turf/target_turf)
	if(!src)
		return FALSE
	if(!start_turf || !target_turf)
		return FALSE

	// Simple BFS to check if there's a path (max 100 steps)
	var/list/visited = list()
	var/list/queue = list(start_turf)
	visited[start_turf] = TRUE
	var/steps = 0
	var/max_steps = 100

	while(queue.len && steps < max_steps)
		var/turf/current = queue[1]
		queue.Cut(1, 2)
		steps++

		if(current == target_turf)
			return TRUE

		for(var/dir in GLOB.cardinals)
			var/turf/next_turf = get_step(current, dir)
			if(!next_turf || visited[next_turf])
				continue
			if(next_turf.density)
				continue
			// Allow passing through zombies but not walls
			var/blocked = FALSE
			for(var/atom/movable/AM in next_turf)
				if(AM.density && !istype(AM, /mob/living))
					blocked = TRUE
					break
			if(blocked)
				continue
			visited[next_turf] = TRUE
			queue += next_turf

	return FALSE

/datum/ai_director/zombie_mission/proc/announce_wave(zombie_count)
	if(!src)
		return
	if(!SSblackmesa_events)
		log_world("[src] SSblackmesa_events is null, cannot announce")
		return
	if(!zombie_count)
		log_world("[src] zombie_count is 0, skipping announce")
		return

	log_world("[src] Announcing wave with [zombie_count] zombies")
	var/message = "ВНИМАНИЕ! Зафиксирована активность заражённых в Секторе H. Количество целей: [zombie_count]. Рекомендуется подготовиться к обороне."
	SSblackmesa_events.mesa_announce(message, "Zombie Horde Detected")

/datum/ai_director/zombie_mission/proc/trigger_horde()
	if(!src)
		return
	var/list/alive_players = get_alive_players_in_mission()
	if(!alive_players || !alive_players.len)
		return

	var/threat_level = calculate_threat_level(alive_players.len)
	if(!threat_level || threat_level <= 0)
		return

	spawn_zombie_wave(threat_level, alive_players)
	last_wave_time = world.time
	current_wave_number++

/datum/ai_director/zombie_mission/proc/start_horde_music()
	if(!src)
		return
	if(horde_music_playing)
		return

	var/zombie_count = count_visible_zombies()
	if(zombie_count <= 0)
		return

	horde_music_playing = TRUE
	horde_music_start_time = world.time

	var/list/valid_areas = get_mesa_areas()
	if(!valid_areas || !valid_areas.len)
		return

	for(var/mob/M in GLOB.player_list)
		if(!M || isnewplayer(M))
			continue
		var/area/A = get_area(M)
		if(!A)
			continue
		if(A in valid_areas)
			if(M.client && M.client.prefs && (M.client.prefs.toggles & SOUND_AMBIENCE))
				SEND_SOUND(M, sound('modular_bluemoon/sound/ambience/mesa/horde_music.ogg', repeat = TRUE, volume = 50))

/datum/ai_director/zombie_mission/proc/stop_horde_music()
	if(!src)
		return
	if(!horde_music_playing)
		return

	horde_music_playing = FALSE

	for(var/mob/M in GLOB.player_list)
		if(!M || isnewplayer(M))
			continue
		if(M.client)
			SEND_SOUND(M, sound(null, volume = 0))

/datum/ai_director/zombie_mission/proc/manage_horde_music()
	if(!src)
		return
	if(!horde_music_playing)
		return

	var/time_elapsed = world.time - horde_music_start_time

	if(time_elapsed >= horde_music_duration)
		stop_horde_music()
		return

	var/visible_zombie_count = count_visible_zombies()
	if(visible_zombie_count <= horde_music_cutoff_threshold)
		stop_horde_music()
		return

/datum/ai_director/zombie_mission/proc/count_visible_zombies()
	if(!src)
		return 0
	var/count = 0
	var/list/valid_areas = get_mesa_areas()
	if(!valid_areas || !valid_areas.len)
		return count

	for(var/mob/living/simple_animal/hostile/infected/Z in active_zombies)
		if(!Z || QDELETED(Z) || Z.stat == DEAD)
			active_zombies -= Z
			continue
		var/area/A = get_area(Z)
		if(!A)
			continue
		if(A in valid_areas)
			count++

	return count
