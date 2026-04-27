/**
 * Drives space drift with a smooth move loop (SSnewtonian_movement) instead of SSspacedrift step() ticks.
 * Loosely based on https://github.com/BlueMoon-Labs/WhiteMoon-Station
 */
/datum/drift_handler
	var/atom/movable/parent
	/// Facing to restore after a drift step (keeps you “sideways” while gliding)
	var/old_dir
	var/datum/move_loop/smooth_move/drifting_loop
	/// Skip one glide_size echo from the moveloop (postprocess ordering)
	var/ignore_next_glide = FALSE
	/// We deliberately paused; skip glide_to_halt
	var/delayed = FALSE
	var/force
	var/block_inputs_until

/datum/drift_handler/New(atom/movable/parent, inertia_angle, instant = FALSE, start_delay = 0, drift_force = 1)
	. = ..()
	src.parent = parent
	src.parent.drift_handler = src
	force = drift_force
	var/flags = MOVEMENT_LOOP_OUTSIDE_CONTROL
	if(instant)
		flags |= MOVEMENT_LOOP_START_FAST
	var/loop_delay = get_loop_delay(parent, drift_force)
	drifting_loop = SSmove_manager.smooth_move(
		moving = parent,
		angle = inertia_angle,
		delay = loop_delay,
		timeout = INFINITY,
		subsystem = SSnewtonian_movement,
		priority = MOVEMENT_SPACE_PRIORITY,
		flags = flags,
		extra_info = null,
	)
	if(!drifting_loop)
		qdel(src)
		return
	RegisterSignal(drifting_loop, COMSIG_MOVELOOP_START, PROC_REF(moveloop_began))
	RegisterSignal(drifting_loop, COMSIG_MOVELOOP_STOP, PROC_REF(moveloop_ended))
	RegisterSignal(drifting_loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(before_move))
	RegisterSignal(drifting_loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(after_move))
	RegisterSignal(drifting_loop, COMSIG_PARENT_QDELETING, PROC_REF(loop_death))
	// add_loop() may have already run start_loop and sent START before we registered; catch that.
	if(drifting_loop.running)
		moveloop_began()

	var/visual_delay = loop_delay
	if(!instant && start_delay)
		drifting_loop.pause_for(start_delay)
		visual_delay = start_delay

	apply_initial_visuals(visual_delay)
	var/next_allowed = parent.last_drift_time + get_loop_delay(parent, force)
	if(world.time < next_allowed)
		drifting_loop.pause_for(next_allowed - world.time)
	else if(drifting_loop.timer <= world.time)
		SSnewtonian_movement.fire_moveloop(drifting_loop)

/datum/drift_handler/Destroy()
	// Never qdel the move_loop synchronously: Destroy can run from the loop's COMSIG_MOVELOOP_POSTPROCESS.
	// Deletion mid-process() caused sequence-number / illegal op crashes in BYOND + atmos.
	if(drifting_loop)
		var/datum/move_loop/loop_ref = drifting_loop
		drifting_loop = null
		if(!QDELETED(loop_ref))
			QDEL_IN(loop_ref, 0)
	if(parent)
		if(parent.drift_handler == src)
			parent.drift_handler = null
		parent.inertia_moving = FALSE
	return ..()

/datum/drift_handler/proc/apply_initial_visuals(visual_delay)
	if(SEND_SIGNAL(parent, COMSIG_MOVABLE_DRIFT_VISUAL_ATTEMPT) & DRIFT_VISUAL_FAILED)
		return
	ignore_next_glide = TRUE
	parent.set_glide_size(MOVEMENT_ADJUSTED_GLIDE_SIZE(visual_delay, SSnewtonian_movement.visual_delay), FALSE)

/datum/drift_handler/proc/moveloop_began()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
	RegisterSignal(parent, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE, PROC_REF(handle_glidesize_update))

/datum/drift_handler/proc/moveloop_ended()
	if(parent)
		parent.inertia_moving = FALSE
	ignore_next_glide = FALSE
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOVABLE_UPDATE_GLIDE_SIZE,
	))

/datum/drift_handler/proc/before_move(datum/source)
	SIGNAL_HANDLER
	if(!parent)
		return
	parent.inertia_moving = TRUE
	old_dir = parent.dir
	delayed = FALSE

/datum/drift_handler/proc/after_move(datum/source, result, visual_delay)
	SIGNAL_HANDLER
	if(!parent)
		return
	if(result == MOVELOOP_FAILURE)
		QDEL_IN(src, 0)
		return
	parent.last_drift_time = world.time
	parent.setDir(old_dir)
	parent.inertia_moving = FALSE
	if(parent.Process_Spacemove(angle2dir(drifting_loop.angle), TRUE))
		glide_to_halt(visual_delay)
		return
	ignore_next_glide = TRUE

/datum/drift_handler/proc/loop_death()
	SIGNAL_HANDLER
	drifting_loop = null

/datum/drift_handler/proc/handle_move(datum/source, atom/OldLoc, Dir, Forced = FALSE)
	SIGNAL_HANDLER
	if(QDELETED(src) || !parent)
		return
	if(!isturf(parent.loc))
		QDEL_IN(src, 0)
		return
	if(parent.inertia_moving)
		return
	if(!drifting_loop)
		return
	if(!parent.Process_Spacemove(angle2dir(drifting_loop.angle), TRUE))
		return
	QDEL_IN(src, 0)

/datum/drift_handler/proc/handle_glidesize_update(datum/source, glide_size)
	SIGNAL_HANDLER
	if(!drifting_loop || !parent)
		return
	if(parent.inertia_moving)
		return
	if(ignore_next_glide)
		ignore_next_glide = FALSE
		return
	var/glide_delay = round(world.icon_size / max(glide_size, 1), 1) * world.tick_lag
	drifting_loop.pause_for(glide_delay)
	delayed = TRUE

/datum/drift_handler/proc/glide_to_halt(glide_for)
	if(!ismob(parent) || !parent?.client)
		QDEL_IN(src, 0)
		return
	if(delayed)
		QDEL_IN(src, 0)
		return
	// no COMSIG_MOB_CLIENT_PRE_MOVE on this codebase — end drift without extra keybuffer hacks
	QDEL_IN(src, 0)

/datum/drift_handler/proc/get_loop_delay(atom/movable/movable, f)
	if(isnull(f))
		f = force
	if(!f)
		f = 1
	return (DEFAULT_INERTIA_SPEED / ((1 - INERTIA_SPEED_COEF) + f * INERTIA_SPEED_COEF)) * movable.inertia_move_multiplier
