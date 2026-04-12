#define METADOLLAR_CATALOG_LEGIT "legit"
#define METADOLLAR_CATALOG_SMUGGLE "smuggle"

/// Каталог метамаазина: один подтип = один товар (как /datum/gear в лодауте).
/datum/metadollar_shop_item
	var/name = "Товар"
	var/desc = ""
	var/cost = 0
	/// METADOLLAR_CATALOG_* — легальный витрина или «подполье».
	var/catalog = METADOLLAR_CATALOG_LEGIT

/datum/metadollar_shop_item/proc/try_purchase(client/C)
	if(!C?.prefs)
		return FALSE
	if(C.prefs.metadollars < cost)
		to_chat(C.mob, span_warning("Недостаточно метадолларов."))
		return TRUE
	if(!queue_delivery(C))
		return FALSE
	C.prefs.metadollars -= cost
	C.prefs.save_preferences()
	to_chat(C.mob, span_notice("[delivery_message()]"))
	return TRUE

/// Добавить доставку; вернуть FALSE при отказе (без списания — вызывающий не списывает до успеха).
/datum/metadollar_shop_item/proc/queue_delivery(client/C)
	return FALSE

/datum/metadollar_shop_item/proc/delivery_message()
	return "Заказ будет в рюкзаке при следующем появлении на станции."

/// Товар — спавн одного /obj/item в рюкзаке при входе в раунд.
/datum/metadollar_shop_item/item
	var/obj/item/spawn_type

/datum/metadollar_shop_item/item/queue_delivery(client/C)
	if(!ispath(spawn_type, /obj/item))
		return FALSE
	LAZYADD(C.prefs.metadollar_pending_items, "[spawn_type]")
	return TRUE

/datum/metadollar_shop_item/item/metadollar_voucher
	name = "Стопка обмена метадолларов"
	desc = "После доставки в рюкзак: зачисление 50 М$ на лобби-счёт проведением стопки по КПК или по ID-карте; Alt+ЛКМ — отделить любую сумму (можно передать другому игроку)."
	cost = 50
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/stack/metadollar/fifty

/datum/metadollar_shop_item/item/insulated_gloves
	name = "Изолированные перчатки"
	desc = "Стандартные жёлтые перчатки для работы с электрикой."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/clothing/gloves/color/yellow

/datum/metadollar_shop_item/item/sunglasses
	name = "Солнцезащитные очки"
	desc = "Классические тёмные стёкла защищают от вспышек."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/clothing/glasses/sunglasses

/datum/metadollar_shop_item/item/captain_spare_id
	name = "Запасная ID капитана"
	desc = "Золотая карта с полным доступом капитана (как из сейфа на мостике). Осторожно: это заметная вещь."
	cost = 250
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/card/id/captains_spare

/datum/metadollar_shop_item/item/traitor_token
	name = "Жетон «Предатель»"
	desc = "Пластиковая монета. ALT+ЛКМ по жетону, чтобы получить особые силы."
	cost = 250
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/coin/antagtoken/metashop/traitor

/datum/metadollar_shop_item/item/don_golden_horn
	name = "Золотой клаксон"
	desc = "Роскошный велосипедный гудок для истинных ценителей комедии."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/bikehorn/golden

/datum/metadollar_shop_item/item/don_scream_mask
	name = "Маска крика"
	desc = "Маска с особым эффектом на эмоции."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/clothing/mask/screammask

/datum/metadollar_shop_item/item/don_desk_beacon
	name = "Маяк «мебель для стола»"
	desc = "Вызывает доставку мебели на выбор."
	cost = 10
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/choice_beacon/box/desk

/datum/metadollar_shop_item/item/don_pet_beacon
	name = "Маяк питомца"
	desc = "Позволяет призвать компаньона-питомца."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/choice_beacon/pet

/datum/metadollar_shop_item/item/don_carpet_beacon
	name = "Маяк ковров"
	desc = "Доставка наборов коврового покрытия."
	cost = 10
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/choice_beacon/box/carpet

/datum/metadollar_shop_item/item/don_ration_pack
	name = "Сухпаёк NT (случайное меню)"
	desc = "Запечатанный рацион: при доставке выпадает одно из меню 1–4 (как безопасные MRE)."
	cost = 10
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/storage/box/mre/random_safe

/datum/metadollar_shop_item/item/don_tennis_rainbow
	name = "Радужная теннисная сфера"
	desc = "Пищащий мячик-трёхшарик — игрушка и антистресс."
	cost = 10
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/toy/fluff/tennis_poly/tri/squeak/rainbow

/datum/metadollar_shop_item/item/don_bedsheet_cosmos
	name = "Космическая простыня"
	desc = "Простыня с космическим принтом."
	cost = 10
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/bedsheet/cosmos

/datum/metadollar_shop_item/item/collectable_random_hat
	name = "Случайная коллекционная шляпа"
	desc = "Сувенир из серии collectable: при доставке в рюкзак выпадает абсолютно случайный вариант из всех подтипов."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/clothing/head/collectable/random_metashop

/datum/metadollar_shop_item/item/don_spacecash_1000
	name = "Пачка кредитов (1000 кр.)"
	desc = "Красивые станционные кредиты."
	cost = 25
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/stack/spacecash/c1000

/datum/metadollar_shop_item/item/don_chameleon_kit
	name = "Коробка хамелеона"
	desc = "Синдикатовский набор маскировки."
	cost = 50
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/storage/box/syndie_kit/chameleon

/datum/metadollar_shop_item/item/don_syndie_mask
	name = "Маска Синдиката"
	desc = "Тактическая маска в стиле Синдиката."
	cost = 25
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/clothing/mask/gas/syndicate

/datum/metadollar_shop_item/item/don_syndie_turtleneck
	name = "Тактическая водолазка Синдиката"
	desc = "Классические тёмные штаны и водолазка."
	cost = 25
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/clothing/under/syndicate

/datum/metadollar_shop_item/item/don_syndie_skirtleneck
	name = "Тактическая юбка Синдиката"
	desc = "Классические тёмные штаны и юбка."
	cost = 25
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/clothing/under/syndicate/skirt

/datum/metadollar_shop_item/item/don_summon_pie
	name = "Книга заклинания «Пирог»"
	desc = "Учит простому заклинанию призыва пирога."
	cost = 50
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/book/granter/spell/summon_pie

/datum/metadollar_shop_item/item/don_foam_lmg
	name = "Игрушечный пенный пулемёт"
	desc = "Foam LMG — безопасный для станции."
	cost = 50
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot

/datum/metadollar_shop_item/item/don_foam_lmg_mag
	name = "Магазин пенного LMG"
	desc = "Боезапас к игрушечному пулемёту."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/ammo_box/magazine/toy/m762/riot

/datum/metadollar_shop_item/item/don_jukebox
	name = "Портативный джукбокс"
	desc = "Музыка с собой — переносной проигрыватель."
	cost = 100
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/jukebox

#undef METADOLLAR_CATALOG_LEGIT
#undef METADOLLAR_CATALOG_SMUGGLE
