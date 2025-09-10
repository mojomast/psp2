// obj_title_controller Step Event
// Handle input and menu navigation

// Check for keyboard input
key_up_pressed = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
key_down_pressed = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
key_enter_pressed = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

// Handle menu navigation
if (key_up_pressed) {
    menu_selected--;
    if (menu_selected < 0) {
        menu_selected = menu_count - 1;
    }
}

if (key_down_pressed) {
    menu_selected++;
    if (menu_selected >= menu_count) {
        menu_selected = 0;
    }
}

// Handle menu selection
if (key_enter_pressed) {
    switch (menu_selected) {
        case 0: // Start Game
            show_debug_message("Starting game - transitioning to Room1");
            room_goto(Room1);
            break;
            
        case 1: // Settings
            show_debug_message("Settings not implemented yet");
            break;
            
        case 2: // Exit
            show_debug_message("Exiting game");
            game_end();
            break;
    }
}

// Handle mouse input
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

// Check if mouse is over menu items
for (var i = 0; i < menu_count; i++) {
    var _item_y = menu_y + (i * menu_spacing);
    
    if (_mouse_x > menu_x && _mouse_x < menu_x + 200 && 
        _mouse_y > _item_y - 10 && _mouse_y < _item_y + 20) {
        menu_selected = i;
        
        // Check for mouse click
        if (mouse_check_button_pressed(mb_left)) {
            key_enter_pressed = true; // Trigger the same logic as Enter key
        }
    }
}
