// scr_ui_buttons.gml
// Button system for UI interactions

/// @function ui_button_create(x, y, width, height, text, callback)
// @description Create a new UI button
// @param {real} x Button x position
// @param {real} y Button y position
// @param {real} width Button width
// @param {real} height Button height
// @param {string} text Button text
// @param {function|string} callback Function to call when clicked
// @return {struct} Button struct
function ui_button_create(x, y, width, height, text, callback) {
    return {
        x: x,
        y: y,
        width: width,
        height: height,
        text: text,
        callback: callback,
        enabled: true,
        visible: true,
        hovered: false,
        pressed: false
    };
}

/// @function ui_button_draw(button)
// @description Draw a UI button
// @param {struct} button The button to draw
function ui_button_draw(button) {
    if (!button.visible) return;
    
    // Button background
    if (!button.enabled) {
        draw_set_color(UI_COLOR_BUTTON_NORMAL);
        draw_set_alpha(0.5);
    } else if (button.pressed) {
        draw_set_color(UI_COLOR_BUTTON_HOVER);
    } else if (button.hovered) {
        draw_set_color(UI_COLOR_BUTTON_HOVER);
    } else {
        draw_set_color(UI_COLOR_BUTTON_NORMAL);
    }
    
    draw_rectangle(button.x, button.y, button.x + button.width, button.y + button.height, false);
    draw_set_alpha(1);
    
    // Button border
    draw_set_color(UI_COLOR_BORDER);
    draw_rectangle(button.x, button.y, button.x + button.width, button.y + button.height, true);
    
    // Button text
    draw_set_color(UI_COLOR_TEXT);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button.x + button.width/2, button.y + button.height/2, button.text);
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @function ui_button_update(button, mouse_x, mouse_y, mouse_pressed)
// @description Update button state based on mouse input
// @param {struct} button The button to update
// @param {real} mouse_x Mouse x position
// @param {real} mouse_y Mouse y position
// @param {bool} mouse_pressed Whether mouse button is pressed
// @return {bool} True if button was clicked
function ui_button_update(button, mouse_x, mouse_y, mouse_pressed) {
    if (!button.visible || !button.enabled) {
        button.hovered = false;
        button.pressed = false;
        return false;
    }
    
    var _was_hovered = button.hovered;
    button.hovered = ui_is_point_in_rect(mouse_x, mouse_y, button.x, button.y, button.width, button.height);
    
    if (button.hovered && mouse_pressed) {
        button.pressed = true;
        return true; // Button clicked
    } else {
        button.pressed = false;
    }
    
    return false;
}

/// @function ui_button_set_position(button, x, y)
// @description Set button position
// @param {struct} button The button
// @param {real} x New x position
// @param {real} y New y position
function ui_button_set_position(button, x, y) {
    button.x = x;
    button.y = y;
}

/// @function ui_button_set_size(button, width, height)
// @description Set button size
// @param {struct} button The button
// @param {real} width New width
// @param {real} height New height
function ui_button_set_size(button, width, height) {
    button.width = width;
    button.height = height;
}

/// @function ui_button_set_text(button, text)
// @description Set button text
// @param {struct} button The button
// @param {string} text New text
function ui_button_set_text(button, text) {
    button.text = text;
}

/// @function ui_button_set_callback(button, callback)
// @description Set button callback
// @param {struct} button The button
// @param {function|string} callback New callback
function ui_button_set_callback(button, callback) {
    button.callback = callback;
}

/// @function ui_button_set_enabled(button, enabled)
// @description Enable or disable button
// @param {struct} button The button
// @param {bool} enabled Whether button should be enabled
function ui_button_set_enabled(button, enabled) {
    button.enabled = enabled;
}

/// @function ui_button_set_visible(button, visible)
// @description Show or hide button
// @param {struct} button The button
// @param {bool} visible Whether button should be visible
function ui_button_set_visible(button, visible) {
    button.visible = visible;
}

/// @function ui_button_execute_callback(button)
// @description Execute button callback
// @param {struct} button The button
function ui_button_execute_callback(button) {
    if (!button.enabled) return;
    
    if (is_method(button.callback)) {
        button.callback();
    } else if (is_string(button.callback)) {
        // Handle string callbacks (function names)
        switch (button.callback) {
            case "show_resources":
                ui_set_active_panel(UI_PANEL_RESOURCES);
                break;
            case "show_pets":
                ui_set_active_panel(UI_PANEL_PETS);
                break;
            case "show_shop":
                ui_set_active_panel(UI_PANEL_SHOP);
                break;
            case "show_crafting":
                ui_set_active_panel(UI_PANEL_CRAFTING);
                break;
            case "show_inventory":
                ui_set_active_panel(UI_PANEL_INVENTORY);
                break;
            default:
                show_debug_message("Unknown button callback: " + button.callback);
                break;
        }
    }
}

/// @function ui_button_array_create(x, y, button_data)
// @description Create an array of buttons from data
// @param {real} x Starting x position
// @param {real} y Starting y position
// @param {array} button_data Array of button data structs
// @return {array} Array of button structs
function ui_button_array_create(x, y, button_data) {
    var _buttons = [];
    var _current_x = x;
    var _current_y = y;
    
    for (var i = 0; i < array_length(button_data); i++) {
        var _data = button_data[i];
        var _button = ui_button_create(
            _current_x,
            _current_y,
            _data.width,
            _data.height,
            _data.text,
            _data.callback
        );
        
        array_push(_buttons, _button);
        
        // Position next button
        if (variable_struct_exists(_data, "next_x")) {
            _current_x = _data.next_x;
        } else {
            _current_x += _data.width + 10; // Default spacing
        }
        
        if (variable_struct_exists(_data, "next_y")) {
            _current_y = _data.next_y;
        }
    }
    
    return _buttons;
}

/// @function ui_button_array_draw(buttons)
// @description Draw an array of buttons
// @param {array} buttons Array of button structs
function ui_button_array_draw(buttons) {
    for (var i = 0; i < array_length(buttons); i++) {
        ui_button_draw(buttons[i]);
    }
}

/// @function ui_button_array_update(buttons, mouse_x, mouse_y, mouse_pressed)
// @description Update an array of buttons
// @param {array} buttons Array of button structs
// @param {real} mouse_x Mouse x position
// @param {real} mouse_y Mouse y position
// @param {bool} mouse_pressed Whether mouse button is pressed
function ui_button_array_update(buttons, mouse_x, mouse_y, mouse_pressed) {
    for (var i = 0; i < array_length(buttons); i++) {
        if (ui_button_update(buttons[i], mouse_x, mouse_y, mouse_pressed)) {
            ui_button_execute_callback(buttons[i]);
        }
    }
}

// === ENHANCED BUTTON CLICK DETECTION SYSTEM (T041) ===

/// @function ui_button_update_enhanced(button, mouse_x, mouse_y, mouse_pressed, mouse_released)
/// @description Enhanced button update with better click detection and feedback
/// @param {struct} button The button to update
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position  
/// @param {bool} mouse_pressed Whether mouse was just pressed this frame
/// @param {bool} mouse_released Whether mouse was just released this frame
/// @return {bool} True if button was clicked (released while over button)
function ui_button_update_enhanced(button, mouse_x, mouse_y, mouse_pressed, mouse_released) {
    if (!button.visible || !button.enabled) {
        button.hovered = false;
        button.pressed = false;
        return false;
    }
    
    var _was_hovered = button.hovered;
    var _was_pressed = button.pressed;
    
    // Check if mouse is over button
    button.hovered = ui_is_point_in_rect(mouse_x, mouse_y, button.x, button.y, button.width, button.height);
    
    // Handle mouse press
    if (button.hovered && mouse_pressed) {
        button.pressed = true;
        // Add feedback message for press
        if (script_exists(add_feedback_message)) {
            add_feedback_message("Button pressed: " + button.text, "action");
        }
        return false; // Don't trigger callback on press, wait for release
    }
    
    // Handle mouse release (actual click detection)
    if (button.pressed && mouse_released) {
        button.pressed = false;
        if (button.hovered) {
            // Successful click - mouse was pressed and released over button
            ui_button_trigger_click_feedback(button);
            return true;
        } else {
            // Click cancelled - mouse released outside button
            if (script_exists(add_feedback_message)) {
                add_feedback_message("Button click cancelled", "info");
            }
            return false;
        }
    }
    
    // Handle hover enter/exit
    if (button.hovered && !_was_hovered) {
        ui_button_trigger_hover_feedback(button);
    }
    
    return false;
}

/// @function ui_button_trigger_click_feedback(button)
/// @description Trigger feedback effects when button is clicked
/// @param {struct} button The button that was clicked
function ui_button_trigger_click_feedback(button) {
    // Visual feedback
    show_debug_message("Button clicked: " + button.text);
    
    // Add feedback message
    if (script_exists(add_feedback_message)) {
        add_feedback_message("Clicked: " + button.text, "success");
    }
    
    // TODO: Add sound effect when sound system is implemented
    // audio_play_sound(snd_button_click, 1, false);
    
    // Visual click effect (could be expanded with particles/animations)
    // This could trigger a brief flash or other visual effect
}

/// @function ui_button_trigger_hover_feedback(button)
/// @description Trigger feedback effects when button is hovered
/// @param {struct} button The button that was hovered
function ui_button_trigger_hover_feedback(button) {
    // Subtle feedback for hover
    show_debug_message("Button hovered: " + button.text);
    
    // TODO: Add hover sound when sound system is implemented
    // audio_play_sound(snd_button_hover, 1, false);
}

/// @function ui_button_array_update_enhanced(buttons, mouse_x, mouse_y, mouse_pressed, mouse_released)
/// @description Update an array of buttons with enhanced click detection
/// @param {array} buttons Array of button structs
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @param {bool} mouse_pressed Whether mouse was just pressed this frame
/// @param {bool} mouse_released Whether mouse was just released this frame
/// @return {struct|undefined} Button that was clicked, or undefined if none
function ui_button_array_update_enhanced(buttons, mouse_x, mouse_y, mouse_pressed, mouse_released) {
    for (var i = 0; i < array_length(buttons); i++) {
        if (ui_button_update_enhanced(buttons[i], mouse_x, mouse_y, mouse_pressed, mouse_released)) {
            ui_button_execute_callback(buttons[i]);
            return buttons[i]; // Return the clicked button
        }
    }
    return undefined; // No button was clicked
}

/// @function ui_button_get_clicked_button_id(buttons, mouse_x, mouse_y, mouse_released)
/// @description Get the ID/index of the clicked button in an array
/// @param {array} buttons Array of button structs
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position  
/// @param {bool} mouse_released Whether mouse was just released this frame
/// @return {real} Index of clicked button, or -1 if none clicked
function ui_button_get_clicked_button_id(buttons, mouse_x, mouse_y, mouse_released) {
    for (var i = 0; i < array_length(buttons); i++) {
        if (ui_button_update_enhanced(buttons[i], mouse_x, mouse_y, false, mouse_released)) {
            return i;
        }
    }
    return -1;
}

/// @function ui_trigger_button_hover_feedback(button, index)
// @description Trigger hover feedback for a button
// @param {struct} button The button struct
// @param {real} index The button index
function ui_trigger_button_hover_feedback(button, index) {
    button.hovered = true;
    // Add any additional hover feedback here (sounds, animations, etc.)
    show_debug_message("Button " + string(index) + " (" + button.text + ") hovered");
}

/// @function ui_trigger_button_hover_exit_feedback(button, index)
// @description Trigger hover exit feedback for a button  
// @param {struct} button The button struct
// @param {real} index The button index
function ui_trigger_button_hover_exit_feedback(button, index) {
    button.hovered = false;
    // Add any additional hover exit feedback here
}

/// @function ui_button_is_clicked(button, mouse_x, mouse_y, mouse_pressed)
// @description Check if a button is clicked
// @param {struct} button The button to check
// @param {real} mouse_x Mouse X position
// @param {real} mouse_y Mouse Y position
// @param {bool} mouse_pressed Whether mouse is pressed
// @return {bool} True if button is clicked
function ui_button_is_clicked(button, mouse_x, mouse_y, mouse_pressed) {
    if (!button.visible || !button.enabled) return false;
    
    var _in_bounds = (mouse_x >= button.x && mouse_x <= button.x + button.width &&
                      mouse_y >= button.y && mouse_y <= button.y + button.height);
    
    return _in_bounds && mouse_pressed;
}
