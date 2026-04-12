/obj/item/coin/antagtoken/metashop
	name = "метамагазинный жетон"
	desc = "Пластиковая безделушка.."
	icon_state = "coin_valid"
	var/antag_type = null

/obj/item/coin/antagtoken/metashop/examine(mob/user)
	. = ..()

/obj/item/coin/antagtoken/metashop/AltClick(mob/user)
	try_activate(user)

/obj/item/coin/antagtoken/metashop/attack_self(mob/user)
	if(try_activate(user))
		return TRUE
	return FALSE

/obj/item/coin/antagtoken/metashop/proc/try_activate(mob/user)
	if(!isliving(user))
		return FALSE
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return FALSE
	if(!ishuman(user))
		to_chat(user, span_warning("Жетон не реагирует на вас."))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		to_chat(H, span_warning("У вас нет разума — странно."))
		return FALSE
	if(H.stat != CONSCIOUS)
		to_chat(H, span_warning("Сейчас вы не в состоянии сосредоточиться на жетоне."))
		return FALSE
	if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(H, span_warning("Сейчас нельзя активировать жетон."))
		return FALSE
	if(!ispath(antag_type, /datum/antagonist))
		to_chat(H, span_warning("Жетон мёртвый — тип роли не задан."))
		return FALSE
	if(H.mind.has_antag_datum(antag_type))
		to_chat(H, span_warning(already_has_antag_message()))
		return FALSE
	var/datum/antagonist/T = H.mind.add_antag_datum(antag_type)
	if(!T)
		to_chat(H, span_warning(role_unavailable_message()))
		return FALSE
	playsound(H, 'sound/items/coinflip.ogg', 50, TRUE)
	on_activation_success(H, T)
	qdel(src)
	return TRUE

/obj/item/coin/antagtoken/metashop/proc/already_has_antag_message()
	return "Вы уже связаны с силами, с которыми хотел бы связаться жетон."

/obj/item/coin/antagtoken/metashop/proc/role_unavailable_message()
	return "Жетон нагревается и остывает — роль недоступна."

/obj/item/coin/antagtoken/metashop/proc/on_activation_success(mob/living/carbon/human/H, datum/antagonist/T)

/obj/item/coin/antagtoken/metashop/traitor
	name = "Жетон Предателя"
	desc = "Пластиковая безделушка с отметиной InteQ. Одноразовая."
	antag_type = /datum/antagonist/traitor

/obj/item/coin/antagtoken/metashop/traitor/examine(mob/user)
	. = ..()
	. += span_notice("Активация: <b>Z</b> в руке или <b>Alt+ЛКМ</b> по жетону (в руке или рядом на полу), чтобы попытаться получить роль предателя.")

/obj/item/coin/antagtoken/metashop/traitor/on_activation_success(mob/living/carbon/human/H, datum/antagonist/T)
	to_chat(H, span_bolddanger("Вы чувствуете холодок по спине. Система отмечает вас как угрозу экипажу."))
	message_admins("[key_name_admin(H)] активировал метамагазинный жетон предателя.")
	log_game("Metashop antag token: [key_name(H)] became traitor via coin.")
