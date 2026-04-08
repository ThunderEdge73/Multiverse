---@meta

---@class Multiverse.UsableJoker: SMODS.Joker
---@field super? SMODS.Joker|table Parent class.
---@field __call? fun(self: Multiverse.UsableJoker|table, o: Multiverse.UsableJoker|table): nil|table|Multiverse.UsableJoker
---@field extend? fun(self: Multiverse.UsableJoker|table, o: Multiverse.UsableJoker|table): table Primary method of creating a class.
---@field check_duplicate_register? fun(self: Multiverse.UsableJoker|table): boolean? Ensures objects already registered will not register.
---@field check_duplicate_key? fun(self: Multiverse.UsableJoker|table): boolean? Ensures objects with duplicate keys will not register. Checked on `__call` but not `take_ownership`. For take_ownership, the key must exist.
---@field register? fun(self: Multiverse.UsableJoker|table) Registers the object.
---@field check_dependencies? fun(self: Multiverse.UsableJoker|table): boolean? Returns `true` if there's no failed dependencies.
---@field process_loc_text? fun(self: Multiverse.UsableJoker|table) Called during `inject_class`. Handles injecting loc_text.
---@field send_to_subclasses? fun(self: Multiverse.UsableJoker|table, func: string, ...: any) Starting from this class, recusively searches for functions with the given key on all subordinate classes and run all found functions with the given arguments.
---@field pre_inject_class? fun(self: Multiverse.UsableJoker|table) Called before `inject_class`. Injects and manages class information before object injection.
---@field post_inject_class? fun(self: Multiverse.UsableJoker|table) Called after `inject_class`. Injects and manages class information after object injection.
---@field inject_class? fun(self: Multiverse.UsableJoker|table) Injects all direct instances of class objects by calling `obj:inject` and `obj:process_loc_text`. Also injects anything necessary for the class itself. Only called if class has defined both `obj_table` and `obj_buffer`.
---@field inject? fun(self: Multiverse.UsableJoker|table, i?: number) Called during `inject_class`. Injects the object into the game.
---@field take_ownership? fun(self: Multiverse.UsableJoker|table, key: string, obj: Multiverse.UsableJoker|table, silent?: boolean): nil|table|Multiverse.UsableJoker Takes control of vanilla objects. Child class must have get_obj for this to function
---@field get_obj? fun(self: Multiverse.UsableJoker|table, key: string): Multiverse.UsableJoker|table? Returns an object if one matches the `key`.
---@field calc_dollar_bonus? fun(self: Multiverse.UsableJoker|table, card: Card|table): nil|number Calculates reward money.
---@field calc_scaling? fun(self: Multiverse.UsableJoker|table, card: Card|table, other_card: Card|table, scaling_value: number, scalar_value: number, args: table): table? Called by `SMODS.scale_card`. Allows detection and modification of cards when scaling values. The return may include a `scaling_value` or `scalar_value` field to modify those values or any standard calculation return.
---@field new? fun(self, name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered,blueprint_compat, eternal_compat, effect, atlas, soul_pos): any DEPRECATED. DO NOT USE
---@field can_use? fun(self: Multiverse.UsableJoker|table, card:Card|table): any
---@field use? fun(self: Multiverse.UsableJoker|table, card:Card|table)
---@field ability_atlas? string
---@field ability_pos? {x: integer, y: integer}
---@field highlight_ui? fun(self: Multiverse.UsableJoker|table, card:Card|table): UIBox Override to create a custom popup when highlighted
---@overload fun(self: Multiverse.UsableJoker): Multiverse.UsableJoker
Multiverse.UsableJoker = setmetatable({}, {
	__call = function(self)
		return self
	end,
})
