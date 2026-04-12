/obj/item/stack/metadollar
	name = "метадолларовые купюры"
	singular_name = "метадоллар"
	desc = "Межгалактические казначейские купюры. Зачисление на постоянный счёт: проведите стопкой по КПК или по ID-карте."
	icon = 'icons/obj/economy.dmi'
	icon_state = "metadollar"
	novariants = TRUE
	merge_type = /obj/item/stack/metadollar
	max_amount = INFINITY
	full_w_class = WEIGHT_CLASS_TINY
	amount = 1
	resistance_flags = FLAMMABLE

/obj/item/stack/metadollar/Initialize(mapload, new_amount, merge = TRUE)
	. = ..()
	update_metadollar_icon()

/obj/item/stack/metadollar/get_item_credit_value()
	return 0

/obj/item/stack/metadollar/get_main_recipes()
	return list()

/obj/item/stack/metadollar/update_icon_state()
	update_metadollar_icon()

/// Спрайт по сумме в стопке (economy.dmi: metadollar*).
/obj/item/stack/metadollar/proc/update_metadollar_icon()
	var/n = amount
	if(n <= 0)
		icon_state = "metadollar"
		return
	if(n < 10)
		icon_state = "metadollar"
	else if(n < 20)
		icon_state = "metadollar10"
	else if(n < 50)
		icon_state = "metadollar20"
	else if(n < 100)
		icon_state = "metadollar50"
	else if(n < 200)
		icon_state = "metadollar100"
	else if(n < 500)
		icon_state = "metadollar200"
	else if(n < 1000)
		icon_state = "metadollar500"
	else
		icon_state = "metadollar1000"

/// Зачислить стопку на лобби-счёт игрока и удалить её. [source] — КПК или ID для текста.
/obj/item/stack/metadollar/proc/deposit_to_lobby_prefs(mob/user, atom/source)
	var/client/C = user?.client
	if(!C?.prefs)
		to_chat(user, span_warning("Не удалось связаться с лобби-счётом."))
		return FALSE
	if(amount <= 0)
		return FALSE
	SSmetadollars.add_amount(C, amount, "voucher")
	if(istype(source, /obj/item/pda))
		to_chat(user, span_notice("Казначейский билет был погружён в КПК и растворился на мельчайшие атомы, успешно зачислив метадоллары на ваш счёт."))
	else if(istype(source, /obj/item/card/id))
		to_chat(user, span_notice("Казначейский билет был погружён в ID-карту и растворился на мельчайшие атомы, успешно зачислив метадоллары на ваш счёт."))
	else
		to_chat(user, span_notice("Метадоллары зачислены на ваш счёт."))
	qdel(src)
	return TRUE

/obj/item/stack/metadollar/examine(mob/user)
	. = ..()
	. += span_notice("В стопке <b>[get_amount()]</b> М$. Зачисление: проведите по КПК или по ID-карте.")

/obj/item/stack/metadollar/AltClick(mob/living/user)
	if(!user.canUseTopic(src, BE_CLOSE, TRUE, FALSE) || zero_amount())
		return
	var/max_amt = get_amount()
	var/split_amount = round(input(user, "Сколько метадолларов отделить? (макс.: [max_amt])", "Стопка метадолларов") as null|num)
	if(split_amount == null || split_amount <= 0 || !user.canUseTopic(src, BE_CLOSE, TRUE, FALSE))
		return
	split_amount = min(max_amt, split_amount)
	split_stack(user, split_amount)
	to_chat(user, span_notice("Вы отделяете [split_amount] М$."))

/// Поставка из метамаазина: 50 М$ за 50 М$.
/obj/item/stack/metadollar/fifty
	amount = 50
