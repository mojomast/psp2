// Draw main background with subtle pattern
draw_set_color(make_color_rgb(15, 15, 15));
draw_rectangle(0, 0, screen_width, screen_height, false);

// Debug: Show that UI is being drawn
show_debug_message("UI Controller Draw GUI - Frame: " + string(current_time));

// Add subtle grid pattern for visual interest
draw_set_color(make_color_rgb(20, 20, 20));
draw_set_alpha(0.1);
for (var i = 0; i < screen_width; i += 50) {
    draw_line(i, 0, i, screen_height);
}
for (var i = 0; i < screen_height; i += 50) {
    draw_line(0, i, screen_width, i);
}
draw_set_alpha(1.0);

// Fallback: If UI fails to draw properly, show basic info
draw_set_color(c_white);
draw_text(10, 10, "NEW UI SYSTEM ACTIVE");
draw_text(10, 30, "Press Tab to toggle UI modes");
draw_text(10, 50, "Mouse controls enabled");

// Set up drawing
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// Use UI main font if available, otherwise default
if (fnt_ui_main != -1) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// Draw header bar with gradient effect
draw_set_color(color_panel_header);
draw_rectangle(0, 0, screen_width, UI_HEADER_HEIGHT, false);

// Add subtle gradient line at bottom of header
draw_set_color(color_accent);
draw_rectangle(0, UI_HEADER_HEIGHT - 2, screen_width, UI_HEADER_HEIGHT, false);

// Draw game title with shadow effect
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_text(screen_width/2 + 1, UI_HEADER_HEIGHT/2 + 1, "PAWN STARS IDLE");
draw_set_color(color_text);
draw_text(screen_width/2, UI_HEADER_HEIGHT/2, "PAWN STARS IDLE");
draw_set_halign(fa_left);

// Draw left panel (Main Content)
ui_draw_panel(left_panel_x, left_panel_y, left_panel_width, left_panel_height,
              string_upper(ui_active_panel), color_background);

// Draw right panel (Actions/Info)
ui_draw_panel(right_panel_x, right_panel_y, right_panel_width, right_panel_height,
              "ACTIONS", color_background);

// Draw bottom bar
draw_set_color(color_panel_header);
draw_rectangle(bottom_bar_x, bottom_bar_y, bottom_bar_width, bottom_bar_y + bottom_bar_height, false);
draw_set_color(color_border);
draw_rectangle(bottom_bar_x, bottom_bar_y, bottom_bar_width, bottom_bar_y + bottom_bar_height, true);

// Draw panel content based on active panel
draw_set_halign(fa_left);
draw_set_color(color_text);
var _content_y = left_panel_y + UI_TAB_HEIGHT + 10;
var _content_x = left_panel_x + 10;

// Draw tab system below header
var _tab_width = (screen_width - 2 * UI_MARGIN) / ui_panel_count;
var _tab_y = UI_HEADER_HEIGHT - UI_TAB_HEIGHT;

for (var i = 0; i < ui_panel_count; i++) {
    var _tab_x = UI_MARGIN + (i * _tab_width);
    var _is_active = (ui_active_panel == ui_panels[i]);
    var _is_hovered = (tab_hover == i);
    
    ui_draw_tab(_tab_x, _tab_y, _tab_width, UI_TAB_HEIGHT,
                string_upper(ui_panels[i]), _is_active, _is_hovered);
}

// Draw panel content based on active panel
draw_set_halign(fa_left);
draw_set_color(color_text);

switch (ui_active_panel) {
    case "resources":
        draw_text(_content_x, _content_y, "RESOURCES");
        _content_y += 30;
        
        // Display global resources if they exist
        if (variable_global_exists("resources")) {
            var _res_keys = variable_struct_get_names(global.resources);
            for (var i = 0; i < array_length(_res_keys); i++) {
                var _key = _res_keys[i];
                var _value = variable_struct_get(global.resources, _key);
                draw_text(_content_x, _content_y, string_upper(_key) + ": " + string(_value));
                _content_y += 25;
            }
        } else {
            draw_text(_content_x, _content_y, "Resources not initialized");
        }
        break;
        
    case "pets":
        // Use enhanced pet panel system
        if (script_exists(scr_pet_panel)) {
            draw_pet_panel(_content_x, _content_y, left_panel_width - 20, left_panel_height - 120, {});
            
            // Draw action buttons for selected pet in right panel
            var selected_pet = get_selected_pet_data();
            if (is_struct(selected_pet)) {
                var actions = get_pet_action_buttons();
                var button_y = right_panel_y + UI_TAB_HEIGHT + 20;
                var button_width = UI_BUTTON_WIDTH;
                var button_height = UI_BUTTON_HEIGHT;
                var button_spacing = UI_BUTTON_SPACING;
                
                draw_set_color(color_text);
                draw_text(right_panel_x + 10, button_y - 25, "Actions for " + selected_pet.name + ":");
                
                for (var i = 0; i < array_length(actions); i++) {
                    var action = actions[i];
                    var button_x = right_panel_x + 10 + (i % 2) * (button_width + button_spacing);
                    button_y = right_panel_y + UI_TAB_HEIGHT + 20 + floor(i / 2) * (button_height + button_spacing);
                    
                    // Draw action button using new UI system
                    ui_draw_button(button_x, button_y, button_width, button_height,
                                 action.name, false, false, action.enabled);
                }
            }
        } else {
            draw_text(_content_x, _content_y, "PETS");
            _content_y += 30;
            
            if (variable_global_exists("pets")) {
                for (var i = 0; i < array_length(global.pets); i++) {
                    var _pet = global.pets[i];
                    draw_text(_content_x, _content_y, "Pet " + string(i+1) + ": " + string(_pet));
                    _content_y += 25;
                }
            } else {
                draw_text(_content_x, _content_y, "Pets not initialized");
            }
        }
        break;
        
    case "shop":
        draw_text(_content_x, _content_y, "SHOP");
        _content_y += 30;
        
        // Display shop items
        if (variable_global_exists("shop_items")) {
            for (var i = 0; i < array_length(global.shop_items); i++) {
                var _item = global.shop_items[i];
                draw_text(_content_x, _content_y, string(i+1) + ". " + _item.name);
                _content_y += 20;
                draw_text(_content_x + 10, _content_y, "Price: " + string(_item.price) + " gold");
                _content_y += 20;
                draw_text(_content_x + 10, _content_y, _item.description);
                _content_y += 30;
            }
        } else {
            draw_text(_content_x, _content_y, "Shop items not available");
        }
        
        // Display player gold in right panel
        if (variable_global_exists("resources")) {
            draw_set_color(color_accent);
            draw_text(right_panel_x + 10, right_panel_y + UI_TAB_HEIGHT + 10, "Your Gold: " + string(global.resources.gold));
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

// Draw bottom bar buttons
var _bottom_button_y = bottom_bar_y + 10;
var _bottom_button_width = 100;
var _bottom_button_height = 40;
var _bottom_button_spacing = 20;
var _bottom_buttons = ["Save Game", "Load Game", "Settings", "Quit"];

for (var i = 0; i < array_length(_bottom_buttons); i++) {
    var _button_x = UI_MARGIN + i * (_bottom_button_width + _bottom_button_spacing);
    ui_draw_button(_button_x, _bottom_button_y, _bottom_button_width, _bottom_button_height,
                   _bottom_buttons[i], false, false, false);
}

// Draw bottom bar buttons
var _button_y = bottom_bar_y + 10;
var _button_spacing = 20;
var _button_width = 100;
var _button_height = 40;

// Quick action buttons
var _save_button_x = UI_MARGIN;
ui_draw_button(_save_button_x, _button_y, _button_width, _button_height, "SAVE", false, false, false);

var _load_button_x = _save_button_x + _button_width + _button_spacing;
ui_draw_button(_load_button_x, _button_y, _button_width, _button_height, "LOAD", false, false, false);

var _reset_button_x = _load_button_x + _button_width + _button_spacing;
ui_draw_button(_reset_button_x, _button_y, _button_width, _button_height, "RESET", false, false, false);

// Status display in bottom bar
draw_set_color(color_text);
draw_set_halign(fa_right);
if (variable_global_exists("resources") && variable_struct_exists(global.resources, "gold")) {
    draw_text(screen_width - UI_MARGIN, _button_y + 10, "Gold: " + string(global.resources.gold));
}
if (variable_global_exists("pets")) {
    draw_text(screen_width - UI_MARGIN, _button_y + 30, "Pets: " + string(array_length(global.pets)));
}
draw_set_halign(fa_left);

// Draw enhanced buttons with new system
for (var i = 0; i < array_length(buttons); i++) {
    var _btn = buttons[i];
    var _is_hovered = (button_hover == i);
    
    ui_draw_button(_btn.x, _btn.y, _btn.width, _btn.height, _btn.text, _is_hovered, false, false);
}

// Draw keyboard shortcuts help
draw_set_color(color_text);
draw_set_alpha(0.7);
draw_set_halign(fa_left);
draw_text(UI_MARGIN, screen_height - 25, "Shortcuts: 1-5 (Panels) | S (Save) | L (Load) | ESC (Title)");
draw_set_alpha(1.0);
ui_draw_hover_effects();

// Reset drawing settings
draw_set_halign(fa_left);
draw_set_color(c_white);
