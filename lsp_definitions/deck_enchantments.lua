---@meta

---@class Multiverse.DeckEnchantment: SMODS.GameObject
---@field super? SMODS.GameObject|table Parent class.
---@field __call? fun(self: Multiverse.DeckEnchantment|table, o: Multiverse.DeckEnchantment|table): nil|table|Multiverse.DeckEnchantment
---@field extend? fun(self: Multiverse.DeckEnchantment|table, o: Multiverse.DeckEnchantment|table): table Primary method of creating a class.
---@field check_duplicate_register? fun(self: Multiverse.DeckEnchantment|table): boolean? Ensures objects already registered will not register.
---@field check_duplicate_key? fun(self: Multiverse.DeckEnchantment|table): boolean? Ensures objects with duplicate keys will not register. Checked on `__call` but not `take_ownership`. For take_ownership, the key must exist.
---@field register? fun(self: Multiverse.DeckEnchantment|table) Registers the object.
---@field check_dependencies? fun(self: Multiverse.DeckEnchantment|table): boolean? Returns `true` if there's no failed dependencies.
---@field process_loc_text? fun(self: Multiverse.DeckEnchantment|table) Called during `inject_class`. Handles injecting loc_text.
---@field send_to_subclasses? fun(self: Multiverse.DeckEnchantment|table, func: string, ...: any) Starting from this class, recusively searches for functions with the given key on all subordinate classes and run all found functions with the given arguments.
---@field pre_inject_class? fun(self: Multiverse.DeckEnchantment|table) Called before `inject_class`. Injects and manages class information before object injection.
---@field post_inject_class? fun(self: Multiverse.DeckEnchantment|table) Called after `inject_class`. Injects and manages class information after object injection.
---@field inject_class? fun(self: Multiverse.DeckEnchantment|table) Injects all direct instances of class objects by calling `obj:inject` and `obj:process_loc_text`. Also injects anything necessary for the class itself. Only called if class has defined both `obj_table` and `obj_buffer`.
---@field inject? fun(self: Multiverse.DeckEnchantment|table, i?: number) Called during `inject_class`. Injects the object into the game.
---@field take_ownership? fun(self: Multiverse.DeckEnchantment|table, key: string, obj: Multiverse.DeckEnchantment|table, silent?: boolean): nil|table|Multiverse.DeckEnchantment Takes control of vanilla objects. Child class must have get_obj for this to function
---@field get_obj? fun(self: Multiverse.DeckEnchantment|table, key: string): Multiverse.DeckEnchantment|table? Returns an object if one matches the `key`.
---@field calculate? fun(self: Multiverse.DeckEnchantment|table, enchantment: EnchantmentData, context: CalcContext): table? Calculates this object if it is applied to the deck.
---@field add_to_deck? fun(self: Multiverse.DeckEnchantment|table) Called when the enchantment is applied.
---@field remove_from_deck? fun(self: Multiverse.DeckEnchantment|table) Called when the enchantment is removed.
---@field max_level? integer The maximum level this enchantment can be.
---@field deck_incompat? string[] A list of keys of decks this enchantment cannot be applied to.
---@field in_pool? fun(self: Multiverse.DeckEnchantment|table, args: EnchantmentPoolArgs|table): any? Determines whether or not this enchantment can appear.
---@field enchant_incompat? string[] This enchantment cannot appear if any enchantments whose keys are in this table are currently applied.
---@field obj_buffer? string[] Array of keys to all objects registered to this class. 
---@field enchantment_type? EnchantmentType Classifies this enchantment as positive, neutral, or negative. For use with pools.
---@field obj_table? table<string, Multiverse.DeckEnchantment|table> Table of objects registered to this class.
---@field loc_vars? fun(self: Multiverse.DeckEnchantment, info_queue: table, enchantment: EnchantmentData|table): table?
---@field on_change_level? fun(self: Multiverse.DeckEnchantment|table, delta: integer, final_level: integer) Called when this enchantment's level changes.
---@field get_level? fun(self: Multiverse.DeckEnchantment|table): number Returns the current level of this enchantment.
---@field calc_dollar_bonus? fun(self: Multiverse.DeckEnchantment|table, enchantment: EnchantmentData): integer? Earns the returned amount of money at end of round, like Golden Joker.
---@field legendary? boolean Whether or not this enchantment follows the logic of The Soul and Black Hole.
---@field get_weight? fun(self: Multiverse.DeckEnchantment|table): number Returns the current weight of this Enchantment.
---@field base_weight? number The base weight of this Enchantment, which defaults to 4.
---@field create_fake_card? fun(self: Multiverse.DeckEnchantment|table) Creates a fake data entry for loc vars purposes.

---@alias EnchantmentType
---| "positive"
---| "neutral"
---| "negative"

---@class EnchantmentData
---@field level number
---@field ability table
---@field key string

---@class EnchantmentPoolArgs
---@field level_amt? integer Will equal 0 when checking if the enchantment can be spawned regardless of checked level.
---@field source string A string detailing the source of the item polling the enchantment pool.

---@overload fun(self: Multiverse.DeckEnchantment): Multiverse.DeckEnchantment
Multiverse.DeckEnchantment = setmetatable({}, {
	__call = function(self)
		return self
	end,
})
