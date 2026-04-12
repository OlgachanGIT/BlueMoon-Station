/// Жетон из метамаазина: Alt+ЛКМ — попытка выдать роль (подтипы задают antag_type).
/obj/item/coin/antagtoken/metashop
	name = "метамаазинный жетон"
	desc = "Пластиковая безделушка.."
	icon_state = "coin_valid"
	/// Подтип /datum/antagonist; подклассы обязаны задать.
	var/antag_type = null
	/// Минимум игроков на сервере для активации (как идея «станция готова»).
	var/minimum_players = 20

/obj/item/coin/antagtoken/metashop/examine(mob/user)
	. = ..()

/obj/item/coin/antagtoken/metashop/AltClick(mob/user)
	if(!isliving(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(!ishuman(user))
		to_chat(user, span_warning("Жетон не реагирует на вас."))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		to_chat(H, span_warning("У вас нет разума — странно."))
		return
	if(H.stat != CONSCIOUS)
		to_chat(H, span_warning("Сейчас вы не в состоянии сосредоточиться на жетоне."))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(H, span_warning("Сейчас нельзя активировать жетон."))
		return
	if(GLOB.player_list.len < minimum_players)
		to_chat(H, span_warning("На станции слишком мало экипажа для такого риска... (нужно минимум [minimum_players] игроков.)"))
		return
	if(!ispath(antag_type, /datum/antagonist))
		to_chat(H, span_warning("Жетон мёртвый — тип роли не задан."))
		return
	if(H.mind.has_antag_datum(antag_type))
		to_chat(H, span_warning(already_has_antag_message()))
		return
	var/datum/antagonist/T = H.mind.add_antag_datum(antag_type)
	if(!T)
		to_chat(H, span_warning(role_unavailable_message()))
		return
	playsound(H, 'sound/items/coinflip.ogg', 50, TRUE)
	on_activation_success(H, T)
	qdel(src)

/// Сообщение, если этот тип антага уже есть у носителя.
/obj/item/coin/antagtoken/metashop/proc/already_has_antag_message()
	return "Вы уже связаны с силами, с которыми хотел бы связаться жетон."

/// Сообщение при отказе add_antag_datum (роль недоступна).
/obj/item/coin/antagtoken/metashop/proc/role_unavailable_message()
	return "Жетон нагревается и остывает — роль недоступна."

/// Успешная выдача: чат игроку, логи.
/obj/item/coin/antagtoken/metashop/proc/on_activation_success(mob/living/carbon/human/H, datum/antagonist/T)

/// Жетон предателя (метамаазин).
/obj/item/coin/antagtoken/metashop/traitor
	name = "жетон сомнительной валидности"
	desc = "Пластиковая безделушка с отметиной SyndiCartel. Подсказка: Alt+ЛКМ, находясь рядом с жетоном, чтобы связаться с... интересными людьми. Одноразовая."
	antag_type = /datum/antagonist/traitor

/obj/item/coin/antagtoken/metashop/traitor/examine(mob/user)
	. = ..()
	. += span_notice("Используйте <b>Alt+ЛКМ</b> по жетону в руках или рядом с ним на земле, чтобы попытаться получить роль предателя.")

/obj/item/coin/antagtoken/metashop/traitor/on_activation_success(mob/living/carbon/human/H, datum/antagonist/T)
	to_chat(H, span_bolddanger("Вы чувствуете холодок по спине. Система отмечает вас как угрозу экипажу."))
	message_admins("[key_name_admin(H)] активировал метамаазинный жетон предателя.")
	log_game("Metashop antag token: [key_name(H)] became traitor via coin.")
