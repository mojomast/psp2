/// @description Shop Interface Panel Functions
/// Specialized functions for shop panel display and transaction management
/// Part of T029 - Shop interface panel functions

/// @function draw_shop_panel(x, y, width, height, panel_data)
/// @description Draw the shop interface panel with available items
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @param {struct} panel_data Additional panel configuration data
function draw_shop_panel(x, y, width, height, panel_data) {
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
    draw_text(x + width/2, _content_y, "SHOP");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Get shop data
    var shop_data = get_shop_panel_data();
    
    if (array_length(shop_data.items) == 0) {
        draw_text(x + 10, _content_y, "Shop is closed");
        return;
    }
    
    // Draw shop items list
    var item_height = 30;
    var spacing = 5;
    
    for (var i = 0; i < array_length(shop_data.items); i++) {
        var item = shop_data.items[i];
        var item_y = _content_y + (i * (item_height + spacing));
        
        // Skip if item would be outside panel
        if (item_y + item_height > y + height - 10) {
            break;
        }
        
        // Draw item background (highlight if selected)
        var bg_color = (item.id == shop_data.selected_item_id) ? UI_COLOR_SELECTED : UI_COLOR_SLOT_BG;
        draw_set_color(bg_color);
        draw_rectangle(x + 5, item_y, x + width - 5, item_y + item_height, false);
        
        // Draw item border
        draw_set_color(UI_COLOR_BORDER);
        draw_rectangle(x + 5, item_y, x + width - 5, item_y + item_height, true);
        
        // Draw item name
        draw_set_color(UI_COLOR_TEXT);
        draw_text(x + 10, item_y + 8, item.name);
        
        // Draw item price (right-aligned)
        draw_set_halign(fa_right);
        var price_text = ui_format_number(item.price) + "g";
        draw_text(x + width - 10, item_y + 8, price_text);
        draw_set_halign(fa_left);
        
        // Draw affordability indicator
        var can_afford = (variable_global_exists("resources") && global.resources.gold >= item.price);
        var afford_color = can_afford ? c_green : c_red;
        draw_set_color(afford_color);
        draw_circle(x + width - 25, item_y + 15, 3, false);
    }
    
    // Draw shop controls at bottom if space available
    var controls_y = y + height - 25;
    if (controls_y > _content_y + (array_length(shop_data.items) * (item_height + spacing))) {
        draw_set_color(UI_COLOR_TEXT);
        draw_set_halign(fa_center);
        draw_text(x + width/2, controls_y, "Click item to select, press B to buy");
        draw_set_halign(fa_left);
    }
}

/// @function get_shop_panel_data()
/// @description Get current shop data for display
/// @return {struct} Shop data structure
function get_shop_panel_data() {
    // Check if shop data exists in global scope
    if (variable_global_exists("shop_items")) {
        return {
            items: global.shop_items,
            selected_item_id: variable_global_exists("selected_shop_item_id") ? global.selected_shop_item_id : -1,
            is_open: variable_global_exists("shop_is_open") ? global.shop_is_open : true
        };
    }
    
    // Return default shop data if not initialized
    return {
        items: get_default_shop_items(),
        selected_item_id: -1,
        is_open: true
    };
}

/// @function get_default_shop_items()
/// @description Get default shop inventory for initialization
/// @return {array} Array of default shop items
function get_default_shop_items() {
    return [
        { id: 1, name: "Health Potion", price: 50, type: "consumable", description: "Restores 50 HP" },
        { id: 2, name: "Energy Drink", price: 30, type: "consumable", description: "Restores 25 Energy" },
        { id: 3, name: "Pet Food", price: 20, type: "pet_item", description: "Feeds your pet" },
        { id: 4, name: "Basic Pickaxe", price: 100, type: "tool", description: "Mining tool" },
        { id: 5, name: "Fishing Rod", price: 80, type: "tool", description: "Fishing tool" }
    ];
}

/// @function get_shop_panel_layout(x, y, width, height)
/// @description Calculate layout positions for shop panel elements
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @return {struct} Layout structure with positions
function get_shop_panel_layout(x, y, width, height) {
    var item_height = 30;
    var spacing = 5;
    var max_visible_items = floor((height - 70) / (item_height + spacing)); // Account for title and controls
    
    return {
        panel_x: x,
        panel_y: y,
        panel_width: width,
        panel_height: height,
        title_x: x + width/2,
        title_y: y + 15,
        content_start_y: y + 45,
        item_height: item_height,
        spacing: spacing,
        max_visible_items: max_visible_items,
        controls_y: y + height - 25
    };
}

/// @function update_shop_panel_data()
/// @description Update shop panel with latest data (called from UI controller)
/// @return {bool} True if update successful
function update_shop_panel_data() {
    try {
        // Initialize shop items if they don't exist
        if (!variable_global_exists("shop_items")) {
            global.shop_items = get_default_shop_items();
        }
        
        // Initialize selected shop item id if it doesn't exist
        if (!variable_global_exists("selected_shop_item_id")) {
            global.selected_shop_item_id = -1;
        }
        
        // Initialize shop open state if it doesn't exist
        if (!variable_global_exists("shop_is_open")) {
            global.shop_is_open = true;
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating shop panel data: " + string(error));
        return false;
    }
}

/// @function shop_panel_handle_click(x, y, mouse_x, mouse_y)
/// @description Handle mouse clicks in shop panel area for item selection
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @return {bool} True if click was handled
function shop_panel_handle_click(x, y, mouse_x, mouse_y) {
    var shop_data = get_shop_panel_data();
    
    if (array_length(shop_data.items) == 0) {
        return false;
    }
    
    var layout = get_shop_panel_layout(x, y, 300, 200); // Default size for click detection
    var content_y = layout.content_start_y;
    
    // Check each shop item for clicks
    for (var i = 0; i < array_length(shop_data.items); i++) {
        var item_y = content_y + (i * (layout.item_height + layout.spacing));
        
        // Skip if item would be outside visible area
        if (item_y + layout.item_height > y + layout.panel_height - 30) {
            break;
        }
        
        // Check if click is within this item
        if (mouse_x >= x + 5 && mouse_x <= x + layout.panel_width - 5 &&
            mouse_y >= item_y && mouse_y <= item_y + layout.item_height) {
            
            // Select this item
            global.selected_shop_item_id = shop_data.items[i].id;
            show_debug_message("Selected shop item: " + shop_data.items[i].name);
            return true;
        }
    }
    
    return false;
}

/// @function get_selected_shop_item_data()
/// @description Get data for currently selected shop item
/// @return {struct|undefined} Selected shop item data or undefined if none selected
function get_selected_shop_item_data() {
    var shop_data = get_shop_panel_data();
    
    if (shop_data.selected_item_id == -1) {
        return undefined;
    }
    
    // Find item with selected ID
    for (var i = 0; i < array_length(shop_data.items); i++) {
        if (shop_data.items[i].id == shop_data.selected_item_id) {
            return shop_data.items[i];
        }
    }
    
    return undefined;
}

/// @function shop_buy_selected_item()
/// @description Attempt to buy the currently selected shop item
/// @return {bool} True if purchase successful
function shop_buy_selected_item() {
    var item = get_selected_shop_item_data();
    
    if (item == undefined) {
        show_debug_message("No item selected for purchase");
        return false;
    }
    
    // Check if player has enough gold
    if (!variable_global_exists("resources") || global.resources.gold < item.price) {
        show_debug_message("Not enough gold to buy " + item.name);
        return false;
    }
    
    // Deduct gold
    global.resources.gold -= item.price;
    
    // Add item to inventory (simplified - assumes inventory system exists)
    if (variable_global_exists("inventory")) {
        array_push(global.inventory, {
            id: item.id,
            name: item.name,
            type: item.type,
            quantity: 1,
            rarity: "common"
        });
    }
    
    show_debug_message("Purchased " + item.name + " for " + string(item.price) + " gold");
    return true;
}
