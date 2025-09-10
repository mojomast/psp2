// scr_ui_helpers.gml
// UI system helper functions

/// @function ui_initialize()
/// @description Initialize the UI system
function ui_initialize() {
    show_debug_message("Initializing UI system...");
    
    // Initialize feedback system
    if (!variable_global_exists("feedback_messages")) {
        global.feedback_messages = [];
    }
    if (!variable_global_exists("max_feedback_messages")) {
        global.max_feedback_messages = FEEDBACK_MAX_MESSAGES;
    }
    
    // Initialize selected pet tracking
    if (!variable_global_exists("selected_pet_id")) {
        global.selected_pet_id = -1;
    }
    
    show_debug_message("UI system initialized");
}

/// @function ui_is_point_in_rect(px, py, x, y, width, height)
/// @description Check if a point is within a rectangle
/// @param {real} px Point x position
/// @param {real} py Point y position
/// @param {real} x Rectangle x position
/// @param {real} y Rectangle y position
/// @param {real} width Rectangle width
/// @param {real} height Rectangle height
/// @return {bool} True if point is in rectangle
function ui_is_point_in_rect(px, py, x, y, width, height) {
    return (px >= x && px <= x + width && py >= y && py <= y + height);
}

/// @function ui_set_active_panel(panel_name)
/// @description Set the active UI panel (legacy compatibility)
/// @param {string} panel_name Name of panel to activate
function ui_set_active_panel(panel_name) {
    if (instance_exists(obj_ui_controller)) {
        with (obj_ui_controller) {
            ui_switch_panel(panel_name);
        }
    }
}

/// @function get_selected_pet_data()
/// @description Get data for the currently selected pet
/// @return {struct|undefined} Selected pet data or undefined if none selected
function get_selected_pet_data() {
    if (!variable_global_exists("selected_pet_id") || global.selected_pet_id == -1) {
        return undefined;
    }
    
    if (!variable_global_exists("pets")) {
        return undefined;
    }
    
    // Find pet with matching ID
    for (var i = 0; i < array_length(global.pets); i++) {
        var pet = global.pets[i];
        if (variable_struct_exists(pet, "id") && pet.id == global.selected_pet_id) {
            return pet;
        }
    }
    
    return undefined;
}

/// @function get_pet_action_buttons()
/// @description Get available actions for the selected pet
/// @return {array} Array of action button data
function get_pet_action_buttons() {
    var selected_pet = get_selected_pet_data();
    if (!is_struct(selected_pet)) {
        return [];
    }
    
    var actions = [];
    
    // Explore action
    array_push(actions, {
        name: "Explore",
        action: "explore",
        enabled: (selected_pet.status == "idle")
    });
    
    // Battle action
    array_push(actions, {
        name: "Battle",
        action: "battle",
        enabled: (selected_pet.status == "idle")
    });
    
    // Return action (if exploring)
    array_push(actions, {
        name: "Return",
        action: "return",
        enabled: (selected_pet.status == "exploring" || selected_pet.status == "battling")
    });
    
    return actions;
}

/// @function handle_pet_action_click(action)
/// @description Handle a pet action button click
/// @param {string} action The action to perform
function handle_pet_action_click(action) {
    var selected_pet = get_selected_pet_data();
    if (!is_struct(selected_pet)) {
        show_debug_message("No pet selected for action: " + action);
        return;
    }
    
    switch (action) {
        case "explore":
            if (selected_pet.status == "idle") {
                // Generate a random map for exploration
                var _seed = irandom(999999);
                var _size = 10 + irandom(10);
                var _difficulty = 1 + irandom(4);
                
                if (script_exists(map_generate_map)) {
                    var _map = map_generate_map(_seed, _size, _difficulty);
                    selected_pet.explore(_map);
                } else {
                    // Fallback if map generation not available
                    selected_pet.status = "exploring";
                    selected_pet.current_map = "map_" + string(_seed);
                }
                
                add_feedback_message(selected_pet.name + " started exploring!", "action");
                show_debug_message("Pet " + selected_pet.name + " started exploring");
            }
            break;
            
        case "battle":
            if (selected_pet.status == "idle") {
                selected_pet.battle();
                add_feedback_message(selected_pet.name + " entered battle!", "action");
                show_debug_message("Pet " + selected_pet.name + " started battling");
            }
            break;
            
        case "return":
            if (selected_pet.status == "exploring" || selected_pet.status == "battling") {
                selected_pet.status = "idle";
                selected_pet.current_map = "";
                add_feedback_message(selected_pet.name + " returned home", "info");
                show_debug_message("Pet " + selected_pet.name + " returned from " + selected_pet.status);
            }
            break;
            
        default:
            show_debug_message("Unknown pet action: " + action);
            break;
    }
}

/// @function update_pet_status_display()
/// @description Update the pet status display (called from Step event)
function update_pet_status_display() {
    // This function is called frequently to update pet status
    // Currently handled by the draw functions, but we'll keep this
    // for future enhancements like status effects or animations
    
    // Could add visual feedback for status changes here
    if (variable_global_exists("pets")) {
        for (var i = 0; i < array_length(global.pets); i++) {
            var pet = global.pets[i];
            
            // Ensure pet has required fields
            if (!variable_struct_exists(pet, "id")) {
                if (!variable_global_exists("next_pet_id")) {
                    global.next_pet_id = 1;
                }
                pet.id = global.next_pet_id++;
            }
        }
    }
}

/// @function format_feedback_timestamp(timestamp)
/// @description Format a timestamp for display in feedback panel
/// @param {real} timestamp The timestamp to format
/// @return {string} Formatted timestamp string
function format_feedback_timestamp(timestamp) {
    var seconds_ago = (current_time - timestamp) / 1000;
    
    if (seconds_ago < 1) {
        return "now";
    } else if (seconds_ago < 60) {
        return string(floor(seconds_ago)) + "s";
    } else if (seconds_ago < 3600) {
        return string(floor(seconds_ago / 60)) + "m";
    } else {
        return string(floor(seconds_ago / 3600)) + "h";
    }
}
