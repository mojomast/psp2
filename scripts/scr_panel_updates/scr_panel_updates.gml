// scr_panel_updates.gml
// Panel-specific update functions

/// @function update_resource_panel_data()
/// @description Update resource panel with latest data
/// @return {bool} True if update successful
function update_resource_panel_data() {
    try {
        // Ensure resources are initialized
        if (!variable_global_exists("resources")) {
            global.resources = {
                gold: 0,
                wood: 0,
                metal: 0,
                gems: 0
            };
        }
        
        // Could add additional resource validation here
        return true;
    } catch(error) {
        show_debug_message("Error updating resource panel: " + string(error));
        return false;
    }
}

/// @function update_shop_panel_data()
/// @description Update shop panel with latest data
/// @return {bool} True if update successful
function update_shop_panel_data() {
    try {
        // Ensure shop items are initialized
        if (!variable_global_exists("shop_items")) {
            global.shop_items = [
                {
                    name: "Wooden Sword",
                    type: "weapon",
                    price: 50,
                    description: "A basic wooden sword"
                },
                {
                    name: "Iron Ore",
                    type: "resource", 
                    price: 25,
                    description: "Raw iron ore for crafting"
                },
                {
                    name: "Healing Potion",
                    type: "consumable",
                    price: 30,
                    description: "Restores pet health"
                }
            ];
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating shop panel: " + string(error));
        return false;
    }
}

/// @function update_crafting_panel_data()
/// @description Update crafting panel with latest data
/// @return {bool} True if update successful
function update_crafting_panel_data() {
    try {
        // Crafting recipes are generated dynamically by crafting_get_crafting_recipes()
        // Just ensure the crafting system is available
        if (!script_exists(crafting_get_crafting_recipes)) {
            show_debug_message("Warning: Crafting system not available");
            return false;
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating crafting panel: " + string(error));
        return false;
    }
}

/// @function update_inventory_panel_data()
/// @description Update inventory panel with latest data
/// @return {bool} True if update successful
function update_inventory_panel_data() {
    try {
        // Ensure inventory is initialized
        if (!variable_global_exists("inventory")) {
            global.inventory = [];
        }
        
        // Clean up any invalid inventory items
        var cleaned_inventory = [];
        for (var i = 0; i < array_length(global.inventory); i++) {
            var item = global.inventory[i];
            if (is_struct(item) && variable_struct_exists(item, "name")) {
                array_push(cleaned_inventory, item);
            }
        }
        global.inventory = cleaned_inventory;
        
        return true;
    } catch(error) {
        show_debug_message("Error updating inventory panel: " + string(error));
        return false;
    }
}

/// @function update_player_panel_data()
/// @description Update player panel with latest data
/// @return {bool} True if update successful
function update_player_panel_data() {
    try {
        // Ensure player data is initialized
        if (!variable_global_exists("player_name")) {
            global.player_name = "Player";
        }
        if (!variable_global_exists("player_level")) {
            global.player_level = 1;
        }
        if (!variable_global_exists("player_experience")) {
            global.player_experience = 0;
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating player panel: " + string(error));
        return false;
    }
}
