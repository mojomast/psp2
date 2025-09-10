// obj_ui_controller Step Event
// Handle mouse and keyboard input for UI system

// Don't process input in title room
if (room == Room_Title) return;

// Handle keyboard shortcuts for panel switching
if (keyboard_check_pressed(ord("1"))) ui_active_panel = UI_PANEL_RESOURCES;
if (keyboard_check_pressed(ord("2"))) ui_active_panel = UI_PANEL_PETS;
if (keyboard_check_pressed(ord("3"))) ui_active_panel = UI_PANEL_SHOP;
if (keyboard_check_pressed(ord("4"))) ui_active_panel = UI_PANEL_CRAFTING;
if (keyboard_check_pressed(ord("5"))) ui_active_panel = UI_PANEL_INVENTORY;

// Handle keyboard shortcuts for quick actions
if (keyboard_check_pressed(ord("S"))) {
    show_debug_message("Quick save triggered");
    add_feedback_message("Quick save!", "success");
}
if (keyboard_check_pressed(ord("L"))) {
    show_debug_message("Quick load triggered");
    add_feedback_message("Quick load!", "success");
}

// Toggle UI visibility with Tab key
if (keyboard_check_pressed(vk_tab)) {
    ui_visible = !ui_visible;
    show_debug_message("UI visibility toggled to: " + string(ui_visible));
    if (ui_visible) {
        add_feedback_message("New UI activated!", "info");
    } else {
        add_feedback_message("Legacy UI activated!", "info");
    }
}

if (!ui_visible) return;

// Get mouse position in GUI coordinates
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);
var _mouse_pressed = mouse_check_button_pressed(mb_left);
var _mouse_released = mouse_check_button_released(mb_left);

// Reset hover states
button_hover = -1;
tab_hover = -1;

// Handle tab clicks - Enhanced tab system
var _tab_width = (screen_width - 2 * UI_MARGIN) / ui_panel_count;
var _tab_y = UI_HEADER_HEIGHT - UI_TAB_HEIGHT;

for (var i = 0; i < ui_panel_count; i++) {
    var _tab_x = UI_MARGIN + (i * _tab_width);
    
    if (ui_is_point_in_rect(_mouse_x, _mouse_y, _tab_x, _tab_y, _tab_width, UI_TAB_HEIGHT)) {
        tab_hover = i;
        
        if (_mouse_pressed) {
            ui_active_panel = ui_panels[i];
            show_debug_message("Switched to panel: " + ui_active_panel);
            break;
        }
    }
}

// Enhanced button interactions with hover feedback
var _any_button_hovered = false;

for (var i = 0; i < array_length(buttons); i++) {
    var _btn = buttons[i];
    var _was_hovered = (button_hover == i);
    var _is_hovered = (_mouse_x >= _btn.x && _mouse_x <= _btn.x + _btn.width &&
                      _mouse_y >= _btn.y && _mouse_y <= _btn.y + _btn.height);
    
    if (_is_hovered) {
        button_hover = i;
        _any_button_hovered = true;
        
        // Trigger hover enter feedback
        if (!_was_hovered) {
            ui_trigger_button_hover_feedback(_btn, i);
        }
        
        // Handle click with enhanced detection
        if (_mouse_pressed && variable_struct_exists(_btn, "callback")) {
            // Execute button callback
            if (is_method(_btn.callback)) {
                _btn.callback();
            } else if (is_string(_btn.callback)) {
                // Handle string callbacks (function names)
                switch (_btn.callback) {
                    case "show_resources":
                        ui_active_panel = "resources";
                        break;
                    case "show_pets":
                        ui_active_panel = "pets";
                        break;
                    case "show_shop":
                        ui_active_panel = "shop";
                        break;
                    case "show_crafting":
                        ui_active_panel = "crafting";
                        break;
                    case "show_inventory":
                        ui_active_panel = "inventory";
                        break;
                    default:
                        show_debug_message("Unknown button callback: " + _btn.callback);
                        break;
                }
            }
        }
        break;
    } else {
        // Handle hover exit feedback
        if (_was_hovered) {
            ui_trigger_button_hover_exit_feedback(_btn, i);
        }
    }
}

// Handle bottom bar button interactions
var _button_y = bottom_bar_y + 10;
var _button_spacing = 20;
var _button_width = 100;
var _button_height = 40;

// Save button
var _save_button_x = UI_MARGIN;
if (ui_is_point_in_rect(_mouse_x, _mouse_y, _save_button_x, _button_y, _button_width, _button_height)) {
    if (_mouse_pressed) {
        show_debug_message("Save button clicked");
        // TODO: Implement save functionality
        add_feedback_message("Game saved!", "success");
    }
}

// Load button
var _load_button_x = _save_button_x + _button_width + _button_spacing;
if (ui_is_point_in_rect(_mouse_x, _mouse_y, _load_button_x, _button_y, _button_width, _button_height)) {
    if (_mouse_pressed) {
        show_debug_message("Load button clicked");
        // TODO: Implement load functionality
        add_feedback_message("Game loaded!", "success");
    }
}

// Reset button
var _reset_button_x = _load_button_x + _button_width + _button_spacing;
if (ui_is_point_in_rect(_mouse_x, _mouse_y, _reset_button_x, _button_y, _button_width, _button_height)) {
    if (_mouse_pressed) {
        show_debug_message("Reset button clicked");
        // TODO: Implement reset functionality
        add_feedback_message("Game reset!", "warning");
    }
}
    button_hover = -1;
}

// Handle pet panel specific interactions
if (ui_active_panel == "pets" && script_exists(scr_pet_panel)) {
    var _content_y = panel_y + 80;
    
    // Handle pet selection clicks
    if (_mouse_pressed && 
        _mouse_x >= panel_x + 10 && _mouse_x <= panel_x + panel_width - 10 &&
        _mouse_y >= _content_y && _mouse_y <= panel_y + panel_height - 100) {
        
        if (pet_panel_handle_click(panel_x + 10, _content_y, _mouse_x, _mouse_y)) {
            show_debug_message("Pet selection updated");
        }
    }
    
    // Handle pet action button clicks
    var selected_pet = get_selected_pet_data();
    if (is_struct(selected_pet)) {
        var actions = get_pet_action_buttons();
        var button_y = panel_y + panel_height - 80;
        var button_width = 80;
        var button_height = 20;
        var button_spacing = 5;
        
        if (_mouse_pressed && _mouse_y >= button_y && _mouse_y <= button_y + button_height) {
            for (var i = 0; i < array_length(actions); i++) {
                var action = actions[i];
                var button_x = panel_x + 10 + (i * (button_width + button_spacing));
                
                if (_mouse_x >= button_x && _mouse_x <= button_x + button_width && action.enabled) {
                    handle_pet_action_click(action.action);
                    break;
                }
            }
        }
    }
}

// Handle bottom bar button clicks
var _bottom_button_y = bottom_bar_y + 10;
var _bottom_button_width = 100;
var _bottom_button_height = 40;
var _bottom_button_spacing = 20;
var _bottom_buttons = ["Save Game", "Load Game", "Settings", "Quit"];

for (var i = 0; i < array_length(_bottom_buttons); i++) {
    var _button_x = UI_MARGIN + i * (_bottom_button_width + _bottom_button_spacing);
    
    if (ui_is_point_in_rect(_mouse_x, _mouse_y, _button_x, _bottom_button_y, _bottom_button_width, _bottom_button_height)) {
        if (_mouse_pressed) {
            switch (_bottom_buttons[i]) {
                case "Save Game":
                    show_debug_message("Save Game clicked");
                    // Add save functionality here
                    break;
                case "Load Game":
                    show_debug_message("Load Game clicked");
                    // Add load functionality here
                    break;
                case "Settings":
                    show_debug_message("Settings clicked");
                    // Add settings functionality here
                    break;
                case "Quit":
                    show_debug_message("Quit clicked");
                    game_end();
                    break;
            }
            break;
        }
    }
}

// Enhanced keyboard shortcuts for panel switching (T042)
if (keyboard_check_pressed(ord("1"))) ui_switch_panel("resources");
if (keyboard_check_pressed(ord("2"))) ui_switch_panel("pets");
if (keyboard_check_pressed(ord("3"))) ui_switch_panel("shop");
if (keyboard_check_pressed(ord("4"))) ui_switch_panel("crafting");
if (keyboard_check_pressed(ord("5"))) ui_switch_panel("inventory");

// Arrow keys for next/previous panel navigation
if (keyboard_check_pressed(vk_right)) ui_switch_to_next_panel();
if (keyboard_check_pressed(vk_left)) ui_switch_to_previous_panel();

// Toggle UI visibility with Tab key
if (keyboard_check_pressed(vk_tab)) {
    ui_visible = !ui_visible;
    show_debug_message("UI visibility: " + (ui_visible ? "ON" : "OFF"));
}

// Update panel layout if display size changed
if (display_get_gui_width() != screen_width) {
    // Update layout for new screen size
    screen_width = display_get_gui_width();
    screen_height = display_get_gui_height();
    left_panel_x = UI_LEFT_PANEL_X;
    right_panel_x = UI_RIGHT_PANEL_X;
}

// Update hover visual effects (T043)
ui_update_hover_effects();

// Update pet panel data for real-time status changes
if (script_exists(scr_pet_panel)) {
    update_pet_panel_data();
    update_pet_status_display();
}
