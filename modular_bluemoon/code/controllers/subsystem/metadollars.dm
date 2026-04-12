/// Внутриигровая валюта «метадоллары»: начисление за время жизни на станции и бонусы в конце раунда.
SUBSYSTEM_DEF(metadollars)
	name = "Metadollars"
	flags = SS_NO_FIRE
	/// ckey -> assoc list ключей вида living/cc/goals/antag/total
	var/list/round_earnings = list()

/datum/controller/subsystem/metadollars/Initialize()
	. = ..()
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(round_begin_reset))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/metadollars/proc/round_begin_reset()
	SIGNAL_HANDLER
	round_earnings = list()

/// Антаг-роли без повышенного начисления за время жизни (ср. Hilbert / ghost spawns).
/proc/metadollar_living_excluded_antag(datum/antagonist/A)
	return istype(A, /datum/antagonist/ghost_role) || istype(A, /datum/antagonist/ashwalker)

/// Множитель «часовых» метадолларов: 1 для обычных ролей, 2 для командования, СБ и «полных» антагонистов.
/proc/metadollar_living_multiplier(mob/living/L)
	if(!L?.mind)
		return 1
	var/datum/mind/M = L.mind
	for(var/datum/antagonist/A in M.antag_datums)
		if(metadollar_living_excluded_antag(A))
			continue
		return 2
	if(M.assigned_role && (M.assigned_role in GLOB.command_positions))
		return 2
	if(M.assigned_role && (M.assigned_role in GLOB.security_positions))
		return 2
	return 1

/datum/controller/subsystem/metadollars/proc/on_living_tick(client/C, minutes)
	if(!C?.prefs || minutes <= 0)
		return
	if(!isliving(C.mob) || C.mob.stat == DEAD)
		return
	var/mult = metadollar_living_multiplier(C.mob)
	C.prefs.metadollar_minute_pool += minutes * mult
	var/granted = 0
	while(C.prefs.metadollar_minute_pool >= 60)
		C.prefs.metadollar_minute_pool -= 60
		granted++
	if(!granted)
		return
	add_amount(C, granted, "living")

/datum/controller/subsystem/metadollars/proc/add_amount(client/C, amount, category)
	if(!C?.prefs || amount <= 0)
		return
	C.prefs.metadollars += amount
	var/ck = C.ckey
	LAZYINITLIST(round_earnings[ck])
	if(!round_earnings[ck][category])
		round_earnings[ck][category] = 0
	round_earnings[ck][category] += amount
	round_earnings[ck]["total"] = (round_earnings[ck]["total"] || 0) + amount
	C.prefs.save_preferences()

/// Бонусы за эвак на ЦК / цели смены / выполненные цели антагониста (конец раунда).
/datum/controller/subsystem/metadollars/proc/apply_round_end_rewards()
	var/completed_station_goals = 0
	if(SSticker?.mode?.station_goals?.len)
		for(var/datum/station_goal/G in SSticker.mode.station_goals)
			if(G.check_completion())
				completed_station_goals++

	for(var/ckey in GLOB.joined_player_list)
		var/client/C = GLOB.directory[ckey]
		if(!C?.prefs)
			continue
		var/mob/M = C.mob
		if(!M?.mind)
			continue
		if(EMERGENCY_ESCAPED_OR_ENDGAMED && M.stat != DEAD && !isbrain(M) && M.onCentCom())
			var/cc_bonus = completed_station_goals > 0 ? (2 * completed_station_goals) : 1
			add_amount(C, cc_bonus, "cc")

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		var/client/C = GLOB.directory[ckey(A.owner.key)]
		if(!C?.prefs)
			continue
		if(!A.objectives.len)
			continue
		for(var/datum/objective/O in A.objectives)
			if(O.check_completion())
				add_amount(C, 2, "antag")

/// HTML-блок для персонального отчёта конца раунда.
/datum/controller/subsystem/metadollars/proc/personal_roundend_html(client/C)
	if(!C?.ckey)
		return ""
	var/list/E = round_earnings[C.ckey]
	if(!E || !E["total"])
		return ""
	var/total = E["total"]
	var/list/lines = list()
	if(E["living"])
		lines += "За время на станции: <b>[E["living"]]</b> М$"
	if(E["cc"])
		lines += "Эвакуация / цели смены: <b>[E["cc"]]</b> М$"
	if(E["antag"])
		lines += "Цели антагониста: <b>[E["antag"]]</b> М$"
	if(E["voucher"])
		lines += "Жетон обмена: <b>[E["voucher"]]</b> М$"
	return "<div class='panel stationborder'><span class='header'>Метадоллары за раунд</span><br>Всего начислено: <b>[total] М$</b>.<br><small>[lines.Join("<br>")]</small><br>Текущий баланс: <b>[C.prefs.metadollars] М$</b>.</div>"

/proc/bm_deliver_metadollar_purchases(mob/living/carbon/human/H, client/C)
	if(!H || !C?.prefs)
		return
	if(!LAZYLEN(C.prefs.metadollar_pending_items))
		return
	var/obj/item/storage/backpack = H.get_item_by_slot(ITEM_SLOT_BACK)
	var/did_any = FALSE
	for(var/path_text in C.prefs.metadollar_pending_items)
		var/path = text2path(path_text)
		if(!ispath(path, /obj/item))
			continue
		var/obj/item/I = new path(get_turf(H))
		did_any = TRUE
		if(istype(backpack))
			if(!SEND_SIGNAL(backpack, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, TRUE))
				if(!H.put_in_hands(I))
					I.forceMove(get_turf(H))
		else if(!H.put_in_hands(I))
			I.forceMove(get_turf(H))
	if(did_any)
		C.prefs.metadollar_pending_items.Cut()
		C.prefs.save_preferences()
		to_chat(H, span_notice("В рюкзаке оказались предметы, заказанные в метамаазине."))
