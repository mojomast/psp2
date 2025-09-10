// obj_ui_controller Step Event
// Handle mouse and keyboard input for UI system

// Don't process input in title room
if (room == Room_Title) return;

// Handle escape key to return to title screen
if (keyboard_check_pressed(vk_escape)) {
    transition_to_title();
    return;
}

if (!ui_visible) return;

// Get mouse position in GUI coordinates
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);
var _mouse_pressed = mouse_check_button_pressed(mb_left);

// Reset button hover
button_hover = -1;

// Handle panel tab clicks
var _tab_width = panel_width / ui_panel_count;
for (var i = 0; i < ui_panel_count; i++) {
    var _tab_x = panel_x + (i * _tab_width);
    var _tab_y = panel_y + 40;
    
    if (_mouse_x >= _tab_x && _mouse_x <= _tab_x + _tab_width &&
        _mouse_y >= _tab_y && _mouse_y <= _tab_y + 25) {
        
        if (_mouse_pressed) {
            ui_active_panel = ui_panels[i];
            show_debug_message("Switched to panel: " + ui_active_panel);
        }
        break;
    }
}

// Enhanced button interactions with hover feedback (T043)
var _mouse_released = mouse_check_button_released(mb_left);
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

// Reset hover state if no button is hovered
if (!_any_button_hovered) {
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
if (display_get_gui_width() != panel_x + panel_width + 20) {
    panel_x = display_get_gui_width() - panel_width - 20;
}

// Update hover visual effects (T043)
ui_update_hover_effects();

// Update pet panel data for real-time status changes
if (script_exists(scr_pet_panel)) {
    update_pet_panel_data();
    update_pet_status_display();
}
