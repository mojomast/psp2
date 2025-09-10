// scr_ui_panels.gml
// Base functions for UI panels and panel management

/// @function ui_panel_draw_resources(x, y, width, height)
// @description Draw the resources panel
// @param {real} x Panel x position
// @param {real} y Panel y position
// @param {real} width Panel width
// @param {real} height Panel height
function ui_panel_draw_resources(x, y, width, height) {
    var _content_y = y + 10;
    
    // Panel title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_text(x + width/2, _content_y, "RESOURCES");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Display global resources if they exist
    if (variable_global_exists("resources")) {
        var _res_keys = variable_struct_get_names(global.resources);
        for (var i = 0; i < array_length(_res_keys); i++) {
            var _key = _res_keys[i];
            var _value = variable_struct_get(global.resources, _key);
            
            // Resource name
            draw_text(x + 10, _content_y, string_upper(_key) + ":");
            
            // Resource value (right-aligned)
            draw_set_halign(fa_right);
            draw_text(x + width - 10, _content_y, ui_format_number(_value));
            draw_set_halign(fa_left);
            
            _content_y += 20;
        }
    } else {
        draw_text(x + 10, _content_y, "Resources not initialized");
    }
}

/// @function ui_panel_draw_pets(x, y, width, height)
// @description Draw the pets panel
// @param {real} x Panel x position
// @param {real} y Panel y position
// @param {real} width Panel width
// @param {real} height Panel height
function ui_panel_draw_pets(x, y, width, height) {
    var _content_y = y + 10;
    
    // Panel title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_text(x + width/2, _content_y, "PETS");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Display pets if they exist
    if (variable_global_exists("pets")) {
        for (var i = 0; i < array_length(global.pets); i++) {
            var _pet = global.pets[i];
            
            // Pet info
            draw_text(x + 10, _content_y, "Pet " + string(i+1) + ":");
            _content_y += 15;
            
            if (is_struct(_pet)) {
                // Display pet properties
                var _pet_keys = variable_struct_get_names(_pet);
                for (var j = 0; j < array_length(_pet_keys); j++) {
                    var _key = _pet_keys[j];
                    var _value = variable_struct_get(_pet, _key);
                    draw_text(x + 20, _content_y, string_upper(_key) + ": " + string(_value));
                    _content_y += 15;
                }
            } else {
                draw_text(x + 20, _content_y, string(_pet));
                _content_y += 15;
            }
            
            _content_y += 5; // Extra spacing between pets
        }
    } else {
        draw_text(x + 10, _content_y, "Pets not initialized");
    }
}

/// @function ui_panel_draw_shop(x, y, width, height)
// @description Draw the shop panel
// @param {real} x Panel x position
// @param {real} y Panel y position
// @param {real} width Panel width
// @param {real} height Panel height
function ui_panel_draw_shop(x, y, width, height) {
    var _content_y = y + 10;
    
    // Panel title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_text(x + width/2, _content_y, "SHOP");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Shop items would be displayed here
    draw_text(x + 10, _content_y, "Shop system coming soon...");
    _content_y += 20;
    draw_text(x + 10, _content_y, "Buy upgrades and items here!");
}

/// @function ui_panel_draw_crafting(x, y, width, height)
// @description Draw the crafting panel
// @param {real} x Panel x position
// @param {real} y Panel y position
// @param {real} width Panel width
// @param {real} height Panel height
function ui_panel_draw_crafting(x, y, width, height) {
    var _content_y = y + 10;
    
    // Panel title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_text(x + width/2, _content_y, "CRAFTING");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Crafting recipes would be displayed here
    draw_text(x + 10, _content_y, "Crafting system coming soon...");
    _content_y += 20;
    draw_text(x + 10, _content_y, "Combine items to create new ones!");
}

/// @function ui_panel_draw_inventory(x, y, width, height)
// @description Draw the inventory panel
// @param {real} x Panel x position
// @param {real} y Panel y position
// @param {real} width Panel width
// @param {real} height Panel height
function ui_panel_draw_inventory(x, y, width, height) {
    var _content_y = y + 10;
    
    // Panel title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_text(x + width/2, _content_y, "INVENTORY");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Display inventory if it exists
    if (variable_global_exists("inventory")) {
        for (var i = 0; i < array_length(global.inventory); i++) {
            var _item = global.inventory[i];
            
            // Item info
            draw_text(x + 10, _content_y, "Item " + string(i+1) + ":");
            _content_y += 15;
            
            if (is_struct(_item)) {
                // Display item properties
                var _item_keys = variable_struct_get_names(_item);
                for (var j = 0; j < array_length(_item_keys); j++) {
                    var _key = _item_keys[j];
                    var _value = variable_struct_get(_item, _key);
                    draw_text(x + 20, _content_y, string_upper(_key) + ": " + string(_value));
                    _content_y += 15;
                }
            } else {
                draw_text(x + 20, _content_y, string(_item));
                _content_y += 15;
            }
            
            _content_y += 5; // Extra spacing between items
        }
    } else {
        draw_text(x + 10, _content_y, "Inventory not initialized");
    }
}

/// @function ui_panel_draw_panel(panel_name, x, y, width, height)
// @description Draw a specific panel by name
// @param {string} panel_name The name of the panel to draw
// @param {real} x Panel x position
// @param {real} y Panel y position
// @param {real} width Panel width
// @param {real} height Panel height
function ui_panel_draw_panel(panel_name, x, y, width, height) {
    switch (panel_name) {
        case "resources":
            ui_panel_draw_resources(x, y, width, height);
            break;
        case "pets":
            ui_panel_draw_pets(x, y, width, height);
            break;
        case "shop":
            ui_panel_draw_shop(x, y, width, height);
            break;
        case "crafting":
            ui_panel_draw_crafting(x, y, width, height);
            break;
        case "inventory":
            ui_panel_draw_inventory(x, y, width, height);
            break;
        default:
            draw_set_color(UI_COLOR_TEXT);
            draw_text(x + 10, y + 10, "Unknown panel: " + panel_name);
            break;
    }
}
