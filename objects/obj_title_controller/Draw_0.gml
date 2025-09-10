// obj_title_controller Draw Event (regular draw, not GUI)

try {
    // Only draw if we're in the title room
    if (room != Room_Title) return;

    show_debug_message("Title controller REGULAR Draw event called");

    // Set basic drawing settings
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Draw title logo sprite as background
    if (sprite_exists(spr_title_logo)) {
        // Get sprite dimensions
        var _sprite_w = sprite_get_width(spr_title_logo);
        var _sprite_h = sprite_get_height(spr_title_logo);
        
        // Calculate scale to fill the entire screen
        var _scale_x = room_width / _sprite_w;
        var _scale_y = room_height / _sprite_h;
        var _scale = max(_scale_x, _scale_y); // Use max to fill entire window
        
        // Calculate center position - account for sprite origin
        var _logo_x = room_width / 2 - (_sprite_w * _scale) / 2;
        var _logo_y = room_height / 2 - (_sprite_h * _scale) / 2;
        
        // Draw sprite at top-left corner of calculated position
        draw_sprite_ext(spr_title_logo, 0, _logo_x, _logo_y, _scale, _scale, 0, c_white, 0.8);
        
        show_debug_message("Drawing sprite at: " + string(_logo_x) + ", " + string(_logo_y) + " with scale: " + string(_scale));
    } else {
        // Fallback if sprite doesn't exist
        draw_set_color(c_dkblue);
        draw_rectangle(0, 0, room_width, room_height, false);
        show_debug_message("Sprite spr_title_logo not found, using fallback");
    }

    // Title text removed - no longer drawing "PAWN STARS IDLE" at the top
    
    show_debug_message("Regular draw completed");
    
} catch (e) {
    show_debug_message("ERROR in regular Draw: " + string(e));
}
