// obj_ui_controller Step Event
// Handle mouse and keyboard input for UI system

// Don't process input in title room
if (room == Room_Title) return;

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

// Handle button interactions
for (var i = 0; i < array_length(buttons); i++) {
    var _btn = buttons[i];
    
    if (_mouse_x >= _btn.x && _mouse_x <= _btn.x + _btn.width &&
        _mouse_y >= _btn.y && _mouse_y <= _btn.y + _btn.height) {
        
        button_hover = i;
        
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
    }
}

// Keyboard shortcuts for panel switching
if (keyboard_check_pressed(ord("1"))) ui_active_panel = "resources";
if (keyboard_check_pressed(ord("2"))) ui_active_panel = "pets";
if (keyboard_check_pressed(ord("3"))) ui_active_panel = "shop";
if (keyboard_check_pressed(ord("4"))) ui_active_panel = "crafting";
if (keyboard_check_pressed(ord("5"))) ui_active_panel = "inventory";

// Toggle UI visibility with Tab key
if (keyboard_check_pressed(vk_tab)) {
    ui_visible = !ui_visible;
    show_debug_message("UI visibility: " + (ui_visible ? "ON" : "OFF"));
}

// Update panel layout if display size changed
if (display_get_gui_width() != panel_x + panel_width + 20) {
    panel_x = display_get_gui_width() - panel_width - 20;
}
