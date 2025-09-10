// obj_title_controller Step Event
// Handle input and menu navigation

// Only process input if we're in the title room
if (room != Room_Title) {
    show_debug_message("Not in title room, current room: " + string(room));
    return;
}

// Update input delay timer
input_timer++;
if (input_timer < input_delay) {
    if (input_timer % 10 == 0) { // Only show every 10 frames to reduce spam
        show_debug_message("Input delay active: " + string(input_timer) + "/" + string(input_delay));
    }
    return;
}

if (input_timer == input_delay) {
    show_debug_message("Title controller Step - processing input, ready for input");
}

// Keyboard navigation
if (keyboard_check_pressed(vk_up)) {
    menu_selected--;
    if (menu_selected < 0) menu_selected = menu_count - 1;
    show_debug_message("Menu up - selected: " + string(menu_selected));
}

if (keyboard_check_pressed(vk_down)) {
    menu_selected++;
    if (menu_selected >= menu_count) menu_selected = 0;
    show_debug_message("Menu down - selected: " + string(menu_selected));
}

// Handle Enter key and menu selection
if (keyboard_check_pressed(vk_enter)) {
    show_debug_message("ENTER pressed - menu item " + string(menu_selected) + ": " + menu_options[menu_selected]);
    
    if (menu_selected == 0) { // Start Game
        show_debug_message("KEYBOARD - starting game");
        transition_to_game();
    } else if (menu_selected == 1) { // Settings
        show_debug_message("Settings not implemented yet");
    } else if (menu_selected == 2) { // Exit
        show_debug_message("KEYBOARD - exiting game");
        game_end();
    }
}

// ESC key for quick exit
if (keyboard_check_pressed(vk_escape)) {
    show_debug_message("ESC pressed - exiting game");
    game_end();
}

// Handle mouse input - use GUI coordinates since menu is drawn in Draw GUI
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

// Reset menu selection first
var _old_selected = menu_selected;
var _mouse_over_menu = false;

// Check if mouse is over menu items
for (var i = 0; i < menu_count; i++) {
    var _item_y = menu_y + (i * menu_spacing);
    
    // Check if mouse is over this menu item (with some padding)
    if (_mouse_x >= menu_x - 20 && _mouse_x <= menu_x + 200 && 
        _mouse_y >= _item_y - 10 && _mouse_y <= _item_y + 20) {
        menu_selected = i;
        _mouse_over_menu = true;
        
        // Check for mouse click
        if (mouse_check_button_pressed(mb_left)) {
            show_debug_message("Mouse clicked on menu item " + string(i) + ": " + menu_options[i]);
            if (i == 0) { // Start Game
                show_debug_message("MOUSE CLICK - starting game");
                transition_to_game();
            } else if (i == 2) { // Exit
                show_debug_message("MOUSE CLICK - exiting game");
                game_end();
            }
        }
        break;
    }
}

// If mouse moved off menu, don't change selection
if (!_mouse_over_menu) {
    menu_selected = _old_selected;
}
