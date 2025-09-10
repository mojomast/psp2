/// @description Player Status Panel Functions
/// Specialized functions for player status panel display and data management
/// Part of T026 - Player status panel functions

/// @function draw_player_panel(x, y, width, height, panel_data)
/// @description Draw the player status panel with current player data
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @param {struct} panel_data Additional panel configuration data
function draw_player_panel(x, y, width, height, panel_data) {
    // Draw panel background
    draw_set_color(UI_COLOR_PANEL_BG);
    draw_rectangle(x, y, x + width, y + height, false);
    
    // Draw panel border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x, y, x + width, y + height, true);
    
    var _content_y = y + 10;
    
    // Panel title
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_text(x + width/2, _content_y, "PLAYER STATUS");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Get player data
    var player_data = get_player_panel_data();
    
    // Player Level
    draw_text(x + 10, _content_y, "Level:");
    draw_set_halign(fa_right);
    draw_text(x + width - 10, _content_y, string(player_data.level));
    draw_set_halign(fa_left);
    _content_y += 20;
    
    // Experience
    draw_text(x + 10, _content_y, "EXP:");
    draw_set_halign(fa_right);
    draw_text(x + width - 10, _content_y, string(player_data.experience) + "/" + string(player_data.experience_max));
    draw_set_halign(fa_left);
    _content_y += 20;
    
    // Experience Bar
    var bar_width = width - 20;
    var bar_height = 8;
    var exp_ratio = player_data.experience / player_data.experience_max;
    
    // Bar background
    draw_set_color(UI_COLOR_BAR_BG);
    draw_rectangle(x + 10, _content_y, x + 10 + bar_width, _content_y + bar_height, false);
    
    // Bar fill
    draw_set_color(UI_COLOR_EXP_BAR);
    draw_rectangle(x + 10, _content_y, x + 10 + (bar_width * exp_ratio), _content_y + bar_height, false);
    
    // Bar border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x + 10, _content_y, x + 10 + bar_width, _content_y + bar_height, true);
    
    _content_y += 25;
    
    // Energy/Stamina
    draw_set_color(UI_COLOR_TEXT);
    draw_text(x + 10, _content_y, "Energy:");
    draw_set_halign(fa_right);
    draw_text(x + width - 10, _content_y, string(player_data.energy) + "/" + string(player_data.energy_max));
    draw_set_halign(fa_left);
    _content_y += 20;
    
    // Energy Bar
    var energy_ratio = player_data.energy / player_data.energy_max;
    
    // Bar background
    draw_set_color(UI_COLOR_BAR_BG);
    draw_rectangle(x + 10, _content_y, x + 10 + bar_width, _content_y + bar_height, false);
    
    // Bar fill
    draw_set_color(UI_COLOR_ENERGY_BAR);
    draw_rectangle(x + 10, _content_y, x + 10 + (bar_width * energy_ratio), _content_y + bar_height, false);
    
    // Bar border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x + 10, _content_y, x + 10 + bar_width, _content_y + bar_height, true);
}

/// @function get_player_panel_data()
/// @description Get current player status data for display
/// @return {struct} Player data structure
function get_player_panel_data() {
    // Check if player data exists in global scope
    if (variable_global_exists("player")) {
        return global.player;
    }
    
    // Return default player data if not initialized
    return {
        level: 1,
        experience: 0,
        experience_max: 100,
        energy: 100,
        energy_max: 100,
        health: 100,
        health_max: 100
    };
}

/// @function get_player_panel_layout(x, y, width, height)
/// @description Calculate layout positions for player panel elements
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @return {struct} Layout structure with positions
function get_player_panel_layout(x, y, width, height) {
    return {
        panel_x: x,
        panel_y: y,
        panel_width: width,
        panel_height: height,
        title_x: x + width/2,
        title_y: y + 15,
        content_start_y: y + 45,
        stat_spacing: 20,
        bar_spacing: 25,
        bar_width: width - 20,
        bar_height: 8
    };
}

/// @function update_player_panel_data()
/// @description Update player panel with latest data (called from UI controller)
/// @return {bool} True if update successful
function update_player_panel_data() {
    try {
        // Initialize player data if it doesn't exist
        if (!variable_global_exists("player")) {
            global.player = {
                level: 1,
                experience: 0,
                experience_max: 100,
                energy: 100,
                energy_max: 100,
                health: 100,
                health_max: 100
            };
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating player panel data: " + string(error));
        return false;
    }
}

/// @function player_panel_handle_click(x, y, mouse_x, mouse_y)
/// @description Handle mouse clicks in player panel area
/// @param {real} x Panel x position  
/// @param {real} y Panel y position
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @return {bool} True if click was handled
function player_panel_handle_click(x, y, mouse_x, mouse_y) {
    // Player panel is mostly display-only
    // Could be extended for character sheet popup or stat allocation
    return false;
}
