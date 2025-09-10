// obj_ui_controller Create Event
// Initialize UI system variables and panel settings

// UI Panel System Variables
ui_active_panel = "resources";  // Current active panel (resources, pets, shop, crafting, inventory)
ui_panels = ["resources", "pets", "shop", "crafting", "inventory"];
ui_panel_count = array_length(ui_panels);

// Panel Layout Settings
panel_width = 300;
panel_height = 400;
panel_x = display_get_gui_width() - panel_width - 20;
panel_y = 20;

// Button System
buttons = [];  // Array to hold button data
button_hover = -1;  // Currently hovered button index

// UI State Variables
ui_visible = true;
ui_initialized = false;

// Colors and Styling
color_background = make_color_rgb(30, 30, 30);
color_border = make_color_rgb(100, 100, 100);
color_text = c_white;
color_highlight = c_yellow;
color_button_normal = make_color_rgb(60, 60, 60);
color_button_hover = make_color_rgb(80, 80, 80);
color_button_pressed = make_color_rgb(100, 100, 100);

// Force font assets to be included
global._ui_fonts = [fnt_ui_main, fnt_title];
global._ui_sprites = [spr_ui_buttons, spr_ui_icons];

// Font settings
draw_set_font(fnt_ui_main);

// Initialize UI system
show_debug_message("UI controller initialized");

// Mark as initialized
ui_initialized = true;
