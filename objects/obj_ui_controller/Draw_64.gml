// obj_ui_controller Draw GUI Event
// Draw UI panels and interface elements

// Don't draw in title room
if (room == Room_Title) return;

if (!ui_visible) return;

// Set up drawing
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// Use UI main font if available, otherwise default
if (fnt_ui_main != -1) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// Draw main UI panel background
draw_set_color(color_background);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, false);

// Draw panel border
draw_set_color(color_border);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, true);

// Draw panel title
draw_set_color(color_text);
draw_set_halign(fa_center);
draw_text(panel_x + panel_width/2, panel_y + 10, "PAWN STARS IDLE");

// Draw panel tabs
draw_set_halign(fa_left);
var _tab_width = panel_width / ui_panel_count;
for (var i = 0; i < ui_panel_count; i++) {
    var _tab_x = panel_x + (i * _tab_width);
    var _tab_y = panel_y + 40;
    
    // Tab background
    if (ui_active_panel == ui_panels[i]) {
        draw_set_color(color_highlight);
    } else {
        draw_set_color(color_button_normal);
    }
    draw_rectangle(_tab_x, _tab_y, _tab_x + _tab_width, _tab_y + 25, false);
    
    // Tab border
    draw_set_color(color_border);
    draw_rectangle(_tab_x, _tab_y, _tab_x + _tab_width, _tab_y + 25, true);
    
    // Tab text
    draw_set_color(color_text);
    draw_set_halign(fa_center);
    draw_text(_tab_x + _tab_width/2, _tab_y + 5, string_upper(ui_panels[i]));
}

// Draw panel content based on active panel
draw_set_halign(fa_left);
draw_set_color(color_text);
var _content_y = panel_y + 80;

switch (ui_active_panel) {
    case "resources":
        draw_text(panel_x + 10, _content_y, "RESOURCES");
        _content_y += 30;
        
        // Display global resources if they exist
        if (variable_global_exists("resources")) {
            var _res_keys = variable_struct_get_names(global.resources);
            for (var i = 0; i < array_length(_res_keys); i++) {
                var _key = _res_keys[i];
                var _value = variable_struct_get(global.resources, _key);
                draw_text(panel_x + 10, _content_y, string_upper(_key) + ": " + string(_value));
                _content_y += 20;
            }
        } else {
            draw_text(panel_x + 10, _content_y, "Resources not initialized");
        }
        break;
        
    case "pets":
        // Use enhanced pet panel system
        if (script_exists(scr_pet_panel)) {
            draw_pet_panel(panel_x + 10, _content_y, panel_width - 20, panel_height - 100, {});
            
            // Draw action buttons for selected pet
            var selected_pet = get_selected_pet_data();
            if (is_struct(selected_pet)) {
                var actions = get_pet_action_buttons();
                var button_y = panel_y + panel_height - 80;
                var button_width = 80;
                var button_height = 20;
                var button_spacing = 5;
                
                draw_set_color(color_text);
                draw_text(panel_x + 10, button_y - 25, "Actions for " + selected_pet.name + ":");
                
                for (var i = 0; i < array_length(actions); i++) {
                    var action = actions[i];
                    var button_x = panel_x + 10 + (i * (button_width + button_spacing));
                    
                    // Draw action button
                    draw_set_color(action.enabled ? color_button_normal : color_background);
                    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
                    
                    draw_set_color(color_border);
                    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);
                    
                    draw_set_color(action.enabled ? color_text : color_border);
                    draw_set_halign(fa_center);
                    draw_text(button_x + button_width/2, button_y + 5, action.name);
                    draw_set_halign(fa_left);
                }
            }
        } else {
            draw_text(panel_x + 10, _content_y, "PETS");
            _content_y += 30;
            
            if (variable_global_exists("pets")) {
                for (var i = 0; i < array_length(global.pets); i++) {
                    var _pet = global.pets[i];
                    draw_text(panel_x + 10, _content_y, "Pet " + string(i+1) + ": " + string(_pet));
                    _content_y += 20;
                }
            } else {
                draw_text(panel_x + 10, _content_y, "Pets not initialized");
            }
        }
        break;
        
    case "shop":
        draw_text(panel_x + 10, _content_y, "SHOP");
        _content_y += 30;
        
        // Display shop items
        if (variable_global_exists("shop_items")) {
            for (var i = 0; i < array_length(global.shop_items); i++) {
                var _item = global.shop_items[i];
                draw_text(panel_x + 10, _content_y, string(i+1) + ". " + _item.name);
                _content_y += 15;
                draw_text(panel_x + 20, _content_y, "Price: " + string(_item.price) + " gold");
                _content_y += 15;
                draw_text(panel_x + 20, _content_y, _item.description);
                _content_y += 25;
            }
        } else {
            draw_text(panel_x + 10, _content_y, "Shop items not available");
        }
        
        // Display player gold
        if (variable_global_exists("resources")) {
            draw_text(panel_x + 10, _content_y, "Your Gold: " + string(global.resources.gold));
        }
        break;
        
    case "crafting":
        draw_text(panel_x + 10, _content_y, "CRAFTING");
        _content_y += 30;
        
        // Display crafting recipes
        if (script_exists(crafting_get_crafting_recipes)) {
            var _recipes = crafting_get_crafting_recipes();
            for (var i = 0; i < array_length(_recipes); i++) {
                var _recipe = _recipes[i];
                draw_text(panel_x + 10, _content_y, string(i+1) + ". " + _recipe.name);
                _content_y += 15;
                
                // Display requirements
                var _req_text = "Requires: ";
                var _requirements = _recipe.requirements;
                var _req_keys = struct_get_names(_requirements);
                for (var j = 0; j < array_length(_req_keys); j++) {
                    var _key = _req_keys[j];
                    var _value = struct_get(_requirements, _key);
                    _req_text += string(_value) + " " + _key;
                    if (j < array_length(_req_keys) - 1) {
                        _req_text += ", ";
                    }
                }
                draw_text(panel_x + 20, _content_y, _req_text);
                _content_y += 15;
                
                // Display result
                draw_text(panel_x + 20, _content_y, "Makes: " + _recipe.result);
                _content_y += 25;
            }
        } else {
            draw_text(panel_x + 10, _content_y, "Crafting system not available");
        }
        break;
        
    case "inventory":
        draw_text(panel_x + 10, _content_y, "INVENTORY");
        _content_y += 30;
        
        if (variable_global_exists("inventory")) {
            for (var i = 0; i < array_length(global.inventory); i++) {
                var _item = global.inventory[i];
                draw_text(panel_x + 10, _content_y, "Item " + string(i+1) + ": " + string(_item));
                _content_y += 20;
            }
        } else {
            draw_text(panel_x + 10, _content_y, "Inventory not initialized");
        }
        break;
}

// Draw buttons
for (var i = 0; i < array_length(buttons); i++) {
    var _btn = buttons[i];
    
    // Button background
    if (button_hover == i) {
        draw_set_color(color_button_hover);
    } else {
        draw_set_color(color_button_normal);
    }
    draw_rectangle(_btn.x, _btn.y, _btn.x + _btn.width, _btn.y + _btn.height, false);
    
    // Button border
    draw_set_color(color_border);
    draw_rectangle(_btn.x, _btn.y, _btn.x + _btn.width, _btn.y + _btn.height, true);
    
    // Button text
    draw_set_color(color_text);
    draw_set_halign(fa_center);
    draw_text(_btn.x + _btn.width/2, _btn.y + _btn.height/2 - 8, _btn.text);
}

// Draw hover visual effects (T043)
ui_draw_hover_effects();

// Reset drawing settings
draw_set_halign(fa_left);
draw_set_color(c_white);
