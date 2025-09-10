/// @description Inventory Panel Functions
/// Specialized functions for inventory panel display and item management
/// Part of T028 - Inventory panel functions

/// @function draw_inventory_panel(x, y, width, height, panel_data)
/// @description Draw the inventory panel with current item data
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @param {struct} panel_data Additional panel configuration data
function draw_inventory_panel(x, y, width, height, panel_data) {
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
    draw_text(x + width/2, _content_y, "INVENTORY");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Get inventory data
    var inventory_data = get_inventory_panel_data();
    
    if (array_length(inventory_data.items) == 0) {
        draw_text(x + 10, _content_y, "Inventory is empty");
        return;
    }
    
    // Draw inventory grid
    var slot_size = 40;
    var spacing = 5;
    var slots_per_row = floor((width - 20) / (slot_size + spacing));
    
    for (var i = 0; i < array_length(inventory_data.items); i++) {
        var item = inventory_data.items[i];
        var row = floor(i / slots_per_row);
        var col = i % slots_per_row;
        
        var slot_x = x + 10 + (col * (slot_size + spacing));
        var slot_y = _content_y + (row * (slot_size + spacing + 15)); // Extra space for quantity text
        
        // Draw item slot background
        draw_set_color(UI_COLOR_SLOT_BG);
        draw_rectangle(slot_x, slot_y, slot_x + slot_size, slot_y + slot_size, false);
        
        // Draw slot border
        draw_set_color(UI_COLOR_BORDER);
        draw_rectangle(slot_x, slot_y, slot_x + slot_size, slot_y + slot_size, true);
        
        // Draw item name (abbreviated if needed)
        draw_set_color(UI_COLOR_TEXT);
        draw_set_halign(fa_center);
        var display_name = string_copy(item.name, 1, 6); // First 6 characters
        draw_text(slot_x + slot_size/2, slot_y + slot_size/2 - 6, display_name);
        
        // Draw item quantity
        if (item.quantity > 1) {
            draw_text(slot_x + slot_size/2, slot_y + slot_size/2 + 6, "x" + string(item.quantity));
        }
        
        // Draw item rarity indicator (small colored dot)
        var rarity_color = get_item_rarity_color(item.rarity);
        draw_set_color(rarity_color);
        draw_circle(slot_x + slot_size - 8, slot_y + 8, 3, false);
    }
    
    draw_set_halign(fa_left);
}

/// @function get_inventory_panel_data()
/// @description Get current inventory data for display
/// @return {struct} Inventory data structure
function get_inventory_panel_data() {
    // Check if inventory data exists in global scope
    if (variable_global_exists("inventory")) {
        return {
            items: global.inventory,
            selected_item_id: variable_global_exists("selected_item_id") ? global.selected_item_id : -1,
            max_slots: variable_global_exists("inventory_max_slots") ? global.inventory_max_slots : 20
        };
    }
    
    // Return default inventory data if not initialized
    return {
        items: [],
        selected_item_id: -1,
        max_slots: 20
    };
}

/// @function get_inventory_panel_layout(x, y, width, height)
/// @description Calculate layout positions for inventory panel elements
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @return {struct} Layout structure with positions
function get_inventory_panel_layout(x, y, width, height) {
    var slot_size = 40;
    var spacing = 5;
    var slots_per_row = floor((width - 20) / (slot_size + spacing));
    
    return {
        panel_x: x,
        panel_y: y,
        panel_width: width,
        panel_height: height,
        title_x: x + width/2,
        title_y: y + 15,
        content_start_y: y + 45,
        slot_size: slot_size,
        spacing: spacing,
        slots_per_row: slots_per_row,
        item_slots: []
    };
}

/// @function update_inventory_panel_data()
/// @description Update inventory panel with latest data (called from UI controller)
/// @return {bool} True if update successful
function update_inventory_panel_data() {
    try {
        // Initialize inventory array if it doesn't exist
        if (!variable_global_exists("inventory")) {
            global.inventory = [];
        }
        
        // Initialize selected item id if it doesn't exist
        if (!variable_global_exists("selected_item_id")) {
            global.selected_item_id = -1;
        }
        
        // Initialize max slots if it doesn't exist
        if (!variable_global_exists("inventory_max_slots")) {
            global.inventory_max_slots = 20;
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating inventory panel data: " + string(error));
        return false;
    }
}

/// @function inventory_panel_handle_click(x, y, mouse_x, mouse_y)
/// @description Handle mouse clicks in inventory panel area for item selection
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @return {bool} True if click was handled
function inventory_panel_handle_click(x, y, mouse_x, mouse_y) {
    var inventory_data = get_inventory_panel_data();
    
    if (array_length(inventory_data.items) == 0) {
        return false;
    }
    
    var layout = get_inventory_panel_layout(x, y, 300, 200); // Default size for click detection
    var content_y = layout.content_start_y;
    
    // Check each inventory slot for clicks
    for (var i = 0; i < array_length(inventory_data.items); i++) {
        var row = floor(i / layout.slots_per_row);
        var col = i % layout.slots_per_row;
        
        var slot_x = x + 10 + (col * (layout.slot_size + layout.spacing));
        var slot_y = content_y + (row * (layout.slot_size + layout.spacing + 15));
        
        // Check if click is within this inventory slot
        if (mouse_x >= slot_x && mouse_x <= slot_x + layout.slot_size &&
            mouse_y >= slot_y && mouse_y <= slot_y + layout.slot_size) {
            
            // Select this item
            global.selected_item_id = inventory_data.items[i].id;
            show_debug_message("Selected item: " + inventory_data.items[i].name);
            return true;
        }
    }
    
    return false;
}

/// @function get_selected_item_data()
/// @description Get data for currently selected inventory item
/// @return {struct|undefined} Selected item data or undefined if none selected
function get_selected_item_data() {
    var inventory_data = get_inventory_panel_data();
    
    if (inventory_data.selected_item_id == -1) {
        return undefined;
    }
    
    // Find item with selected ID
    for (var i = 0; i < array_length(inventory_data.items); i++) {
        if (inventory_data.items[i].id == inventory_data.selected_item_id) {
            return inventory_data.items[i];
        }
    }
    
    return undefined;
}

/// @function get_item_rarity_color(rarity)
/// @description Get color for item rarity display
/// @param {string} rarity Item rarity level
/// @return {constant} Color constant for the rarity
function get_item_rarity_color(rarity) {
    switch(rarity) {
        case "common": return c_white;
        case "uncommon": return c_green;
        case "rare": return c_blue;
        case "epic": return c_purple;
        case "legendary": return c_orange;
        default: return c_gray;
    }
}

/// Note: find_item_in_inventory function is defined in scr_crafting_system

