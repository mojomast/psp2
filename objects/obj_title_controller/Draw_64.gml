// obj_title_controller Draw GUI Event
// Draw title screen UI elements over the background

try {
    // Only draw if we're in the title room
    if (room != Room_Title) {
        show_debug_message("Not in title room, skipping draw");
        return;
    }

    show_debug_message("Title controller Draw GUI - Frame " + string(current_time));

    // Use only basic, safe drawing commands
    draw_set_font(-1); // Force default font
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Draw simple background using GUI dimensions for safety
    draw_set_color(c_blue);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

    // Draw simple white text
    draw_set_color(c_white);
    draw_text(50, 50, "PAWN STARS IDLE GAME");
    draw_text(50, 100, "TITLE SCREEN ACTIVE - FRAME: " + string(current_time));
    draw_text(50, 150, "Press ENTER to continue");
    draw_text(50, 200, "Press ESC to quit");
    
    // Draw a moving element to show it's updating
    var _x = 50 + (sin(current_time / 1000) * 20);
    draw_set_color(c_yellow);
    draw_circle(_x, 250, 10, false);

    show_debug_message("Drawing completed successfully");
    
} catch (e) {
    show_debug_message("ERROR in Draw GUI: " + string(e));
}

// Draw menu options
draw_set_halign(fa_left);
for (var i = 0; i < menu_count; i++) {
    var _y = menu_y + (i * menu_spacing);
    show_debug_message("Drawing menu item " + string(i) + " at y=" + string(_y) + ": " + menu_options[i]);
    
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
// Use default font if custom font doesn't exist
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1); // Default font
}

var _credits_x = display_get_gui_width() - 300;
var _credits_y = display_get_gui_height() - 80;

draw_text(_credits_x, _credits_y, "Created by:");
draw_text(_credits_x, _credits_y + 20, "KYLE DUREPOS & MATTHEW DUREPOS");

// Draw game title (if no title in background sprite)
draw_set_color(c_white);
// Use default font if custom font doesn't exist
if (font_exists(fnt_title)) {
    draw_set_font(fnt_title);
} else {
    draw_set_font(-1); // Default font
}
draw_set_halign(fa_center);
draw_text(display_get_gui_width() / 2, 50, "PAWN STARS IDLE GAME");

// Draw instructions
draw_set_color(color_credits);
// Use default font if custom font doesn't exist
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1); // Default font
}
draw_set_halign(fa_center);
draw_text(display_get_gui_width() / 2, display_get_gui_height() - 30, "Use Arrow Keys or Mouse to Navigate • Enter or Click to Select");

// Reset drawing settings
draw_set_halign(fa_left);
draw_set_color(c_white);
