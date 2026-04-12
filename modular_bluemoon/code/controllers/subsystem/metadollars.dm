SUBSYSTEM_DEF(metadollars)
	name = "Metadollars"
	flags = SS_NO_FIRE
	var/list/round_earnings = list()
	var/metadollar_burn_round_notice = null

/datum/controller/subsystem/metadollars/Initialize()
	. = ..()
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(round_begin_reset))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/metadollars/proc/round_begin_reset()
	SIGNAL_HANDLER
	round_earnings = list()
	metadollar_burn_round_notice = null

/proc/metadollar_living_excluded_antag(datum/antagonist/A)
	return istype(A, /datum/antagonist/ghost_role) || istype(A, /datum/antagonist/ashwalker)

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
	var/old_living = 0
	if(C.prefs.exp)
		old_living = text2num(C.prefs.exp[EXP_TYPE_LIVING])
	var/newbie_mult = (old_living < 6000) ? 2 : 1
	C.prefs.metadollar_minute_pool += minutes * mult * newbie_mult
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
	if(category == "living" && isliving(C.mob))
		to_chat(C.mob, span_purple("Вы получили [amount] М$ за работу на ПАКТ."))
		SEND_SOUND(C.mob, sound('sound/machines/terminal_success.ogg', 35))

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

/datum/controller/subsystem/metadollars/proc/personal_roundend_html(client/C)
	if(!C?.ckey)
		return ""
	var/list/chunks = list()
	if(metadollar_burn_round_notice)
		chunks += "<div class='panel redborder'><span class='header'>Сжигание метадолларов</span><br>[html_encode(metadollar_burn_round_notice)]</div>"
	var/list/E = round_earnings[C.ckey]
	if(E && E["total"])
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
		chunks += "<div class='panel stationborder'><span class='header'>Метадоллары за раунд</span><br>Всего начислено: <b>[total] М$</b>.<br><small>[lines.Join("<br>")]</small><br>Текущий баланс: <b>[C.prefs.metadollars] М$</b>.</div>"
	if(!length(chunks))
		return ""
	return chunks.Join("")

/proc/bm_metadollar_global_burn(mob/initiator)
	if(SSmetadollars)
		SSmetadollars.round_earnings = list()
	if(!fexists("data/player_saves"))
		return
	var/notice = "В этом раунде активирован протокол «Пепелище»: обнулены все метадолларовые балансы."
	if(initiator)
		notice += " Инициатор: [initiator.real_name] ([initiator.ckey])."
	if(SSmetadollars)
		SSmetadollars.metadollar_burn_round_notice = notice
	var/list/done = list()
	for(var/letterdir in flist("data/player_saves/"))
		var/prefix = "data/player_saves/[letterdir]"
		if(!fexists(prefix))
			continue
		for(var/sub in flist(prefix))
			var/sav = "[prefix]/[sub]/preferences.sav"
			if(!fexists(sav))
				continue
			var/ck = ckey(sub)
			if(!ck || done[ck])
				continue
			done[ck] = TRUE
			var/client/online = GLOB.directory[ck]
			if(online?.prefs)
				online.prefs.metadollars = 0
				online.prefs.save_preferences(TRUE, TRUE)
				continue
			var/datum/preferences/P = new
			P.load_path(ck)
			if(!P.load_preferences(TRUE))
				qdel(P)
				continue
			P.metadollars = 0
			P.save_preferences(TRUE, TRUE)
			qdel(P)

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
		to_chat(H, span_notice("В рюкзаке оказались предметы, заказанные в метамагазине."))
