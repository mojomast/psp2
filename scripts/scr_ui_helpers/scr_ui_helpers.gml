// scr_ui_helpers.gml
// UI system helper functions

/// @function ui_get_all_panels()
/// @description Get array of all available UI panels
/// @return {array} Array of panel names
function ui_get_all_panels() {
    return [
        UI_PANEL_RESOURCES,
        UI_PANEL_PETS,
        UI_PANEL_SHOP,
        UI_PANEL_CRAFTING,
        UI_PANEL_INVENTORY
    ];
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

/// @function ui_switch_panel(panel_name)
/// @description Switch to a different UI panel with validation
/// @param {string} panel_name Name of panel to switch to
function ui_switch_panel(panel_name) {
    var _valid_panels = ui_get_all_panels();
    
    // Check if panel is valid
    for (var i = 0; i < array_length(_valid_panels); i++) {
        if (_valid_panels[i] == panel_name) {
            if (instance_exists(obj_ui_controller)) {
                with (obj_ui_controller) {
                    ui_previous_panel = ui_active_panel;
                    ui_active_panel = panel_name;
                    show_debug_message("Switched to panel: " + panel_name);
                    
                    // Add feedback message
                    add_feedback_message("Switched to " + string_upper(panel_name) + " panel", "info");
                }
            }
            return true;
        }
    }
    
    show_debug_message("Invalid panel name: " + panel_name);
    return false;
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

/// @function ui_draw_button(x, y, width, height, text, is_hovered, is_pressed, is_active)
/// @description Draw a modern button with hover and press effects
/// @param {real} x Button x position
/// @param {real} y Button y position
/// @param {real} width Button width
/// @param {real} height Button height
/// @param {string} text Button text
/// @param {bool} is_hovered Whether button is hovered
/// @param {bool} is_pressed Whether button is pressed
/// @param {bool} is_active Whether button is active/selected
function ui_draw_button(x, y, width, height, text, is_hovered, is_pressed, is_active) {
    // Determine button color based on state
    var button_color;
    if (is_pressed) {
        button_color = UI_COLOR_BUTTON_PRESSED;
    } else if (is_active) {
        button_color = UI_COLOR_BUTTON_ACTIVE;
    } else if (is_hovered) {
        button_color = UI_COLOR_BUTTON_HOVER;
    } else {
        button_color = UI_COLOR_BUTTON_NORMAL;
    }
    
    // Draw button background with rounded corners effect (using rectangles)
    draw_set_color(button_color);
    draw_rectangle(x, y, x + width, y + height, false);
    
    // Add highlight effect for hovered buttons
    if (is_hovered) {
        draw_set_color(UI_COLOR_HIGHLIGHT);
        draw_set_alpha(0.3);
        draw_rectangle(x, y, x + width, y + 2, false);
        draw_set_alpha(1.0);
    }
    
    // Draw button border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x, y, x + width, y + height, true);
    
    // Draw button text with shadow for better readability
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x + width/2 + 1, y + height/2 + 1, text);
    draw_set_alpha(1.0);
    
    draw_set_color(UI_COLOR_TEXT);
    draw_text(x + width/2, y + height/2, text);
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @function ui_draw_panel(x, y, width, height, title, content_color)
/// @description Draw a modern panel with header
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @param {string} title Panel title
/// @param {real} content_color Background color for content area
function ui_draw_panel(x, y, width, height, title, content_color) {
    // Draw panel background
    draw_set_color(UI_COLOR_PANEL_BG);
    draw_rectangle(x, y, x + width, y + height, false);
    
    // Draw header background
    draw_set_color(UI_COLOR_PANEL_HEADER);
    draw_rectangle(x, y, x + width, y + UI_TAB_HEIGHT, false);
    
    // Draw panel border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x, y, x + width, y + height, true);
    
    // Draw title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x + width/2, y + UI_TAB_HEIGHT/2, title);
    
    // Draw content area background
    draw_set_color(content_color);
    draw_rectangle(x + 1, y + UI_TAB_HEIGHT + 1, x + width - 1, y + height - 1, false);
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @function ui_draw_tab(x, y, width, height, text, is_active, is_hovered)
/// @description Draw a tab button
/// @param {real} x Tab x position
/// @param {real} y Tab y position
/// @param {real} width Tab width
/// @param {real} height Tab height
/// @param {string} text Tab text
/// @param {bool} is_active Whether tab is active
/// @param {bool} is_hovered Whether tab is hovered
function ui_draw_tab(x, y, width, height, text, is_active, is_hovered) {
    // Determine tab color
    var tab_color;
    if (is_active) {
        tab_color = UI_COLOR_HIGHLIGHT;
    } else if (is_hovered) {
        tab_color = UI_COLOR_BUTTON_HOVER;
    } else {
        tab_color = UI_COLOR_BUTTON_NORMAL;
    }
    
    // Draw tab background
    draw_set_color(tab_color);
    draw_rectangle(x, y, x + width, y + height, false);
    
    // Draw tab border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x, y, x + width, y + height, true);
    
    // Draw tab text
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x + width/2, y + height/2, text);
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @function ui_create_button(x, y, width, height, text, callback)
/// @description Create a button data structure
/// @param {real} x Button x position
/// @param {real} y Button y position
/// @param {real} width Button width
/// @param {real} height Button height
/// @param {string} text Button text
/// @param {function} callback Function to call when clicked
/// @return {struct} Button data structure
function ui_create_button(x, y, width, height, text, callback) {
    return {
        x: x,
        y: y,
        width: width,
        height: height,
        text: text,
        callback: callback,
        hovered: false,
        pressed: false,
        active: false
    };
}

/// @function ui_update_button_hover(button, mouse_x, mouse_y)
/// @description Update button hover state
/// @param {struct} button Button data structure
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @return {bool} True if button state changed
function ui_update_button_hover(button, mouse_x, mouse_y) {
    var was_hovered = button.hovered;
    button.hovered = ui_is_point_in_rect(mouse_x, mouse_y, button.x, button.y, button.width, button.height);
    return (was_hovered != button.hovered);
}

/// @function ui_switch_panel(panel_name)
/// @description Switch to a specific UI panel
/// @param {string} panel_name Name of panel to switch to
function ui_switch_panel(panel_name) {
    if (instance_exists(obj_ui_controller)) {
        with (obj_ui_controller) {
            var _panels = ui_get_all_panels();
            for (var i = 0; i < array_length(_panels); i++) {
                if (_panels[i] == panel_name) {
                    ui_active_panel = panel_name;
                    show_debug_message("Switched to panel: " + panel_name);
                    break;
                }
            }
        }
    }
}

/// @function ui_switch_to_next_panel()
/// @description Switch to the next panel in the list
function ui_switch_to_next_panel() {
    if (instance_exists(obj_ui_controller)) {
        with (obj_ui_controller) {
            var _panels = ui_get_all_panels();
            var _current_index = -1;
            
            for (var i = 0; i < array_length(_panels); i++) {
                if (_panels[i] == ui_active_panel) {
                    _current_index = i;
                    break;
                }
            }
            
            if (_current_index != -1) {
                var _next_index = (_current_index + 1) % array_length(_panels);
                ui_active_panel = _panels[_next_index];
                show_debug_message("Switched to next panel: " + ui_active_panel);
            }
        }
    }
}

/// @function ui_switch_to_previous_panel()
/// @description Switch to the previous panel in the list
function ui_switch_to_previous_panel() {
    if (instance_exists(obj_ui_controller)) {
        with (obj_ui_controller) {
            var _panels = ui_get_all_panels();
            var _current_index = -1;
            
            for (var i = 0; i < array_length(_panels); i++) {
                if (_panels[i] == ui_active_panel) {
                    _current_index = i;
                    break;
                }
            }
            
            if (_current_index != -1) {
                var _prev_index = (_current_index - 1 + array_length(_panels)) % array_length(_panels);
                ui_active_panel = _panels[_prev_index];
                show_debug_message("Switched to previous panel: " + ui_active_panel);
            }
        }
    }
}

/// @function ui_update_hover_effects()
/// @description Update hover effects for UI elements
function ui_update_hover_effects() {
    // This function can be expanded to handle various hover effects
    // Currently handled in the Step event
}
