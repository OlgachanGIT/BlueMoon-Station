#define METADOLLAR_CATALOG_LEGIT "legit"
#define METADOLLAR_CATALOG_SMUGGLE "smuggle"

/datum/metadollar_shop_item
	var/name = "Товар"
	var/desc = ""
	var/cost = 0
	var/catalog = METADOLLAR_CATALOG_LEGIT
	var/minimum_players = 0

/datum/metadollar_shop_item/proc/try_purchase(client/C)
	if(!C?.prefs)
		return FALSE
	if(minimum_players && length(GLOB.player_list) < minimum_players)
		to_chat(C.mob, span_warning("На сервере слишком мало игроков для этой покупки (нужно минимум [minimum_players])."))
		return TRUE
	if(C.prefs.metadollars < cost)
		to_chat(C.mob, span_warning("Недостаточно метадолларов."))
		return TRUE
	if(!queue_delivery(C))
		return FALSE
	C.prefs.metadollars -= cost
	C.prefs.save_preferences()
	to_chat(C.mob, span_notice("[delivery_message()]"))
	return TRUE

/datum/metadollar_shop_item/proc/queue_delivery(client/C)
	return FALSE

/datum/metadollar_shop_item/proc/delivery_message()
	return "Заказ будет в рюкзаке при следующем появлении на станции."

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

/datum/metadollar_shop_item/item/gift_anything_lootbox
	name = "Лутбокс"
	desc = "Коробка-сюрприз: используйте в руке (как подарок) — внутри окажется случайный предмет со станции."
	cost = 25
	catalog = METADOLLAR_CATALOG_LEGIT
	spawn_type = /obj/item/a_gift/anything

/datum/metadollar_shop_item/item/captain_spare_id
	name = "Запасная ID капитана"
	desc = "Золотая карта с полным доступом капитана (как из сейфа на мостике). Осторожно: это заметная вещь."
	cost = 500
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/card/id/captains_spare

/datum/metadollar_shop_item/item/traitor_token
	name = "Жетон «Предатель»"
	desc = "Пластиковая монета. Купить можно только при ≥50 игроках на сервере. В смене: Z или Alt+ЛКМ по жетону, чтобы получить роль предателя."
	cost = 250
	catalog = METADOLLAR_CATALOG_SMUGGLE
	minimum_players = 50
	spawn_type = /obj/item/coin/antagtoken/metashop/traitor

/datum/metadollar_shop_item/item/metadollar_total_burn
	name = "Протокол «Пепелище»"
	desc = "10000 М$: обнулить метадоллары у всех игроков (сохранения на сервере). На вашем счёте должно быть не меньше 10000 М$."
	cost = 10000
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = null
	minimum_players = 100

/datum/metadollar_shop_item/item/metadollar_total_burn/try_purchase(client/C)
	if(!C?.prefs)
		return FALSE
	if(C.prefs.metadollars < cost)
		to_chat(C.mob, span_warning("Недостаточно метадолларов (нужно [cost] М$)."))
		return TRUE
	bm_metadollar_global_burn(C.mob)
	message_admins("[key_name_admin(C.mob)] активировал протокол «Пепелище»: обнулены все балансы метадолларов.")
	log_game("Metadollar total burn: [key_name(C.mob)] wiped all metadollar balances.")
	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_danger("Межгалактическое казначейство: все балансы метадолларов обнулены. Сгорело всё."))
	return TRUE

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
	name = "Маяк «Мебель»"
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
	cost = 10
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
	cost = 100
	catalog = METADOLLAR_CATALOG_SMUGGLE
	spawn_type = /obj/item/book/granter/spell/summon_pie

/datum/metadollar_shop_item/item/don_foam_lmg
	name = "Игрушечный пенный пулемёт"
	desc = "Foam LMG — безопасный для станции."
	cost = 100
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
