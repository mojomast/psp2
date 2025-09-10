// obj_title_controller Create Event
// Initialize title screen variables and settings

// Menu system variables
menu_selected = 0;  // Currently selected menu item (0=Start, 1=Settings, 2=Exit)
menu_options = ["Start Game", "Settings", "Exit"];
menu_count = array_length(menu_options);

// Input handling
key_up_pressed = false;
key_down_pressed = false;
key_enter_pressed = false;

// Visual settings
menu_x = 50;
menu_y = 620;
menu_spacing = 30;

// Colors
color_normal = c_white;
color_selected = c_yellow;
color_credits = c_ltgray;

// Title screen setup complete
show_debug_message("Title screen controller initialized");
