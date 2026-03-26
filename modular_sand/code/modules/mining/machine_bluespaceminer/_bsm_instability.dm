/// Bluespace miner sector instability: tiered effects (see low/medium/high_threat.dm).

/// Minimum sector instability (%) before any random effect can roll.
#define BSM_INSTABILITY_ROLL_MIN 10
/// Below this: only benign effects (plush, sounds).
#define BSM_INSTABILITY_TIER_MEDIUM 50
/// Below this (but >= TIER_MEDIUM): medium threats; at or above: high threats.
#define BSM_INSTABILITY_TIER_HIGH 75

/datum/bsm_instability_effect

/datum/bsm_instability_effect/proc/trigger(obj/machinery/mineral/bluespace_miner/machine)
	return
