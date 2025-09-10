// scr_ui_system.gml
// Core UI system functions and utilities

// UI System Constants
#macro UI_PANEL_RESOURCES 0
#macro UI_PANEL_PETS 1
#macro UI_PANEL_SHOP 2
#macro UI_PANEL_CRAFTING 3
#macro UI_PANEL_INVENTORY 4

// UI Colors
#macro UI_COLOR_BACKGROUND make_color_rgb(30, 30, 30)
#macro UI_COLOR_BORDER make_color_rgb(100, 100, 100)
#macro UI_COLOR_TEXT c_white
#macro UI_COLOR_HIGHLIGHT c_yellow
#macro UI_COLOR_BUTTON_NORMAL make_color_rgb(60, 60, 60)
#macro UI_COLOR_BUTTON_HOVER make_color_rgb(80, 80, 80)

// UI System Global Variables
global.ui_system_initialized = false;
global.ui_panels_visible = true;
global.ui_active_panel = UI_PANEL_RESOURCES;

/// @function ui_initialize()
// @description Initialize the UI system
function ui_initialize() {
    show_debug_message("Initializing UI system...");
    
    // Set up global UI variables
    global.ui_system_initialized = true;
    global.ui_panels_visible = true;
    global.ui_active_panel = UI_PANEL_RESOURCES;
    
    // Initialize UI fonts
    if (!font_exists(fnt_ui_main)) {
        show_debug_message("Warning: fnt_ui_main font not found");
    }
    
    show_debug_message("UI system initialized successfully");
}

/// @function ui_get_panel_name(panel_id)
// @description Get the string name of a panel from its ID
// @param {real} panel_id The panel ID constant
// @return {string} The panel name
function ui_get_panel_name(panel_id) {
    switch (panel_id) {
        case UI_PANEL_RESOURCES: return "resources";
        case UI_PANEL_PETS: return "pets";
        case UI_PANEL_SHOP: return "shop";
        case UI_PANEL_CRAFTING: return "crafting";
        case UI_PANEL_INVENTORY: return "inventory";
        default: return "unknown";
    }
}

/// @function ui_set_active_panel(panel_id)
// @description Set the currently active UI panel
// @param {real} panel_id The panel ID to activate
function ui_set_active_panel(panel_id) {
    if (panel_id >= 0 && panel_id <= UI_PANEL_INVENTORY) {
        global.ui_active_panel = panel_id;
        show_debug_message("UI panel changed to: " + ui_get_panel_name(panel_id));
    } else {
        show_debug_message("Error: Invalid panel ID: " + string(panel_id));
    }
}

/// @function ui_toggle_visibility()
// @description Toggle UI panel visibility
function ui_toggle_visibility() {
    global.ui_panels_visible = !global.ui_panels_visible;
    show_debug_message("UI panels visibility: " + (global.ui_panels_visible ? "ON" : "OFF"));
}

/// @function ui_draw_panel_background(x, y, width, height)
// @description Draw a standard UI panel background
// @param {real} x The x position
// @param {real} y The y position
// @param {real} width The panel width
// @param {real} height The panel height
function ui_draw_panel_background(x, y, width, height) {
    // Background
    draw_set_color(UI_COLOR_BACKGROUND);
    draw_rectangle(x, y, x + width, y + height, false);
    
    // Border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x, y, x + width, y + height, true);
}

/// @function ui_draw_button(x, y, width, height, text, hovered)
// @description Draw a UI button
// @param {real} x The x position
// @param {real} y The y position
// @param {real} width The button width
// @param {real} height The button height
// @param {string} text The button text
// @param {bool} hovered Whether the button is hovered
function ui_draw_button(x, y, width, height, text, hovered) {
    // Button background
    if (hovered) {
        draw_set_color(UI_COLOR_BUTTON_HOVER);
    } else {
        draw_set_color(UI_COLOR_BUTTON_NORMAL);
    }
    draw_rectangle(x, y, x + width, y + height, false);
    
    // Button border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(x, y, x + width, y + height, true);
    
    // Button text
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x + width/2, y + height/2, text);
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @function ui_is_point_in_rect(px, py, rx, ry, rwidth, rheight)
// @description Check if a point is inside a rectangle
// @param {real} px Point x
// @param {real} py Point y
// @param {real} rx Rectangle x
// @param {real} ry Rectangle y
// @param {real} rwidth Rectangle width
// @param {real} rheight Rectangle height
// @return {bool} True if point is inside rectangle
function ui_is_point_in_rect(px, py, rx, ry, rwidth, rheight) {
    return (px >= rx && px <= rx + rwidth && py >= ry && py <= ry + rheight);
}

/// @function ui_format_number(number)
// @description Format a number for display in UI
// @param {real} number The number to format
// @return {string} Formatted number string
function ui_format_number(number) {
    if (number >= 1000000000) {
        return string_format(number / 1000000000, 1, 1) + "B";
    } else if (number >= 1000000) {
        return string_format(number / 1000000, 1, 1) + "M";
    } else if (number >= 1000) {
        return string_format(number / 1000, 1, 1) + "K";
    } else {
        return string(number);
    }
}

// Initialize UI system when script is loaded
ui_initialize();
