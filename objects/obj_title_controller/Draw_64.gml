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

    // Don't draw background here - let the regular Draw event handle the sprite background
    
    // Draw a subtle overlay for better text readability
    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1.0);
    
    // Draw a moving element to show it's updating (the yellow ball)
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

// Draw copyright notice at the bottom
draw_set_color(c_white);
// Use title font for larger text if available
if (font_exists(fnt_title)) {
    draw_set_font(fnt_title);
} else {
    draw_set_font(-1); // Default font
}
draw_set_halign(fa_center);
// Move up more and make bigger
draw_text(display_get_gui_width() / 2, display_get_gui_height() - 120, "PAWN SHOP PIONEERRS");

// Switch to smaller font for copyright line
draw_set_color(color_credits);
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1); // Default font
}
draw_text(display_get_gui_width() / 2, display_get_gui_height() - 80, "Copyright 2025 Kyle and Matthew Durepos - All Rights Reserved");

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
