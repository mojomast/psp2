// obj_title_controller Draw Event (regular draw, not GUI)

try {
    // Only draw if we're in the title room
    if (room != Room_Title) return;

    show_debug_message("Title controller REGULAR Draw event called");

    // Set basic drawing settings
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Draw background
    draw_set_color(c_red);
    draw_rectangle(0, 0, room_width, room_height, false);

    // Draw text
    draw_set_color(c_white);
    draw_text(100, 100, "REGULAR DRAW EVENT");
    draw_text(100, 130, "PAWN STARS IDLE");
    draw_text(100, 160, "Frame: " + string(current_time));
    
    show_debug_message("Regular draw completed");
    
} catch (e) {
    show_debug_message("ERROR in regular Draw: " + string(e));
}
