return {
	descriptions = {
		mul_Dummy = {
			du_mul_all_enchants = {
				name = "Deck Enchantments",
				text = {
					"Your deck is {C:mul_enchantedbook}enchanted{}",
					"{C:mul_enchantedbook}Enchantments{} apply passive",
					"effects to the run...",
				},
			},
			du_mul_half = {
				name = "Half Card",
				text = {
					"Fills {C:dark_edition}#1#{} hand space",
					"When hand is played,",
					"{C:green}#2# in #3#{} chance to",
					"{C:red}discard{} itself",
					"{C:inactive}(Not an enhancement){}",
				},
			},
			du_mul_half_left = {
				name = "Half Card (Left)",
				text = {
					"When hand is played,",
					"{C:green}#1# in #2#{} chance to",
					"{C:red}discard{} itself",
				},
			},
			du_mul_half_right = {
				name = "Half Card (Right)",
				text = {
					"When hand is played,",
					"{C:green}#1# in #2#{} chance to",
					"{C:red}discard{} itself",
				},
			},
			du_mul_exhausted = {
				name = "Exhausted",
				text = {
					"Does not return",
					"to deck until",
					"{C:attention}Boss Blind{} is",
					"defeated",
				},
			},
			du_mul_visible_enchant = {
				text = {
					"{C:mul_enchantedbook}#1#",
					"{C:inactive}(lvl. #2# -> lvl. #3#){}",
				},
			},
			du_mul_hidden_enchant = {
				text = { "{C:inactive}?????" },
			},
			du_mul_skill_cost_num = {
				text = {
					"Costs {C:attention}#1#%{} TP",
				},
			},
			du_mul_skill_cost_x = {
				text = {
					"Costs {C:attention}#1#%{} TP",
					"{C:inactive}(#1# is your current TP){}",
				},
			},
			du_mul_exhaust = {
				name = "Exhaust",
				text = {
					"When used, this",
					"card is removed",
					"from deck until",
					"{C:attention}Boss Blind{} is",
					"defeated",
				},
			},
			du_mul_ultimate = {
				name = "Ultimate",
				text = {
					"{C:red,E:2}Self-destructs{}",
					"after being used",
				},
			},
			du_mul_retain = {
				name = "Retain",
				text = {
					"Returns to {C:attention}hand{}",
					"after being used",
				},
			},
			du_mul_impervious = {
				name = "Impervious",
				text = {
					"Cannot be",
					"{C:red}debuffed",
				},
			},
			du_mul_impulse = {
				name = "Impulse",
				text = {
					"If no hands or",
					"discards were",
					"used this round,",
					"{C:attention}-#1#%{} TP cost",
				},
			},
		},
		Blind = {
			bl_mul_limbo = {
				name = "The Limbo",
				text = {
					"F O C U S",
				},
			},
			bl_mul_undying = {
				name = "The Undying",
				text = {
					"Survive",
				},
			},
			bl_mul_time_eater = {
				name = "The Time Eater",
				text = {
					"Ah... company.",
				},
			},
			bl_mul_spire_spear = {
				name = "Spire Spear",
				text = {
					"Cleanse the Spire",
				},
			},
			bl_mul_spire_shield = {
				name = "Spire Shield",
				text = {
					"Cleanse the Spire",
				},
			},
			bl_mul_corrupt_heart = {
				name = "Corrupt Heart",
				text = {
					"Cleanse the Spire",
				},
			},
		},
		Passive = {
			psv_mul_summon = {
				name = "Summon",
				text = {
					"After this {C:attention}Boss Blind{} is defeated,",
					"immediately face {C:attention}#1#{}",
				},
			},
			psv_mul_otherworldly = {
				name = "Otherworldly",
				text = {
					"This {C:attention}Boss Blind{} cannot appear, except",
					"when being summoned by another Blind",
				},
			},
			psv_mul_memorization = {
				name = "Memorization",
				text = {
					"If the minigame was {C:attention}failed{}, {X:purple,C:white}X#1#{} Blind size",
				},
			},
			psv_mul_unsightreadable = {
				name = "Unsightreadable",
				text = {
					"If the minigame was {C:attention}failed{}, flip all cards",
					"drawn to hand {C:attention}facedown{}",
				},
			},
			psv_mul_determination = {
				name = "Determination",
				text = {
					"If you get hit, lose score equal to {C:attention}#1#%{} of",
					"current Blind size",
				},
			},
			psv_mul_justice = {
				name = "Justice",
				text = {
					"If you get hit, destroy {C:attention}#1#{} random card",
					"currently held in hand",
				},
			},
			psv_mul_time_warp = {
				name = "Time Warp",
				text = {
					"{C:blue}-1{} hands this round for every {C:attention}12{} {C:inactive}(#1#){}",
					"playing cards selected this round",
					"Playing card selection count {C:attention}resets{} if",
					"played hand contains {C:attention}5{} scoring cards",
					"If you have {C:blue}0{} or less hands because of",
					"this effect, {C:red}lose the run",
				},
			},
			psv_mul_draw_reduction = {
				name = "Draw Reduction",
				text = {
					"If you would draw {C:attention}#1#{} or more cards,",
					"draw {C:attention}#2#{} cards instead",
				},
			},
			psv_mul_artifact = {
				name = "Artifact",
				text = {
					"Prevent the next {C:attention}#1#{} time(s) this {C:attention}Boss Blind{}",
					"would be {C:attention}disabled{} this round",
				},
			},
			psv_mul_bulky = {
				name = "Bulky",
				text = {
					"The required score to defeat this",
					"{C:attention}Boss Blind{} is {C:attention}doubled",
				},
			},
			psv_mul_surrounding = {
				name = "Surrounding",
				text = {
					"{C:attention}Remove{} leftmost and rightmost scored",
					"cards from scoring",
				},
			},
			psv_mul_invincible = {
				name = "Invincible",
				text = {
					"The required score to defeat this",
					"{C:attention}Boss Blind{} cannot be reduced",
				},
			},
			psv_mul_beat_of_death = {
				name = "Beat of Death",
				text = {
					"Scored cards give {C:blue}#1#{} Chips",
				},
			},
			psv_mul_debilitate = {
				name = "Debilitate",
				text = {
					"After drawing cards, {C:red}debuff{} {C:attention}#1#{} random",
					"undebuffed card in hand and {C:attention}flip #1#{} other",
					"random face up card in hand",
				},
			},
			psv_mul_vulnerable = {
				name = "Vulnerable",
				text = {
					"During final score calculation, {X:mult,C:white}X#1#{} Mult",
					"{C:attention}Removed{} after playing a hand",
				},
			},
			psv_mul_vulnerable_infoqueue = {
				name = "Vulnerable",
				text = {
					"During final score",
					"calculation, {X:mult,C:white}X#1#{} Mult",
					"{C:attention}Removed{} after",
					"playing a hand",
				},
			},
			psv_mul_burning = {
				name = "Burning",
				text = {
					"Level up discarded poker hand once",
					"{C:attention}Removed{} after discarding {C:attention}2{} {C:inactive}(#1#){} times",
				},
			},
			psv_mul_burning_infoqueue = {
				name = "Burning",
				text = {
					"Level up discarded",
					"poker hand once",
					"{C:attention}Removed{} after",
					"discarding {C:attention}2{} {C:inactive}(#1#){} times"
				},
			},
		},
		mul_DeckEnchantment = {
			de_mul_dark_affinity = {
				name = "Dark Affinity#1#",
				text = {
					"{V:1}+#2#{C:inactive}/{V:2}+#3#{} Joker slots",
					"{V:3}-#2#{C:inactive}/{V:4}-#3#{} hands",
				},
			},
			de_mul_flame_affinity = {
				name = "Flame Affinity#1#",
				text = {
					"{V:1}+#2#{C:inactive}/{V:2}+#3#{} discards",
					"{V:3}-#4#{C:inactive}/{V:4}-#5#{} hands",
				},
			},
			de_mul_aqua_affinity = {
				name = "Aqua Affinity#1#",
				text = {
					"{V:1}+#2#{C:inactive}/{V:2}+#3#{} hands",
					"{V:3}-#4#{C:inactive}/{V:4}-#5#{} discards",
				},
			},
			de_mul_cosmic_affinity = {
				name = "Cosmic Affinity#1#",
				text = {
					"When a {C:planet}Planet{} card is",
					"used, level up most played",
					"{C:attention}poker hand {V:1}#2#{C:inactive}/{V:2}#3#{} times",
					"{V:3}-#2#{C:inactive}/{V:4}-#3#{} consumable slots",
				},
			},
			de_mul_druidic_affinity = {
				name = "Druidic Affinity#1#",
				text = {
					"Earn an additional {V:1}$#2#{C:inactive}/{V:2}$#3#{}",
					"per remaining {C:blue}hand{} and",
					"{C:red}discard{} at end of round",
					"Raise all prices by {V:3}$#4#{C:inactive}/{V:4}$#5#{}",
				},
			},
			de_mul_artistic_affinity = {
				name = "Artistic Affinity#1#",
				text = {
					"{V:1}+#2#{C:inactive}/{V:2}+#3#{} hand size",
					"{V:3}-#4#{C:inactive}/{V:4}-#5#{} Joker slots",
				},
			},
			de_mul_light_affinity = {
				name = "Light Affinity#1#",
				text = {
					"Earn {V:1}$#2#{C:inactive}/{V:2}$#3#{} at",
					"end of round",
					"{V:3}-#4#{C:inactive}/{V:4}-#5#{} hand size",
				},
			},
			de_mul_arcane_affinity = {
				name = "Arcane Affinity#1#",
				text = {
					"Create {V:1}#2#{C:inactive}/{V:2}#3#{} {C:dark_edition}Negative{} copies",
					"of {C:tarot}The Fool{} after opening",
					"an {C:tarot}Arcana Pack",
					"Increase the base cost",
					"of rerolls by {V:3}$#4#{C:inactive}/{V:4}$#5#{}",
				},
			},
			de_mul_supernatural_affinity = {
				name = "Supernatural Affinity#1#",
				text = {
					"Create {V:1}#2#{C:inactive}/{V:2}#3#{} random {C:dark_edition}Negative{}",
					"{C:spectral}Spectral{} cards after",
					"defeating a {C:attention}Boss Blind",
					"{B:5,V:3}X#4#{C:inactive}/{B:6,V:4}X#5#{} Blind size when",
					"selecting a {C:blind}Blind{}",
				},
			},
			de_mul_illusory_affinity = {
				name = "Illusory Affinity#1#",
				text = {
					"Create {V:1}#2#{C:inactive}/{V:2}#3#{} random",
					"{C:attention}Tags{} after defeating",
					" a {C:attention}Boss Blind",
					"Lose {V:3}$#4#{C:inactive}/{V:4}$#5#{} at",
					"end of round",
				},
			},
			de_mul_plasma_affinity = {
				name = "Plasma Affinity#1#",
				text = {
					"Base {C:chips}Chips{} and {C:mult}Mult{} for",
					"played {C:attention}poker hands{} are",
					"{V:1}doubled{C:inactive}/{V:2}tripled{}",
					"Before playing a hand,",
					"{B:5,V:3}X#2#{C:inactive}/{B:6,V:4}X#3#{} Blind size",
				},
			},
			de_mul_decayed_affinity = {
				name = "Decayed Affinity#1#",
				text = {
					"Destroys up to {V:1}#2#{C:inactive}/{V:2}#3#{}",
					"random {C:attention}face cards{} in",
					"deck at end of round",
				},
			},
			de_mul_overflow = {
				name = "Overflow",
				text = {
					"Gives {X:mult,C:white}X#1#{} Mult per level",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
				},
			},
			de_mul_trib_blessing = {
				name = "Triboulet's Blessing",
				text = {
					"Retrigger scored {C:attention}Kings{}",
					"and {C:attention}Queens{} twice",
				},
			},
			de_mul_perkeo_blessing = {
				name = "Perkeo's Blessing",
				text = {
					"All held consumables",
					"give {X:mult,C:white}X#1#{} Mult",
				},
			},
			de_mul_canio_blessing = {
				name = "Canio's Blessing",
				text = {
					"If played hand is",
					"a single {C:attention}face{} card,",
					"destroy it and",
					"this Enchantment",
					"gains {X:mult,C:white}X#1#{} Mult",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}"
				},
			},
			de_mul_yorick_blessing = {
				name = "Yorick's Blessing",
				text = {
					"Discarded cards gain",
					"{X:mult,C:white}X#1#{} Mult permanently",
				},
			},
			de_mul_chicot_blessing = {
				name = "Chicot's Blessing",
				text = {
					"Jokers and playing cards",
					"cannot be {C:red}debuffed",
				},
			},
		},
		mul_EnchantedBook = {
			c_mul_enchanted_book = {
				name = "Enchanted Book",
				text = {
					"Use during a run to",
					"{C:mul_enchantedbook}enchant{} your deck",
					"{C:inactive}(Will do nothing if{}",
					"{C:inactive}not created inside an{}",
					"{C:mul_enchantedbook}Enchantment Table{C:inactive}){}",
				},
			},
			c_mul_enchanted_book_list_enchants = {
				name = "Enchanted Book",
				text = {
					"{C:mul_enchantedbook}Enchants{} your deck with",
				},
			},
		},
		mul_Skill = {
			sk_mul_strike = {
				name = "Strike",
				text = {
					"{X:purple,C:white}X#1#{} Blind size",
				},
			},
			sk_mul_snowgrave = {
				name = "Snowgrave",
				text = {
					"{C:attention}Exhaust{}",
					"After use, gives",
					"{C:attention}any{} number of",
					"selected cards",
					"{C:attention}Frozen Seals",
				},
			},
			sk_mul_jud_slash = {
				name = "Judgement Slash",
				text = {
					"{C:attention}Ultimate{}",
					"After use, splits {C:attention}1{} selected",
					"card into {C:attention}#1#/#2#{} Half Cards",
					"with {C:attention}random{} sides",
					"{C:inactive}(Rounds up){}",
				},
			},
			sk_mul_sinful_shell = {
				name = "Sinful Shell",
				text = {
					"{C:attention}Exhaust{}",
					"After use, destroy up",
					"to {C:attention}#1#/#2#{} selected cards",
					"{C:inactive}(Rounds up){}",
				},
			},
			sk_mul_objection = {
				name = "Objection",
				text = {
					"{C:attention}Impervious{}",
					"Playing cards cannot",
					"be {C:red}debuffed{} this round",
				},
			},
			sk_mul_teio_step = {
				name = "Sky High Teio Step",
				text = {
					"{C:attention}Exhaust{}",
					"After use, up to {C:attention}#1#{} selected",
					"cards permanently gain",
					"{C:attention}+#2#{} retriggers",
				},
			},
			sk_mul_embrittlement = {
				name = "Embrittlement",
				text = {
					"{X:purple,C:white}X#1#{} Blind size",
					"Applies {C:attention}Vulnerable{}",
					"to current Blind",
				},
			},
			sk_mul_rum_seventh = {
				name = { "Rank-Up-Magic", "The Seventh One" },
				text = {
					"{C:attention}Ultimate, Impulse{}",
					"After use, destroy {C:attention}#1#{} selected",
					"Jokers with the {C:attention}same{} rarity,",
					"then create a random Joker",
					"that can become {C:mul_transmuted}Transmutable{}",
					"and {C:attention}increase{} that Joker's",
					"progress towards becoming",
					"{C:mul_transmuted}Transmutable{} by {C:attention}#2#%{}",
				},
			},
			sk_mul_fireball = {
				name = "Fireball",
				text = {
					"Applies {C:attention}Burning{}",
					"to current Blind",
				},
			},
			sk_mul_ultra_instinct = {
				name = "Ultra Instinct",
				text = {
					"{C:attention}Exhaust{}",
					"After use, discard",
					"{C:attention}any{} number of",
					"selected cards",
					"Gain {C:attention}#1#%{} TP per",
					"discarded card",
				},
			},
			sk_mul_aurafarming = {
				name = "Aurafarming",
				text = {
					"{C:attention}Exhaust{}",
					"Set Thaumaturgy",
					"Energy to{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}0{}",
					"Gain {C:attention}1%{} TP for",
					"every{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}1{} lost",
					"{C:inactive}(Will gain {C:attention}#1#%{C:inactive} TP)"
				},
			},
			sk_mul_dupe_glitch = {
				name = "Duplication Glitch",
				text = {
					"{C:attention}Retain{}",
					"Create a {C:dark_edition}Negative",
					"copy of {C:attention}1{} selected",
					"consumable",
				},
			},
		},
		Enhanced = {
			m_mul_calling_card = {
				name = "Calling Card",
				text = {
					"Gives no base {C:chips}chips{}",
					"Always treated as an",
					"{C:attention}Ace{} of {C:hearts}Hearts{}",
					"Gives {X:mult,C:white}X#1#{} Mult",
					"per {C:attention}Boss Blind",
					"defeated this run",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
				},
			},
			m_mul_netherite = {
				name = "Netherite Card",
				text = {
					"Gives {C:money}$#2#{} when held in",
					"hand at end of round",
					"Gives {X:mult,C:white}X#1#{} Mult for each {C:money}$1{}",
					"you have when held in hand",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult){}",
				},
			},
			m_mul_normal = {
				name = "Normal Card",
				text = {
					"{C:chips}+#1#{} Chips",
					"Treated as",
					"a {C:attention}face card{}",
				},
			},
			m_mul_motivated = {
				name = "Motivated Card",
				text = {
					"Retrigger this",
					"card {C:attention}#1#{} time",
					"{C:green}#2# in #3#{} chance to",
					"lose enhancement",
				},
			},
			m_mul_waldo = {
				name = "Waldo Card",
				text = {
					"Gives no base {C:chips}chips{}",
					"Has no rank or suit",
					"Cannot be copied",
					"Retrigger this card {C:attention}#1#{}",
					"time for every {C:attention}#2#{} cards",
					"in full deck",
					"{C:inactive}(Currently {C:attention}#3#{C:inactive} retriggers){}",
					"{C:inactive}(Minimum of {C:attention}1{C:inactive} retrigger){}",
				},
			},
			m_mul_sus_yellow = {
				name = "Suspiciously Yellow Card",
				text = {
					"When discarded, earn {C:money}$#1#{}",
					"{C:red,E:2}Self-destructs{} after",
					"being discarded {C:attention}#2#{} {C:inactive}(#3#){} times",
				},
			},
			m_mul_frankenstein = {
				name = "Frankenstein Card",
				text = {
					"Is treated as {C:attention}both{} a",
					"{C:attention}#1#",
					"and a",
					"{C:attention}#2#",
				},
			},
			m_mul_frankenstein_none = {
				name = "Frankenstein Card",
				text = {
					"Is treated as {C:attention}both",
					"{C:attention}enhancements{} of the",
					"cards fused by",
					"{C:attention}Polymerization",
				},
			},
		},
		Edition = {
			e_mul_hyperdimensional = {
				name = "Hyperdimensional",
				text = {
					"{C:attention}+#1#{} Joker slot",
					"Gain {C:attention}#2#%{} TP and{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#3#{} Thaumaturgy",
					"Energy at end of round",
				},
			},
		},
		mul_Myth = {
			c_mul_philosophers_stone = {
				name = "Philosopher's Stone",
				text = {
					"Gain{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} per {C:mul_transmuted}Transmuted{}",
					"Joker owned, then {C:mul_transmuted,E:1}transmutes{}",
					"selected Joker that is",
					"currently {C:mul_transmuted}Transmutable{}",
					"{C:inactive}(Removes all Stickers{}",
					"{C:inactive}on selected Joker){}",
					"{C:inactive}(Currently{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{C:inactive}){}",
				},
			},
			c_mul_holy_grail = {
				name = "Holy Grail",
				text = {
					"Creates {C:attention}#1#{} {C:dark_edition}Negative{}",
					"consumables that are",
					"relevant to the",
					"{C:mul_transmuted}transmutation{} of",
					"{C:attention}1{} selected Joker",
				},
			},
			c_mul_perpetual_motion = {
				name = "Perpetual Motion Machine",
				text = {
					"Doubles current",
					"Thaumaturgy Energy",
					"{C:inactive}(Max of{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{C:inactive})",
				},
			},
			c_mul_tree_of_eden = {
				name = "Tree of Eden",
				text = {
					"Creates a random Joker",
					"that is relevant to",
					"the {C:mul_transmuted}transmutation{} of",
					"{C:attention}1{} selected Joker",
				},
			},
			c_mul_sphere = {
				name = "Sphere of Annhilation",
				text = {
					"{C:attention}Destroys{} all cards in hand",
					"Lose{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} per card destroyed",
					"{C:inactive}(Currently{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{C:inactive}){}",
				},
			},
			c_mul_chaos_emeralds = {
				name = "Chaos Emeralds",
				text = {
					"Increase {C:attention}1{} selected Joker's",
					"progress towards becoming",
					"{C:mul_transmuted}Transmutable{} by {C:attention}#1#%{}",
				},
			},
			c_mul_one_ring = {
				name = "One Ring",
				text = {
					"{C:attention}Halve{} your Thaumaturgy Energy",
					"Gain TP equal to the amount",
					"of Thaumaturgy Energy lost",
					"{C:inactive}(Currently {C:attention}+#1#%{C:inactive} TP){}",
				},
			},
			c_mul_mithridate = {
				name = "Mithridate",
				text = {
					"Creates a random",
					"Joker that can",
					"become {C:mul_transmuted}Transmutable{}",
				},
			},
			c_mul_rosetta_stone = {
				name = "Rosetta Stone",
				text = {
					"{C:attention}Flips{} all Jokers",
					"Gain{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} per",
					"Joker flipped",
					"{C:inactive}(Currently{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{C:inactive}){}",
				},
			},
			c_mul_shadow_crystal = {
				name = "Shadow Crystal",
				text = {
					"Set {C:attention}1{} selected Joker's",
					"progress towards becoming",
					"{C:mul_transmuted}Transmutable{} to its",
					"requirement minus {C:attention}1{}",
					"Gives the selected",
					"Joker {C:attention}Traitorous{}",
				},
			},
			c_mul_necronomicon = {
				name = "Necronomicon",
				text = {
					"Sets Thaumaturgy",
					"Energy to{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}0{}",
					"Creates a random",
					"{C:red}Rare{} Joker",
				},
			},
			c_mul_sacrifice = {
				name = "Sacrificial Ritual",
				text = {
					"Destroy {C:attention}1{} selected",
					"Joker that can",
					"become {C:mul_transmuted}Transmutable{}",
					"Gain{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{}",
				},
			},
			c_mul_puzzle = {
				name = "Millenium Puzzle",
				text = {
					"While active, increase",
					"{C:attention}base{} Thaumaturgy Energy",
					"recharge rate by{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{}",
					"but {C:attention}halves{} money earned",
					"from all sources",
					"{C:inactive}(Currently #2#){}",
				},
			},
			c_mul_three_goddesses = {
				name = "Three Goddesses Statue",
				text = {
					"Sets Thaumaturgy Energy to{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}0{}",
					"Increase {C:attention}1{} selected Joker's",
					"progress towards becoming",
					"{C:mul_transmuted}Transmutable{} by {C:attention}#1#%{}",
					"{C:inactive}(Cannot be used while Thaumaturgy{}",
					"{C:inactive}Energy is below{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{C:inactive}){}",
				},
			},
			c_mul_ufo = {
				name = "UFO",
				text = {
					"While active, increase",
					"{C:attention}base{} Thaumaturgy Energy",
					"recharge rate by{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} but {C:attention}-#2#{}",
					"card slots available in shop",
					"{C:inactive}(Currently #3#){}",
				},
			},
			c_mul_stand_arrow = {
				name = "Stand Arrow",
				text = {
					"While active, increase",
					"{C:attention}base{} Thaumaturgy Energy",
					"recharge rate by{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} but",
					"{C:red}debuffs{} all {V:1}#2#{} cards",
					"{C:inactive}(Suit changes at end of round){}",
					"{C:inactive}(Currently #3#){}",
				},
			},
			c_mul_moon_berry = {
				name = "Moon Berry",
				text = {
					"Give {C:dark_edition}Polychrome{} to",
					"{C:attention}1{} selected Joker",
					"Lose{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{}",
				},
			},
			c_mul_elder_scroll = {
				name = "Elder Scroll",
				text = {
					"While active, increase {C:attention}base{}",
					"Thaumaturgy Energy recharge",
					"rate by{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} but all playing",
					"cards are {C:attention}facedown{}",
					"{C:inactive}(Currently #2#){}",
				},
			},
			c_mul_master_sword = {
				name = "Master Sword",
				text = {
					"Destroy {C:attention}1{} selected Joker",
					"with at least {C:attention}1{} sticker",
					"Gain{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} per sticker",
					"on selected Joker",
					"{C:inactive}(Can bypass Eternal){}",
					"{C:inactive}(Currently{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{C:inactive}){}",
				},
			},
			c_mul_unicorn_horn = {
				name = "Unicorn's Horn",
				text = {
					"{C:red}Nullify{} the next decrease",
					"in Thaumaturgy Energy",
					"{C:inactive}(Currently {C:attention}#1#{C:inactive} nullifications){}",
				},
			},
			c_mul_kryptonite = {
				name = "Kryptonite",
				text = {
					"While active, increase {C:attention}base{}",
					"Thaumaturgy Energy recharge",
					"rate by{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} but {C:red}debuffs{}",
					"all {C:red}Rare{} Jokers",
					"{C:inactive}(Currently #2#){}",
				},
			},
			c_mul_infinity_gauntlet = {
				name = "Infinity Gauntlet",
				text = {
					"Increase {C:attention}1{} selected Joker's",
					"progress towards becoming",
					"{C:mul_transmuted}Transmutable{} by {C:attention}#1#%{}",
					"Randomly destroys {C:attention}half{}",
					"of all other Jokers",
				},
			},
			c_mul_super_star = {
				name = "Super Star",
				text = {
					"While active, {C:blue}+#1#{} hands and",
					"{C:red}+#2#{} discards but decrease",
					"{C:attention}base{} Thaumaturgy Energy",
					"recharge rate by{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#3#{}",
					"{C:inactive}(Currently #4#){}",
				},
			},
			c_mul_matrix = {
				name = "Matrix",
				text = {
					"While active, {C:attention}+#1#{} Joker",
					"slots but decrease",
					"{C:attention}base{} Thaumaturgy Energy",
					"recharge rate by{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{}",
					"{C:inactive}(Currently #3#){}",
				},
			},
			c_mul_time_machine = {
				name = "Time Machine",
				text = {
					"While active, all Jokers",
					"that can become {C:mul_transmuted}Transmutable{}",
					"gain {C:attention}#1#{} progress towards",
					"becoming {C:mul_transmuted}Transmutable{} at",
					"end of round but {C:red}nullify{}",
					"all Thaumaturgy Energy gain",
					"{C:inactive}(Currently #2#){}",
				},
			},
			c_mul_palace_treasure = {
				name = "Palace Treasure",
				text = {
					"Set Thaumaturgy",
					"Energy to{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}0{}",
					"Earn {C:money}$1{} for",
					"every{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} lost",
					"{C:inactive}(Currently {C:money}$#2#{C:inactive}){}",
				},
			},
			c_mul_journal = {
				name = "Journal",
				text = {
					"Creates the last {C:mul_transmuted}Myth{}",
					"Card used during this run",
					"{s:0.8,C:mul_transmuted}Journal{s:0.8} excluded",
				},
			},
			c_mul_homunculus = {
				name = "Homunculus",
				text = {
					"Creates up to {C:attention}#1#{}",
					"random {C:mul_transmuted}Myth{} cards",
				},
			},
		},
		Tag = {
			tag_mul_enchantment = {
				name = "Enchantment Tag",
				text = {
					"Gives a free",
					"{C:mul_enchantedbook}Enchantment Table",
				},
			},
			tag_mul_dimensional = {
				name = "Dimensional Tag",
				text = {
					"Gives a free",
					"{C:attention} Mega Dimension Pack",
				},
			},
		},
		Joker = {
			j_mul_thunderedge = {
				name = "ThunderEdge",
				text = {
					{
						"Whenever you lose",
						"Thaumaturgy Energy",
						"or TP, {C:attention}refund{} half",
						"the lost amount",
					},
				},
			},
			j_mul_proto = {
				name = "Proto",
				text = {
					{
						"Gains {X:mult,C:white}X#1#{} Mult per",
						"{C:attention}unique{} rank in",
						"played hand",
						"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
					},
				},
			},
			j_mul_bloodbath = {
				name = "Bloodbath",
				text = {
					{
						"All cards give {X:mult,C:white}X#1#{} Mult when",
						"scored on {C:attention}last hand{} of round",
					},
					{
						"{C:inactive,s:0.8}The Michigun UFO part",
						"{C:inactive,s:0.8}gives me nightmares",
					},
				},
			},
			j_mul_cataclysm = {
				name = "Cataclysm",
				text = {
					{
						"All cards give {C:mult}+#1#{} Mult when",
						"scored on {C:attention}last hand{} of round",
					},
					{
						"{C:inactive,s:0.8}We love mini wave chokepoints",
					},
				},
			},
			j_mul_magic_school_bus = {
				name = "Magic School Bus",
				text = {
					{
						"This Joker gains {C:mult}+#1#{} Mult per",
						"{C:attention}face{} card held in hand",
						"at end of round",
						"Resets if there are no",
						"{C:attention}face cards{} held in hand",
						"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
					},
					{
						'{C:inactive,s:0.8}"Mrs. Frizzle, where are we going?"',
						'{C:inactive,s:0.8}"We\'re going gambling!"',
					},
				},
			},
			j_mul_villager = {
				name = "Villager",
				text = {
					{
						"{C:mult}+#1#{} Mult, lose {C:money}$#2#{}",
						"when hand is played",
					},
					{
						"{C:inactive,s:0.8}Oh, them? They're the villagers!",
					},
				},
			},
			j_mul_antimatter = {
				name = "Antimatter",
				text = {
					{
						"{C:mult}+#1#{} Mult?",
					},
					{
						"{C:inactive,s:0.8}The ninth dimension is",
						"{C:inactive,s:0.8}[DATA EXPUNGED],",
						"{C:inactive,s:0.8}trust me bro",
					},
				},
			},
			j_mul_red_bloon = {
				name = "Red Bloon",
				text = {
					{
						"Earn {C:money}$#1#{} when a card is scored",
						"{C:red,E:2}Self-destructs{} in {C:attention}#3#{} rounds",
						"{C:inactive}(Currently #2#/#3#){}",
					},
					{
						"{C:inactive,s:0.8}Who is paying the monkeys",
						"{C:inactive,s:0.8}to pop these bloons?",
					},
				},
			},
			j_mul_ren_amamiya = {
				name = "Ren Amamiya",
				text = {
					{
						"{C:attention}First{} scored card",
						"becomes a {C:attention}Calling Card{}",
						"Retrigger all played {C:attention}Calling Cards{}",
						"once per {C:attention}distinct{} {C:tarot}Tarot{} card",
						"held in your {C:attention}consumables{} area",
						"{C:inactive}(Currently #1# retriggers){}",
					},
					{
						"{C:inactive,s:0.8}You never see it coming",
					},
				},
			},
			j_mul_steve = {
				name = "Steve",
				text = {
					{
						"{C:attention}+#1#{} hand size",
						"When hand is played, convert",
						"all {C:attention}Enhanced{} cards in",
						"hand into {C:attention}Netherite{} cards",
					},
					{
						"{C:inactive,s:0.8}L-l-l-lava,{}",
						"{C:inactive,s:0.8}ch-ch-ch-chicken,",
						"{C:inactive,s:0.8}Steve's lava chicken yeah",
						"{C:inactive,s:0.8}it's tasty as hell",
					},
				},
			},
			j_mul_summoned_skull = {
				name = "Summoned Skull",
				text = {
					{
						"{X:mult,C:white}X#1#{} Mult",
						"{C:attention}Destroys{} a random",
						"Joker when purchased",
					},
					{
						"{C:inactive,s:0.8}Don't do the Mr. Bones",
						"{C:inactive,s:0.8}glitch or else you'll get",
						"{C:inactive,s:0.8}sent to the Shadow Realm",
					},
				},
			},
			j_mul_fifty_fifty = {
				name = "50/50",
				text = {
					{
						"{C:green}#1# in #2#{} chance",
						"for {X:mult,C:white}X#3#{} Mult",
						"If this probability",
						"fails, {C:mult}+#4#{} Mult",
					},
					{
						"{C:inactive,s:0.8}The 50/50 feels like a",
						"{C:inactive,s:0.8}10/90 because of how often",
						"{C:inactive,s:0.8}I get a Qiqi",
					},
				},
			},
			j_mul_victory_royale = {
				name = "Victory Royale",
				text = {
					{
						"Create a random {C:dark_edition}Negative{}",
						"{C:spectral}Spectral{} card every",
						"{C:attention}#1#{} {C:inactive}(#2#){} cards scored",
					},
					{
						"{C:inactive,s:0.8}Who let Miku have a gun?",
					},
				},
			},
			j_mul_hammer_bro = {
				name = "Hammer Bro",
				text = {
					{
						"Scored cards {C:attention}randomly{} give",
						"either {C:mult}+#1#{} Mult",
						"or {X:mult,C:white}X#2#{} Mult",
					},
					{
						"{C:inactive,s:0.8}These turtles always",
						"{C:inactive,s:0.8}pick the worst time",
						"{C:inactive,s:0.8}to throw hammers at me",
					},
				},
			},
			j_mul_gerson = {
				name = "Gerson",
				text = {
					{
						"Disables every {C:attention}Boss Blind{}",
						"All Jokers give {X:mult,C:white}X#2#{} Mult",
						"per {C:attention}Boss Blind{} selected",
						"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
					},
					{
						"{C:inactive,s:0.8}I'm old!",
					},
				},
			},
			j_mul_stand_user = {
				name = "Stand User",
				text = {
					{
						"Prevents Death during",
						"a {C:attention}Boss Blind{}, then",
						"{C:attention}#1#{} Ante",
						"{C:red,E:2}Self-destructs{}",
					},
					{
						"{C:inactive,s:0.8}The stand user",
						"{C:inactive,s:0.8}could be anyone",
					},
				},
			},
			j_mul_waldo = {
				name = "Waldo",
				text = {
					{
						"Add a {C:attention}Waldo Card{} to deck",
						"when this Joker is obtained",
						"{C:attention}Waldo Cards{} give {X:mult,C:white}X#1#{} Mult",
						"per card in full deck",
						"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
					},
					{
						"{C:inactive,s:0.8}After years of searching,",
						"{C:inactive,s:0.8}we've finally found him",
					},
				},
			},
			j_mul_foddian_struggle = {
				name = "Foddian Struggle",
				text = {
					{
						"This Joker gains {C:mult}+#2#{} Mult",
						"per consecutive hand",
						"played without a {V:1}#1#{}",
						"{C:inactive}(Suit changes at end of round){}",
						"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
					},
					{
						"{C:inactive,s:0.8}Press F to pay respects",
						"{C:inactive,s:0.8}for the broken keyboards",
						"{C:inactive,s:0.8}and mice due to gamer rage",
					},
				},
			},
			j_mul_peashooter = {
				name = "Peashooter",
				text = {
					{
						"If played hand contains",
						"exactly {C:attention}1{} card,",
						"this Joker gains {C:mult}+#1#{} Mult",
						"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
					},
					{
						"{C:inactive,s:0.8}Dave must be feeding",
						"{C:inactive,s:0.8}them some crazy stuff",
						"{C:inactive,s:0.8}if their peas can",
						"{C:inactive,s:0.8}decapitate zombies",
					},
				},
			},
			j_mul_slime = {
				name = "Slime",
				text = {
					{
						"If played hand contains",
						"{C:attention}#1#{} scoring cards, earn {C:money}$#2#{}",
					},
					{
						"{C:inactive,s:0.8}Cute, squishy and flammable",
					},
				},
			},
			j_mul_jack_frost = {
				name = "Jack Frost",
				text = {
					{
						"First scored card",
						"in played hand",
						"becomes a {C:attention}Jack{}",
					},
					{
						"{C:inactive,s:0.8}Hee Ho{}",
					},
				},
			},
			j_mul_dragon = {
				name = "Dragon",
				text = {
					{
						"Destroy all discarded {C:attention}Kings{}",
						"Gains {X:mult,C:white}X#1#{} Mult per",
						"{C:attention}King{} discarded",
						"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
					},
					{
						"{C:inactive,s:0.8}Currently in a romantic",
						"{C:inactive,s:0.8}relationship with a donkey",
					},
				},
			},
			j_mul_arms_dealer = {
				name = "Arms Dealer",
				text = {
					{
						"If played hand contains",
						"exactly {C:attention}5{} cards, destroy",
						"a random card in hand",
					},
					{
						"{C:inactive,s:0.8}\"I see you're eyeballin' the",
						"{C:inactive,s:0.8}Minishark... You really don't",
						'{C:inactive,s:0.8}want to know how it was made."',
					},
				},
			},
			j_mul_heavy = {
				name = "Heavy",
				text = {
					{
						"{C:blue}+#1#{} hands",
						"Evenly distribute {C:attention}#3#{}",
						"retriggers across",
						"all scored cards",
						"Increases by {C:attention}#2#{}",
						"per hand remaining",
					},
					{
						"{C:inactive,s:0.8}It costs 400,000 dollars to",
						"{C:inactive,s:0.8}fire this gun for 12 seconds",
					},
				},
			},
			j_mul_impostor = {
				name = "Impostor",
				text = {
					{
						"Copies the effect of",
						"the {C:attention}Jokers{} to the",
						"right and left",
					},
					{
						"{C:inactive,s:0.8}When the impostor is sus",
					},
				},
			},
			j_mul_frozone = {
				name = "Frozone",
				text = {
					{
						"{C:attention}Frozen Seals{} instead gain",
						"{X:mult,C:white}X#1#{} Mult when scored",
						"{C:attention}Frozen Seals{} also trigger",
						"while held in hand",
					},
					{
						"{C:inactive,s:0.8}Where's my super suit?",
					},
				},
			},
		},
		Spectral = {
			c_mul_eternity = {
				name = "Eternity",
				text = {
					"Gives all Jokers {C:attention}Eternal{}",
					"Destroy {C:attention}#1#{} random card in",
					"hand per {C:attention}Eternal{} Joker",
				},
			},
			c_mul_eternity_alt = {
				name = "Eternity",
				text = {
					"Gives all Jokers {C:attention}Eternal{}",
					"Destroy {C:attention}#1#{} random card in",
					"hand per {C:attention}Eternal{} Joker",
					"{C:inactive}(Destroy all Jokers that",
					"{C:inactive}cannot become Eternal)",
				},
			},
			c_mul_backstab = {
				name = "Backstab",
				text = {
					"Create a {C:dark_edition}Negative{} copy",
					"of a random Joker, then",
					"give {C:attention}Traitorous{} to the copy",
				},
			},
			c_mul_scheme = {
				name = "Pyramid Scheme",
				text = {
					"Gives {C:attention}triple{} the total sell",
					"value of all Jokers, then",
					"gives all Jokers {C:attention}Rental{}",
					"{C:inactive}(Will give {C:money}$#1#{C:inactive}){}",
				},
			},
		},
		Tarot = {
			c_mul_lobotomized = {
				name = "The Lobotomy",
				text = {
					"Enhances {C:attention}#1#{}",
					"selected cards to",
					"{C:attention}Normal Cards{}",
				},
			},
			c_mul_chair = {
				name = "The Chair",
				text = {
					"Enhances {C:attention}#1#{} selected",
					"card into a",
					"{C:attention}Motivated Card{}",
				},
			},
			c_mul_apple = {
				name = "The Apple",
				text = {
					"Plays the entire",
					"{C:attention}Bad Apple{} video",
					"for no benefit",
				},
			},
			c_mul_burger = {
				name = "The Burger",
				text = {
					"Plays an {C:attention}animation{} of a",
					"member of the official",
					"Balatro Discord server eating",
					"a {C:attention}burger{} for {C:attention}1{} minute",
				},
			},
			c_mul_eggman = {
				name = "Dr. Eggman",
				text = {
					"Enhances all {C:clubs}Clubs{}",
					"held in hand into",
					"{C:attention}Suspiciously Yellow",
					"{C:attention}Cards",
				},
			},
			c_mul_lightsaber = {
				name = "The Lightsaber",
				text = {
					"Splits {C:attention}#1#{} random",
					"card held in hand",
					"into {C:attention}2{} Half Cards",
					"with {C:attention}opposite{} sides",
				},
			},
			c_mul_polymerization = {
				name = "Polymerization",
				text = {
					"Fuse {C:attention}#1#{} selected",
					"enhanced Half Cards",
					"with {C:attention}opposite{} sides and",
					"{C:attention}different{} enhancements",
					"into a {C:attention}Frankenstein Card",
				},
			},
		},
		Other = {
			p_mul_enchantment_table_normal = {
				name = "Enchantment Table",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} {C:mul_enchantedbook}Enchanted Books",
					"and {C:attention}apply{} the book's",
					"{C:mul_enchantedbook}enchantments{} to {C:attention}deck",
				},
			},
			p_mul_dimension_normal1 = {
				name = "Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_dimension_normal2 = {
				name = "Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_dimension_normal3 = {
				name = "Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_dimension_normal4 = {
				name = "Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_dimension_jumbo1 = {
				name = "Jumbo Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_dimension_jumbo2 = {
				name = "Jumbo Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_dimension_mega1 = {
				name = "Mega Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_dimension_mega2 = {
				name = "Mega Dimension Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} items from the",
					"{C:mul_transmuted}Multiverse{} mod",
				},
			},
			p_mul_skill_normal1 = {
				name = "Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			p_mul_skill_normal2 = {
				name = "Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			p_mul_skill_normal3 = {
				name = "Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			p_mul_skill_normal4 = {
				name = "Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			p_mul_skill_jumbo1 = {
				name = "Jumbo Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			p_mul_skill_jumbo2 = {
				name = "Jumbo Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			p_mul_skill_mega1 = {
				name = "Mega Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			p_mul_skill_mega2 = {
				name = "Mega Skill Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{} Skill Cards to",
					"add to your deck",
				},
			},
			mul_transmutable = {
				name = "Transmutable",
				text = {
					"Can use {C:attention}Philosopher's Stone{}",
					"on this card to create",
					"{C:mul_transmuted,E:1}Transmuted{} Jokers",
					"Gain{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#1#{} at end of round",
				},
			},
			mul_traitorous = {
				name = "Traitorous",
				text = {
					"{C:attention}Destroys{} leftmost Joker",
					"at end of round",
					"{C:inactive}(Bypasses Eternal){}",
				},
			},
			undiscovered_mul_myth = {
				name = "Not Discovered",
				text = {
					"Purchase or use",
					"this card in an",
					"unseeded run to",
					"learn what it does",
				},
			},
			undiscovered_mul_enchantedbook = {
				name = "Not Discovered",
				text = {
					"Find this card",
					"within a certain",
					"Table while in an",
					"unseeded run to",
					"learn what it does",
				},
			},
			undiscovered_mul_deckenchantment = {
				name = "Not Discovered",
				text = {
					"Enchant your deck",
					"with this specific",
					"enchantment in an",
					"unseeded run to",
					"learn what it does",
				},
			},
			mul_frozen_seal = {
				name = "Frozen Seal",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"Loses {X:mult,C:white}X#2#{} Mult",
					"when scored",
				},
			},
			--#region Activated ability descriptions
			mul_steve_ability = {
				name = "Ability: Crafting",
				text = {
					"Cost: {C:attention}#1#%{} TP",
					"Effect: Destroy any number",
					"of selected cards, then",
					"create an equal number",
					"of {C:attention}Netherite Cards{} with",
					"a random {C:attention}Seal{} and {C:attention}Edition{}",
				},
			},
			mul_heavy_ability = {
				name = "Ability: Sandvich",
				text = {
					"Cost: {C:attention}#1#%{} TP",
					"Effect: Gain {C:blue}+#2#{} hands",
					"this round",
				},
			},
			mul_impostor_ability = {
				name = "Ability: Murder",
				text = {
					"Cost: {C:attention}#1#%{} TP",
					"Effect: {X:purple,C:white}X#2#{} Blind size",
					"{X:purple,C:white}^#3#{} Blind size instead if",
					"{C:attention}Ante{} is greater than {C:attention}#4#{}",
				},
			},
			mul_thunderedge_ability = {
				name = "Ability: Omniscience",
				text = {
					"Cost: {C:attention}#1#%{} TP,{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{}",
					"Effect: Creates a",
					"{C:attention}Dimensional Tag",
				},
			},
			mul_frozone_ability = {
				name = "Ability: Freeze",
				text = {
					"Cost: {C:attention}#1#%{} TP",
					"Effect: Apply a {C:attention}Frozen",
					"{C:attention}Seal{} to {C:attention}#2#{} selected card",
				},
			},
			--#endregion
			--#region Transmutation hints
			joker_hint = {
				name = "Hint",
				text = {
					"Use {C:attention}#2#{} distinct",
					"{C:tarot}Tarot{} cards",
					"{C:inactive}(#1#/#2#){}",
				},
			},
			mul_dragon_hint = {
				name = "Hint",
				text = {
					"Obtain {C:attention}#2#{} {C:attention}Gold{},",
					"{C:attention}Stone{} and {C:attention}Steel{} cards",
					"{C:inactive}(#1#/#2#){}",
				},
			},
			mul_hammer_bro_hint = {
				name = "Hint",
				text = {
					"Trigger this card",
					"{C:attention}#2#{} times",
					"{C:inactive}(#1#/#2#){}",
				},
			},
			pareidolia_hint = {
				name = "Hint",
				text = {
					"Play {C:attention}#2#{} unique",
					"{C:attention}poker hands{}",
					"{C:inactive}(#1#/#2#){}",
				},
			},
			mul_arms_dealer_hint = {
				name = "Hint",
				text = {
					"Spend {C:money}$#2#{} while",
					"in the {C:attention}shop{}",
					"{C:inactive}(#1#/#2#){}",
				},
			},
			invisible_hint = {
				name = "Hint",
				text = {
					"Obtain {C:attention}#2#{} different",
					"Jokers while owned",
					"{C:inactive}(#1#/#2#){}",
				},
			},
			mul_jack_frost_hint = {
				name = "Hint",
				text = {
					"Destroy {C:attention}#2#{}",
					"playing cards",
					"{C:inactive}(#1#/#2#){}",
				},
			},
			--#endregion
			--#region Mechanic descriptions
			mul_thaumaturgy_desc = {
				name = "Thaumaturgy Energy",
				text = {
					"#1#{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}#2#{} at end of round",
					"If Thaumaturgy Energy",
					"exceeds{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}100{} at end of",
					"round, set Thaumaturgy",
					"Energy to{s:0.56} {C:mul_transmuted,f:mul_thaum_icon,E:mul_rotate}+{C:mul_transmuted}0{} and create",
					"a {C:attention}Philosopher's Stone",
					"{C:inactive}(Must have room){}",
				},
			},
			mul_TP_desc = {
				name = "TP (Tension Points)",
				text = {
					"TP is used for activating",
					"the abilities of certain",
					"{C:attention}Jokers{} and {C:attention}Skill Cards{}",
					"If total score of played",
					"hand does not exceed current",
					"blind size, gain {C:attention}#1#-#2#%{} TP",
					"{C:inactive}(TP is capped at {C:attention}100%{C:inactive}){}",
					"Hold {C:attention}P{} to make the TP meter",
					"visible on top of any held {C:attention}Tags{}",
				},
			},
			mul_blind_keybind_info = {
				name = "Keybind Info",
				text = {
					"Hold {C:attention}I{} to make the current",
					"Blind's instructions visible",
					"on top of any held {C:attention}Tags{}",
				},
			},
			mul_TP_desc_joke1 = {
				name = "TP (Toilet Paper)",
				text = {
					"TP is used for activating",
					"the abilities of certain",
					"{C:attention}Jokers{} and {C:attention}Skill Cards{}",
					"If total score of played",
					"hand does not exceed current",
					"blind size, gain {C:attention}#1#-#2#%{} TP",
					"{C:inactive}(TP is capped at {C:attention}100%{C:inactive}){}",
					"Hold {C:attention}P{} to make the TP meter",
					"visible on top of any held {C:attention}Tags{}",
				},
			},
			mul_TP_desc_joke2 = {
				name = "TP (Yes, you read that right)",
				text = {
					"TP is used for activating",
					"the abilities of certain",
					"{C:attention}Jokers{} and {C:attention}Skill Cards{}",
					"If total score of played",
					"hand does not exceed current",
					"blind size, gain {C:attention}#1#-#2#%{} TP",
					"{C:inactive}(TP is capped at {C:attention}100%{C:inactive}){}",
					"Hold {C:attention}P{} to make the TP meter",
					"visible on top of any held {C:attention}Tags{}",
				},
			},
			mul_active_consumable = {
				name = "Active Consumable",
				text = {
					"When used, this consumable will",
					"{C:attention}remain{} in your consumable slots",
					"and apply its {C:attention}active{} effects",
					"If used while active, this",
					"consumable is used like normal",
					"and will {C:attention}stop{} applying its effects",
					"{C:inactive}(Note that this card will receive{}",
					"{C:inactive}Eternal while it is active){}",
				},
			},
			--#endregion
			--#region Blind instructions
			mul_limbo_inst = {
				name = "Instructions",
				text = {
					"Before first hand is played,",
					"{C:attention}8{} keys will appear on screen",
					" ",
					"Pay attention to the {C:attention}key{}",
					"that is flashing {C:green}green{}",
					" ",
					"In a moment, the keys will",
					"start to {C:attention}shuffle{} around",
					" ",
					"When the keys stop moving,",
					"{C:attention}click{} the key that was",
					"originally flashing {C:green}green{}",
				},
			},
			mul_undying_inst = {
				name = "Instructions",
				text = {
					"When playing a hand, a",
					"{C:green}green{} heart will appear,",
					"as well as a {C:blue}blue{} shield",
					" ",
					"Use {C:attention}arrow keys{} to block",
					"the incoming spears by",
					"pointing the shield in",
					"the direction of the spear",
					" ",
					"Yellow spears will {C:attention}flip{}",
					"direction once they are",
					"about halfway to the heart",
				},
			},
			--#endregion
		},
	},
	misc = {
		poker_hands = {
			mul_storm = "Storm",
		},
		poker_hand_descriptions = {
			mul_storm = {
				"5 cards that each have different ranks",
				"and have 4 distinct suits among them",
			},
		},
		challenge_names = {
			c_mul_waterfall = "Waterfall",
			c_mul_monsoon = "But The Earth Refused.",
			c_mul_cant_touch_this = "Can't Touch This",
		},
		v_text = {
			ch_c_mul_waterfall1 = { "Every {C:attention}Boss Blind{} is replaced with {C:red}The Undying{}" },
			ch_c_mul_waterfall2 = {
				"If {C:chips}score{} is below {X:purple,C:white}X-0.5{} Blind size, {C:red}lose instantly{}",
			},
			ch_c_mul_waterfall3 = {
				"You lose {C:attention}twice{} as many chips if hit by a spear",
			},
			ch_c_mul_waterfall4 = {
				"If you get hit by {C:red}The Undying{}, {C:red}lose instantly{}",
			},
		},
		dictionary = {
			k_multiverse_desc = "A content mod by ThunderEdge",
			k_mul_thunderedge_credits = {
				"Creator of {C:mul_transmuted}Multiverse{}",
				"Implemented all of",
				"{C:mul_transmuted}Multiverse{}'s mechanics",
			},
			k_mul_proto_credits = {
				"Added some {C:attention}challenges{}",
				"Added attack patterns",
				"for {C:attention}The Undying{}",
			},
			k_mul_enchantment_table = "Enchant your Deck",
			k_mul_dimension = "Traverse Reality",
			k_mul_skills = "Learn Skills",
			k_mul_level_up = "Level Up!",
			k_mul_level_down = "Level Down...",
			k_mul_enchanted = "Enchanted!",
			k_mul_disenchanted = "Disenchanted...",
			k_mul_active = "active",
			k_mul_inactive = "inactive",
			k_mul_transmuted = "Transmuted",
			k_mul_missed_bus = "Missed the bus!",
			k_mul_antimatter_init = "And so it begins...",
			k_mul_antimatter_grow1 = "More!",
			k_mul_antimatter_grow2 = "Even more!",
			k_mul_antimatter_grow3 = "Is this too much?",
			k_mul_antimatter_grow4 = "What have we done?",
			k_mul_popped = "Popped!",
			k_mul_converted = "Converted!",
			k_mul_won_fifty_fifty = "Won!",
			k_mul_lost_fifty_fifty = "Lost...",
			k_mul_eliminated = "Eliminated!",
			k_mul_boom = "Boom!",
			k_mul_murdered = "Murdered!",
			k_mul_frozen = "Frozen!",
			k_mul_destroyed = "Destroyed!",
			k_mul_thaumaturgy_energy = "Thaumaturgy Energy",
			k_mul_make_room = "Must have at least 1 available consumable slot",
			k_mul_make_room2 = "in order to create a Philosopher's Stone...",
			k_mul_confirm = "Confirm",
			k_mul_run_info = "Run Info",
			k_mul_TP = "TP",
			k_mul_myth = "Myth",
			k_mul_deckenchantment = "Deck Enchantment",
			k_mul_enchantedbook = "Enchanted Book",
			k_mul_skill = "Skill Card",
			k_mul_activate = "Activate",
			k_mul_ability = "Ability",
			k_mul_none = "none",
			b_mul_myth_cards = "Myth Cards",
			b_mul_deckenchantment_cards = "Deck Enchantments",
			b_mul_enchantedbook_cards = "Enchanted Books",
			b_mul_skill_cards = "Skill Cards",
			b_mul_discord_server = "My Discord Server",
			b_mul_landing_page = "About Me",
			k_mul_ubw = "Select 1 card to split into #1# Half Cards",
			k_mul_snowgrave = "Apply Frozen Seals to any number of selected cards",
			k_mul_sinful_shell = "Select up to #1# cards to destroy",
			k_mul_teio_step = "Give +#2# retriggers permanently to up to #1# selected cards",
			k_mul_rum_seventh = "Select #1# Jokers to destroy",
			k_mul_ultra_instinct = "Discard any number of selected cards",
			k_mul_dupe_glitch = "Create a Negative copy of 1 selected consumable",
			mul_stand_user = "Saved by Stand User via time reversal",
			k_mul_eggman_speech = {
				"I'VE COME TO MAKE AN ANNOUNCEMENT",
				"THE PLANT IS A BITCH ASS MOTHERFUCKER",
				"IT DEBUFFED MY FUCKING FACE CARDS",
				"THAT'S RIGHT",
				"IT TOOK ITS GREEN FUCKING LEAVES",
				"AND DEBUFFED MY FACE CARDS",
				"AND IT SAID ITS BLIND WAS THIS BIG",
				"AND I SAID THAT'S DISGUSTING",
				"SO I'M MAKING A",
				"CALLOUT POST ON TWITTER DOT COM",
				"THE PLANT, YOU'VE GOT A WEAK EFFECT",
				"IT'S AS POWERFUL AS THE SERPENT,",
				"EXCEPT WAY WEAKER",
				"AND GUESS WHAT",
				"HERE'S WHAT MY EFFECT LOOKS LIKE",
				"BOOM",
				"THAT'S RIGHT BABY",
				"ALL JOKERS",
				"NO DEBUFFS",
				"NO FLIPS",
				"LOOK AT THAT",
				"IT LOOKS LIKE ALL BLINDS ARE DISABLED",
				"IT DEBUFFED MY FACE CARDS",
				"SO GUESS WHAT",
				"I'M GONNA DISABLE THE BLIND",
				"THAT'S RIGHT THIS IS WHAT YOU GET",
				"MY SUPER LASER DISABLE",
				"EXCEPT I'M NOT GONNA DISABLE THIS BLIND",
				"I'M GONNA GO HIGHER",
				"I'M DISABLING EVERY BLIND",
				"HOW DO YA LIKE THAT, LOCALTHUNK?",
				"I DISABLED EVERY BLIND, YOU IDIOT",
				"YOU HAVE 7 ANTES",
				"BEFORE THE Boss Disabled!",
				"HITS THE VERDANT LEAF",
				"NOW GET REROLLED",
				"BEFORE I DISABLE YOU TOO",
			},
			mul_config_menu_text = {
				"Debug Mode affects several elements of the mod for easier debugging.",
				"Debug Mode {C:attention}cannot{} be enabled, except if a certain file is loaded.",
				"{C:inactive}(If you want to contribute to this mod, DM me and I will send{}",
				"{C:inactive}you a copy of the file that allows you to enable Debug Mode){}",
				"If you change a setting here, the game will {C:attention}automatically{} restart",
				"and apply any changes associated with the setting as soon as you",
				"exit this menu, such as enabling debug utilities or joke content.",
			},
			mul_config_menu_title = {
				"{C:white}Change {C:mul_transmuted}Multiverse{C:white}'s settings here",
			},
			mul_music_menu_text = {
				"{C:attention}Enable{} or {C:attention}disable{} certain songs that this mod uses",
				"{C:attention}Hover{} over the song details to see when the song plays",
			},
			mul_multiverse = "Multiverse",
			mul_contributors = "Contributors",
			mul_inspirations = "Inspirations",
			mul_misc_credits = {
				"{V:1}Aikoyori {C:inactive}(Aikoyori's Shenanigans)",
				"{V:2}nh6574 {C:inactive}(JoyousSpring)",
				"{V:3}Mysthaps {C:inactive}(Lobotomy Corporation)",
				"{V:4}Ruby {C:inactive}(Entropy, DATA EXPUNGED)",
				"{V:5}GhostSalt {C:inactive}(Phanta, Catan, etc.)",
				"{V:6}Revo {C:inactive}(Revo's Vault, Judgement)",
				"{V:7}Lily Felli {C:inactive}(Valkarri, Aquillari)",
				"{V:8}TheOneGoofAli {C:inactive}(TOGA's Stuff)",
				"{V:9}Astra {C:inactive}(Maximus, Hot Potato, etc.)",
				"{V:10}Yahiamice {C:inactive}(Yahimod)",
				"{V:11}PaperMoon {C:inactive}(Paperback)",
			},
			mul_debug = "Enable Debug Mode",
			mul_joke = "Enable Joke Content",
			["mul_Prophecy"] = {
				"Plays when you have",
				"a Joker that has the",
				"{C:mul_transmuted}Transmutable{} sticker",
			},
			["mul_Life Will Change"] = {
				"Plays when you",
				"have {C:attention}Ren Amamiya{}",
			},
			["mul_Pigstep"] = {
				"Plays when you",
				"have {C:attention}Steve{}",
			},
			["mul_Hammer of Justice"] = {
				"Plays when you",
				"have {C:attention}Gerson{}",
			},
			["mul_Sneaky Snitch"] = {
				"Plays when you",
				"have {C:attention}Waldo{}",
			},
			["mul_Battle Against a True Hero"] = {
				"Plays when facing",
				"{C:attention}The Undying",
			},
			["mul_Seek"] = {
				"Plays when you",
				"have {C:attention}Impostor{}",
			},
			["mul_Main Theme (TF2)"] = {
				"Plays when you",
				"have {C:attention}Heavy{}",
			},
			["mul_Isolation"] = {
				"Plays when facing",
				"{C:attention}The Limbo",
			},
			ml_skill_card_explanation = {
				"Skill Cards are sent to the discard pile when used, except if specified otherwise",
				"Skill Cards have no rank or suit, and will not score regardless of played poker hand",
			},
		},
		labels = {
			mul_transmutable = "Transmutable",
			mul_traitorous = "Traitorous",
			-- myth = "Myth",
			-- deckenchantment = "Deck Enchantment",
			-- enchantedbook = "Enchanted Book",
			-- skill = "Skill Card",
			k_mul_transmuted = "Transmuted",
			mul_hyperdimensional = "Hyperdimensional",
			mul_frozen_seal = "Frozen Seal",
		},
		v_dictionary = {
			a_mul_thaumaturgy_energy = "+#1# Energy",
			a_mul_TP = "+#1#% TP",
			a_mul_x_blind_size = "X#1# Blind Size",
			a_mul_plus_blind_size = "+#1# Blind Size",
		},
	},
}
