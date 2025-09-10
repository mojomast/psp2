// scr_crafting_system.gml
// Crafting system for creating items from resources

// Craft an item using a recipe
function craft_item(_recipe) {
    // Validate recipe structure
    if (!is_struct(_recipe)) return false;
    if (!struct_exists(_recipe, "requirements")) return false;
    if (!struct_exists(_recipe, "result")) return false;

    // Check if player has sufficient resources
    var _requirements = _recipe.requirements;
    if (struct_exists(_requirements, "wood") && global.resources.wood < _requirements.wood) return false;
    if (struct_exists(_requirements, "metal") && global.resources.metal < _requirements.metal) return false;
    if (struct_exists(_requirements, "gems") && global.resources.gems < _requirements.gems) return false;
    if (struct_exists(_requirements, "gold") && global.resources.gold < _requirements.gold) return false;

    // Consume resources
    if (struct_exists(_requirements, "wood")) global.resources.wood -= _requirements.wood;
    if (struct_exists(_requirements, "metal")) global.resources.metal -= _requirements.metal;
    if (struct_exists(_requirements, "gems")) global.resources.gems -= _requirements.gems;
    if (struct_exists(_requirements, "gold")) global.resources.gold -= _requirements.gold;

    // Add crafted item to inventory
    if (!variable_global_exists("inventory")) {
        global.inventory = [];
    }

    var _item = {
        name: _recipe.result,
        type: "crafted",
        quality: 1,
        durability: 100
    };

    // Add bonuses if specified in recipe
    if (struct_exists(_recipe, "bonuses")) {
        _item.bonuses = _recipe.bonuses;
    }

    // Add quality bonuses based on available resources
    if (struct_exists(_requirements, "gems")) {
        _item.quality += _requirements.gems div 5;
    }

    array_push(global.inventory, _item);

    return true;
}

// Get crafting recipes
function get_crafting_recipes() {
    return [
        {
            name: "Wooden Sword",
            requirements: {wood: 5, metal: 2},
            result: "wooden_sword"
        },
        {
            name: "Iron Sword",
            requirements: {wood: 3, metal: 8},
            result: "iron_sword"
        },
        {
            name: "Golden Sword",
            requirements: {wood: 2, metal: 5, gold: 10},
            result: "golden_sword"
        },
        {
            name: "Diamond Sword",
            requirements: {wood: 1, metal: 3, gems: 5},
            result: "diamond_sword"
        },
        {
            name: "Wooden Shield",
            requirements: {wood: 8, metal: 3},
            result: "wooden_shield"
        },
        {
            name: "Iron Shield",
            requirements: {wood: 5, metal: 10},
            result: "iron_shield"
        },
        {
            name: "Golden Shield",
            requirements: {wood: 3, metal: 7, gold: 15},
            result: "golden_shield"
        },
        {
            name: "Diamond Shield",
            requirements: {wood: 2, metal: 4, gems: 8},
            result: "diamond_shield"
        }
    ];
}

// Check if item can be crafted
function can_craft_item(_recipe) {
    if (!is_struct(_recipe)) return false;
    if (!struct_exists(_recipe, "requirements")) return false;

    var _requirements = _recipe.requirements;
    if (struct_exists(_requirements, "wood") && global.resources.wood < _requirements.wood) return false;
    if (struct_exists(_requirements, "metal") && global.resources.metal < _requirements.metal) return false;
    if (struct_exists(_requirements, "gems") && global.resources.gems < _requirements.gems) return false;
    if (struct_exists(_requirements, "gold") && global.resources.gold < _requirements.gold) return false;

    return true;
}

// Get item count in inventory
function get_inventory_count(_item_name) {
    if (!variable_global_exists("inventory")) return 0;

    var _count = 0;
    for (var i = 0; i < array_length(global.inventory); i++) {
        if (global.inventory[i].name == _item_name) {
            _count++;
        }
    }
    return _count;
}

// Find item in inventory by name
function find_item_in_inventory(_item_name) {
    if (!variable_global_exists("inventory")) return undefined;

    for (var i = 0; i < array_length(global.inventory); i++) {
        if (global.inventory[i].name == _item_name) {
            return global.inventory[i];
        }
    }
    return undefined;
}

// Bulk craft items
function bulk_craft(_recipe, _count) {
    var _success_count = 0;

    for (var i = 0; i < _count; i++) {
        if (can_craft_item(_recipe)) {
            if (craft_item(_recipe)) {
                _success_count++;
            } else {
                break; // Stop if crafting fails
            }
        } else {
            break; // Stop if requirements not met
        }
    }

    return _success_count;
}
