/// @description Pet Management Panel Functions
/// Specialized functions for pet panel display and interaction management
/// Part of T027 - Pet management panel functions

/// @function draw_pet_panel(x, y, width, height, panel_data)
/// @description Draw the pet management panel with current pet data
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @param {struct} panel_data Additional panel configuration data
function draw_pet_panel(x, y, width, height, panel_data) {
    // Draw panel background
    draw_set_color(UI_COLOR_PANEL_BG);
    draw_rectangle(x, y, x + width, y + height, false);
    
    // Draw panel border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x, y, x + width, y + height, true);
    
    var _content_y = y + 10;
    
    // Panel title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_text(x + width/2, _content_y, "PETS");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Get pet data
    var pet_data = get_pet_panel_data();
    
    if (array_length(pet_data.pets) == 0) {
        draw_text(x + 10, _content_y, "No pets available");
        return;
    }
    
    // Draw pets list
    var pets_per_row = floor(width / 80);
    var pet_size = 60;
    var spacing = 10;
    
    for (var i = 0; i < array_length(pet_data.pets); i++) {
        var pet = pet_data.pets[i];
        
        // Safety check: ensure pet has an id field
        if (!struct_exists(pet, "id")) {
            // Assign missing ID to legacy pets
            if (!variable_global_exists("next_pet_id")) {
                global.next_pet_id = 1;
            }
            pet.id = global.next_pet_id++;
        }
        
        var row = floor(i / pets_per_row);
        var col = i % pets_per_row;
        
        var pet_x = x + spacing + (col * (pet_size + spacing));
        var pet_y = _content_y + (row * (pet_size + spacing * 2));
        
        // Draw pet slot background
        var slot_color = (pet.id == pet_data.selected_pet_id) ? UI_COLOR_SELECTED : UI_COLOR_SLOT_BG;
        draw_set_color(slot_color);
        draw_rectangle(pet_x, pet_y, pet_x + pet_size, pet_y + pet_size, false);
        
        // Draw pet slot border
        draw_set_color(UI_COLOR_BORDER);
        draw_rectangle(pet_x, pet_y, pet_x + pet_size, pet_y + pet_size, true);
        
        // Draw pet name (centered under slot)
        draw_set_color(UI_COLOR_TEXT);
        draw_set_halign(fa_center);
        draw_text(pet_x + pet_size/2, pet_y + pet_size + 5, pet.name);
        
        // Draw pet level
        draw_text(pet_x + pet_size/2, pet_y + pet_size + 20, "Lv." + string(pet.level));
        
        // Draw pet type/icon placeholder
        draw_set_halign(fa_center);
        draw_text(pet_x + pet_size/2, pet_y + pet_size/2 - 8, pet.type);
    }
    
    draw_set_halign(fa_left);
}

/// @function get_pet_panel_data()
/// @description Get current pet data for display
/// @return {struct} Pet data structure
function get_pet_panel_data() {
    // Check if pets data exists in global scope
    if (variable_global_exists("pets")) {
        return {
            pets: global.pets,
            selected_pet_id: variable_global_exists("selected_pet_id") ? global.selected_pet_id : -1
        };
    }
    
    // Return default pet data if not initialized
    return {
        pets: [],
        selected_pet_id: -1
    };
}

/// @function get_pet_panel_layout(x, y, width, height)
/// @description Calculate layout positions for pet panel elements
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @return {struct} Layout structure with positions
function get_pet_panel_layout(x, y, width, height) {
    var pet_size = 60;
    var spacing = 10;
    var pets_per_row = floor(width / (pet_size + spacing));
    
    return {
        panel_x: x,
        panel_y: y,
        panel_width: width,
        panel_height: height,
        title_x: x + width/2,
        title_y: y + 15,
        content_start_y: y + 45,
        pet_size: pet_size,
        spacing: spacing,
        pets_per_row: pets_per_row,
        pet_slots: []
    };
}

/// @function update_pet_panel_data()
/// @description Update pet panel with latest data (called from UI controller)
/// @return {bool} True if update successful
function update_pet_panel_data() {
    try {
        // Initialize pets array if it doesn't exist
        if (!variable_global_exists("pets")) {
            global.pets = [];
        }
        
        // Initialize selected pet id if it doesn't exist
        if (!variable_global_exists("selected_pet_id")) {
            global.selected_pet_id = -1;
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating pet panel data: " + string(error));
        return false;
    }
}

/// @function pet_panel_handle_click(x, y, mouse_x, mouse_y)
/// @description Handle mouse clicks in pet panel area for pet selection
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @return {bool} True if click was handled
function pet_panel_handle_click(x, y, mouse_x, mouse_y) {
    var pet_data = get_pet_panel_data();
    
    if (array_length(pet_data.pets) == 0) {
        return false;
    }
    
    var layout = get_pet_panel_layout(x, y, 300, 200); // Default size for click detection
    var content_y = layout.content_start_y;
    
    // Check each pet slot for clicks
    for (var i = 0; i < array_length(pet_data.pets); i++) {
        var row = floor(i / layout.pets_per_row);
        var col = i % layout.pets_per_row;
        
        var pet_x = x + layout.spacing + (col * (layout.pet_size + layout.spacing));
        var pet_y = content_y + (row * (layout.pet_size + layout.spacing * 2));
        
        // Check if click is within this pet slot
        if (mouse_x >= pet_x && mouse_x <= pet_x + layout.pet_size &&
            mouse_y >= pet_y && mouse_y <= pet_y + layout.pet_size) {
            
            var pet = pet_data.pets[i];
            
            // Safety check: ensure pet has an id field
            if (!struct_exists(pet, "id")) {
                // Assign missing ID to legacy pets
                if (!variable_global_exists("next_pet_id")) {
                    global.next_pet_id = 1;
                }
                pet.id = global.next_pet_id++;
            }
            
            // Select this pet
            global.selected_pet_id = pet.id;
            show_debug_message("Selected pet: " + pet.name);
            return true;
        }
    }
    
    return false;
}

/// @function get_selected_pet_data()
/// @description Get data for currently selected pet
/// @return {struct|undefined} Selected pet data or undefined if none selected
function get_selected_pet_data() {
    var pet_data = get_pet_panel_data();
    
    if (pet_data.selected_pet_id == -1) {
        return undefined;
    }
    
    // Find pet with selected ID
    for (var i = 0; i < array_length(pet_data.pets); i++) {
        var pet = pet_data.pets[i];
        
        // Safety check: ensure pet has an id field
        if (!struct_exists(pet, "id")) {
            // Assign missing ID to legacy pets
            if (!variable_global_exists("next_pet_id")) {
                global.next_pet_id = 1;
            }
            pet.id = global.next_pet_id++;
        }
        
        if (pet.id == pet_data.selected_pet_id) {
            return pet;
        }
    }
    
    return undefined;
}

/// @function get_pet_action_buttons()
/// @description Get available action buttons for the selected pet
/// @return {array} Array of button structures
function get_pet_action_buttons() {
    var selected_pet = get_selected_pet_data();
    
    if (!is_struct(selected_pet)) {
        return [];
    }
    
    // Return available actions based on pet status
    var actions = [];
    
    // Always available actions
    array_push(actions, {
        name: "View Stats",
        action: "view_stats",
        enabled: true
    });
    
    array_push(actions, {
        name: "Rename",
        action: "rename",
        enabled: true
    });
    
    // Status-dependent actions
    if (selected_pet.status == "active") {
        array_push(actions, {
            name: "Send to Explore",
            action: "explore", 
            enabled: true
        });
        
        array_push(actions, {
            name: "Rest",
            action: "rest",
            enabled: true
        });
    } else if (selected_pet.status == "exploring") {
        array_push(actions, {
            name: "Recall",
            action: "recall",
            enabled: true
        });
    } else if (selected_pet.status == "resting") {
        array_push(actions, {
            name: "Activate",
            action: "activate",
            enabled: true
        });
    }
    
    return actions;
}

/// @function handle_pet_action_click(action)
/// @description Handle pet action button clicks
/// @param {string} action Action name to execute
/// @return {bool} True if action was handled successfully
function handle_pet_action_click(action) {
    var selected_pet = get_selected_pet_data();
    
    if (!is_struct(selected_pet)) {
        show_debug_message("No pet selected for action: " + action);
        return false;
    }
    
    show_debug_message("Executing pet action: " + action + " for pet: " + selected_pet.name);
    
    switch(action) {
        case "view_stats":
            show_debug_message("Viewing stats for " + selected_pet.name + " (Level " + string(selected_pet.level) + ")");
            break;
            
        case "rename":
            show_debug_message("Rename functionality would open input dialog");
            break;
            
        case "explore":
            if (selected_pet.status == "active") {
                // Update pet status to exploring
                for (var i = 0; i < array_length(global.pets); i++) {
                    if (global.pets[i].id == selected_pet.id) {
                        global.pets[i].status = "exploring";
                        show_debug_message(selected_pet.name + " is now exploring!");
                        break;
                    }
                }
            }
            break;
            
        case "rest":
            if (selected_pet.status == "active") {
                // Update pet status to resting
                for (var i = 0; i < array_length(global.pets); i++) {
                    if (global.pets[i].id == selected_pet.id) {
                        global.pets[i].status = "resting";
                        show_debug_message(selected_pet.name + " is now resting!");
                        break;
                    }
                }
            }
            break;
            
        case "recall":
            if (selected_pet.status == "exploring") {
                // Update pet status back to active
                for (var i = 0; i < array_length(global.pets); i++) {
                    if (global.pets[i].id == selected_pet.id) {
                        global.pets[i].status = "active";
                        show_debug_message(selected_pet.name + " has been recalled!");
                        break;
                    }
                }
            }
            break;
            
        case "activate":
            if (selected_pet.status == "resting") {
                // Update pet status back to active
                for (var i = 0; i < array_length(global.pets); i++) {
                    if (global.pets[i].id == selected_pet.id) {
                        global.pets[i].status = "active";
                        show_debug_message(selected_pet.name + " is now active!");
                        break;
                    }
                }
            }
            break;
            
        default:
            show_debug_message("Unknown pet action: " + action);
            return false;
    }
    
    return true;
}

/// @function update_pet_status_display()
/// @description Update pet status display for real-time changes
/// @return {bool} True if update successful
function update_pet_status_display() {
    try {
        // This function would be called regularly to update pet status displays
        // For now, just validate that pets exist and have valid status
        if (!variable_global_exists("pets")) {
            return false;
        }
        
        var updated_count = 0;
        for (var i = 0; i < array_length(global.pets); i++) {
            var pet = global.pets[i];
            
            // Validate pet has required fields
            if (is_struct(pet) && 
                struct_exists(pet, "status") && 
                struct_exists(pet, "name") && 
                struct_exists(pet, "level")) {
                updated_count++;
            }
        }
        
        return (updated_count > 0);
    } catch(error) {
        show_debug_message("Error updating pet status display: " + string(error));
        return false;
    }
}
