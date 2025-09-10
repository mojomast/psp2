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

// Simple input handling
if (keyboard_check_pressed(vk_enter)) {
    show_debug_message("ENTER pressed - starting game");
    room_goto(Room1);
}

if (keyboard_check_pressed(vk_escape)) {
    show_debug_message("ESC pressed - exiting game");
    game_end();
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
