// obj_ui_controller Create Event
// Initialize UI system variables and panel settings

// UI Panel System Variables
ui_active_panel = UI_PANEL_RESOURCES;  // Current active panel
ui_previous_panel = UI_PANEL_RESOURCES; // Previous panel for back navigation
ui_panels = ui_get_all_panels();  // Get panels from constants
ui_panel_count = array_length(ui_panels);

// Panel Layout Settings
panel_width = UI_PANEL_WIDTH;
panel_height = UI_PANEL_HEIGHT;
panel_x = display_get_gui_width() - panel_width - 20;
panel_y = 20;

// Button System
buttons = [];  // Array to hold button data
button_hover = -1;  // Currently hovered button index

// UI State Variables
ui_visible = true;
ui_initialized = false;

// Initialize the UI system
ui_initialize();
ui_initialized = true;

// Colors and Styling - Reference UI constants
color_background = UI_COLOR_PANEL_BG;
color_border = UI_COLOR_BORDER;
color_text = UI_COLOR_TEXT;
color_highlight = UI_COLOR_HIGHLIGHT;
color_button_normal = UI_COLOR_BUTTON_NORMAL;
color_button_hover = UI_COLOR_BUTTON_HOVER;
color_button_pressed = UI_COLOR_BUTTON_PRESSED;

// Force font assets to be included (check if they exist first)
if (font_exists(fnt_ui_main) && font_exists(fnt_title)) {
    global._ui_fonts = [fnt_ui_main, fnt_title];
}
if (sprite_exists(spr_ui_buttons) && sprite_exists(spr_ui_icons)) {
    global._ui_sprites = [spr_ui_buttons, spr_ui_icons];
}

// Font settings
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
}

// Initialize UI system
show_debug_message("UI controller initialized");

// Mark as initialized
ui_initialized = true;

/// @function transition_to_title()
/// @description Handle transition from game back to title screen
function transition_to_title() {
    show_debug_message("Starting transition to title screen...");
    
    // Add feedback message
    try {
        add_feedback_message("Returning to main menu", "info");
    } catch(error) {
        show_debug_message("Feedback system not available during title transition");
    }
    
    // Hide UI
    ui_visible = false;
    
    // Transition to the title room
    room_goto(Room_Title);
    
    show_debug_message("Room transition initiated to Room_Title");
}

// === ENHANCED PANEL MODE SWITCHING SYSTEM (T042) ===

/// @function ui_switch_panel(new_panel)
/// @description Enhanced panel switching with validation and feedback
/// @param {string} new_panel Panel name to switch to
function ui_switch_panel(new_panel) {
    // Validate panel name
    if (!ui_is_valid_panel(new_panel)) {
        show_debug_message("Error: Invalid panel name: " + new_panel);
        try {
            add_feedback_message("Invalid panel: " + new_panel, "error");
        } catch(error) {
            // Feedback system not available
        }
        return false;
    }
    
    // Check if already on this panel
    if (ui_active_panel == new_panel) {
        show_debug_message("Already viewing panel: " + new_panel);
        return false;
    }
    
    // Store previous panel for potential back navigation
    ui_previous_panel = ui_active_panel;
    
    // Switch panel
    var old_panel = ui_active_panel;
    ui_active_panel = new_panel;
    
    // Add feedback message
    try {
        add_feedback_message("Switched to " + ui_get_panel_display_name(new_panel) + " panel", "info");
    } catch(error) {
        // Feedback system not available
    }
    
    // Debug output
    show_debug_message("Panel switched: " + old_panel + " → " + new_panel);
    
    // Trigger panel change event
    ui_on_panel_changed(old_panel, new_panel);
    
    return true;
}

/// @function ui_is_valid_panel(panel_name)
/// @description Check if panel name is valid
/// @param {string} panel_name Panel name to validate
/// @return {bool} True if panel is valid
function ui_is_valid_panel(panel_name) {
    for (var i = 0; i < array_length(ui_panels); i++) {
        if (ui_panels[i] == panel_name) {
            return true;
        }
    }
    return false;
}

/// @function ui_get_panel_display_name(panel_name)
/// @description Get display-friendly name for panel
/// @param {string} panel_name Internal panel name
/// @return {string} Display name for panel
function ui_get_panel_display_name(panel_name) {
    switch(panel_name) {
        case "resources": return "Resources";
        case "pets": return "Pets";
        case "shop": return "Shop";
        case "crafting": return "Crafting";
        case "inventory": return "Inventory";
        default: return string_upper(string_char_at(panel_name, 1)) + string_copy(panel_name, 2, string_length(panel_name) - 1);
    }
}

/// @function ui_on_panel_changed(old_panel, new_panel)
/// @description Event handler for when panel changes
/// @param {string} old_panel Previous panel name
/// @param {string} new_panel New panel name
function ui_on_panel_changed(old_panel, new_panel) {
    // Update panel-specific data when switching
    switch(new_panel) {
        case "resources":
            if (script_exists(update_resource_panel_data)) {
                update_resource_panel_data();
            }
            break;
        case "pets":
            if (script_exists(update_pet_panel_data)) {
                update_pet_panel_data();
            }
            break;
        case "shop":
            if (script_exists(update_shop_panel_data)) {
                update_shop_panel_data();
            }
            break;
        case "crafting":
            if (script_exists(update_crafting_panel_data)) {
                update_crafting_panel_data();
            }
            break;
        case "inventory":
            if (script_exists(update_inventory_panel_data)) {
                update_inventory_panel_data();
            }
            break;
    }
    
    // Could add panel transition animations here
    // TODO: Add smooth transition effects when animation system exists
}

/// @function ui_switch_to_next_panel()
/// @description Switch to next panel in sequence
function ui_switch_to_next_panel() {
    var current_index = -1;
    for (var i = 0; i < array_length(ui_panels); i++) {
        if (ui_panels[i] == ui_active_panel) {
            current_index = i;
            break;
        }
    }
    
    if (current_index != -1) {
        var next_index = (current_index + 1) % array_length(ui_panels);
        ui_switch_panel(ui_panels[next_index]);
    }
}

/// @function ui_switch_to_previous_panel()
/// @description Switch to previous panel in sequence
function ui_switch_to_previous_panel() {
    var current_index = -1;
    for (var i = 0; i < array_length(ui_panels); i++) {
        if (ui_panels[i] == ui_active_panel) {
            current_index = i;
            break;
        }
    }
    
    if (current_index != -1) {
        var prev_index = (current_index - 1 + array_length(ui_panels)) % array_length(ui_panels);
        ui_switch_panel(ui_panels[prev_index]);
    }
}

// === MOUSE HOVER FEEDBACK SYSTEM (T043) ===

/// @function ui_trigger_button_hover_feedback(button, button_index)
/// @description Trigger feedback when button is hovered
/// @param {struct} button Button that is being hovered
/// @param {real} button_index Index of button in buttons array
function ui_trigger_button_hover_feedback(button, button_index) {
    // Debug output
    show_debug_message("Button hover enter: " + (variable_struct_exists(button, "text") ? button.text : "Button " + string(button_index)));
    
    // Visual feedback could be handled in the drawing system
    // Mark button as hovered for visual effects
    if (variable_struct_exists(button, "hovered")) {
        button.hovered = true;
    }
    
    // Add subtle feedback message
    if (script_exists(add_feedback_message) && variable_struct_exists(button, "text")) {
        add_feedback_message("Hover: " + button.text, "info");
    }
    
    // TODO: Add hover sound effect when sound system is available
    // audio_play_sound(snd_ui_hover, 1, false);
    
    // Could trigger hover animations or particle effects here
    ui_create_hover_visual_effect(button.x + button.width/2, button.y + button.height/2);
}

/// @function ui_trigger_button_hover_exit_feedback(button, button_index)
/// @description Trigger feedback when button hover exits
/// @param {struct} button Button that hover is exiting
/// @param {real} button_index Index of button in buttons array
function ui_trigger_button_hover_exit_feedback(button, button_index) {
    // Debug output
    show_debug_message("Button hover exit: " + (variable_struct_exists(button, "text") ? button.text : "Button " + string(button_index)));
    
    // Remove visual feedback
    if (variable_struct_exists(button, "hovered")) {
        button.hovered = false;
    }
    
    // TODO: Add hover exit sound effect when sound system is available
    // Could be a subtle sound or just silence
}

/// @function ui_create_hover_visual_effect(x, y)
/// @description Create visual effect for button hover
/// @param {real} x Effect x position
/// @param {real} y Effect y position
function ui_create_hover_visual_effect(x, y) {
    // Simple visual effect - could be enhanced with particles
    // For now, just store the effect position for drawing
    if (!variable_instance_exists(id, "hover_effects")) {
        hover_effects = [];
    }
    
    // Add hover effect that will fade over time
    array_push(hover_effects, {
        x: x,
        y: y,
        timer: 30, // Effect duration in frames
        alpha: 1.0
    });
    
    // Limit number of active effects
    if (array_length(hover_effects) > 10) {
        array_delete(hover_effects, 0, 1);
    }
}

/// @function ui_update_hover_effects()
/// @description Update and remove expired hover effects
function ui_update_hover_effects() {
    if (!variable_instance_exists(id, "hover_effects")) return;
    
    // Update each effect
    for (var i = array_length(hover_effects) - 1; i >= 0; i--) {
        var effect = hover_effects[i];
        effect.timer--;
        effect.alpha = effect.timer / 30; // Fade out
        
        // Remove expired effects
        if (effect.timer <= 0) {
            array_delete(hover_effects, i, 1);
        }
    }
}

/// @function ui_draw_hover_effects()
/// @description Draw all active hover effects
function ui_draw_hover_effects() {
    if (!variable_instance_exists(id, "hover_effects")) return;
    
    // Draw each active hover effect
    for (var i = 0; i < array_length(hover_effects); i++) {
        var effect = hover_effects[i];
        
        // Set alpha based on timer
        draw_set_alpha(effect.alpha);
        
        // Draw a subtle glow effect
        draw_set_color(c_yellow);
        var radius = 10 + (1 - effect.alpha) * 5; // Expand as it fades
        
        // Draw multiple circles for glow effect
        for (var j = 0; j < 3; j++) {
            var alpha_mult = (3 - j) / 6; // Weaker for outer circles
            draw_set_alpha(effect.alpha * alpha_mult);
            draw_circle(effect.x, effect.y, radius + j * 3, true);
        }
    }
    
    // Reset drawing settings
    draw_set_alpha(1);
    draw_set_color(c_white);
}
