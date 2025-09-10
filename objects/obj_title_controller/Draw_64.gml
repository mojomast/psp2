// obj_title_controller Draw GUI Event
// Draw title screen UI elements over the background

// Set up drawing
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw menu options
draw_set_font(fnt_ui_main);
for (var i = 0; i < menu_count; i++) {
    var _y = menu_y + (i * menu_spacing);
    
    // Set color based on selection
    if (i == menu_selected) {
        draw_set_color(color_selected);
        // Draw selection indicator
        draw_text(menu_x - 20, _y, ">");
    } else {
        draw_set_color(color_normal);
    }
    
    // Draw menu item
    draw_text(menu_x, _y, menu_options[i]);
}

// Draw creator credits
draw_set_color(color_credits);
draw_set_font(fnt_ui_main);

var _credits_x = display_get_gui_width() - 300;
var _credits_y = display_get_gui_height() - 80;

draw_text(_credits_x, _credits_y, "Created by:");
draw_text(_credits_x, _credits_y + 20, "KYLE DUREPOS & MATTHEW DUREPOS");

// Draw game title (if no title in background sprite)
draw_set_color(c_white);
draw_set_font(fnt_title);
draw_set_halign(fa_center);
draw_text(display_get_gui_width() / 2, 50, "PAWN STARS IDLE GAME");

// Draw instructions
draw_set_color(color_credits);
draw_set_font(fnt_ui_main);
draw_set_halign(fa_center);
draw_text(display_get_gui_width() / 2, display_get_gui_height() - 30, "Use Arrow Keys or Mouse to Navigate • Enter or Click to Select");

// Reset drawing settings
draw_set_halign(fa_left);
draw_set_color(c_white);
