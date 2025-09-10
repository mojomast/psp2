// obj_title_controller Create Event
// Initialize title screen variables and settings

show_debug_message("=== TITLE CONTROLLER CREATE EVENT STARTED ===");
show_debug_message("Current room: " + string(room));
show_debug_message("Room name: " + room_get_name(room));

// Menu system variables
menu_selected = 0;  // Currently selected menu item (0=Start, 1=Settings, 2=Exit)
menu_options = ["Start Game", "Settings", "Exit"];
menu_count = array_length(menu_options);

// Input handling
key_up_pressed = false;
key_down_pressed = false;
key_enter_pressed = false;

// Add a delay to prevent immediate input processing
input_delay = 30; // 30 frames delay
input_timer = 0;

// Visual settings
menu_x = 400;  // Fixed position instead of dynamic
menu_y = 300;  // Fixed position instead of dynamic
menu_spacing = 40;

// Colors
color_normal = c_white;
color_selected = c_yellow;
color_credits = c_ltgray;

try {
    // Force assets to be included in build - reference them directly
    global._force_fonts = [fnt_title, fnt_ui_main];
    global._force_sprites = [spr_title_logo, spr_ui_buttons, spr_ui_icons];
    show_debug_message("Assets forced for inclusion");

    // Initialize game if not already done
    if (!variable_global_exists("game_initialized")) {
        init_game_state();
        global.game_initialized = true;
        show_debug_message("Game initialized from title screen");
    }
    
    // Make sure this object draws
    visible = true;
    depth = -1000; // Draw on top
    
} catch (e) {
    show_debug_message("ERROR in title controller create: " + string(e));
}

// Title screen setup complete
show_debug_message("=== TITLE CONTROLLER CREATE EVENT COMPLETED ===");
show_debug_message("Menu count: " + string(menu_count));
show_debug_message("Input delay: " + string(input_delay));

// Hide UI controller in title room
if (instance_exists(obj_ui_controller)) {
    obj_ui_controller.ui_visible = false;
    show_debug_message("UI controller hidden for title screen");
}
show_debug_message("Menu options: " + string(menu_options));
show_debug_message("Menu count: " + string(menu_count));
show_debug_message("Display size: " + string(display_get_width()) + "x" + string(display_get_height()));
show_debug_message("Menu position: " + string(menu_x) + ", " + string(menu_y));
