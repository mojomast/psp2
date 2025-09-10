/// @description Action Feedback Panel Functions
/// Specialized functions for displaying action feedback and notifications
/// Part of T031 - Action feedback panel functions

/// @function draw_feedback_panel(x, y, width, height, panel_data)
/// @description Draw the action feedback panel with recent notifications
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @param {struct} panel_data Additional panel configuration data
function draw_feedback_panel(x, y, width, height, panel_data) {
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
    draw_text(x + width/2, _content_y, "ACTIVITY LOG");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Get feedback data
    var feedback_data = get_feedback_panel_data();
    
    if (array_length(feedback_data.messages) == 0) {
        draw_text(x + 10, _content_y, "No recent activity");
        return;
    }
    
    // Draw recent messages (newest first)
    var message_height = 16;
    var spacing = 2;
    var max_messages = floor((height - 50) / (message_height + spacing));
    
    for (var i = 0; i < min(array_length(feedback_data.messages), max_messages); i++) {
        var message = feedback_data.messages[i];
        var message_y = _content_y + (i * (message_height + spacing));
        
        // Set color based on message type
        var message_color = get_feedback_message_color(message.type);
        draw_set_color(message_color);
        
        // Draw timestamp
        var time_text = format_feedback_timestamp(message.timestamp);
        draw_text(x + 5, message_y, time_text);
        
        // Draw message text (truncated if needed)
        var max_text_width = width - 60; // Account for timestamp
        var display_text = string_copy(message.text, 1, floor(max_text_width / 6)); // Rough character estimate
        draw_text(x + 55, message_y, display_text);
        
        // Draw type indicator
        var indicator_color = get_feedback_type_indicator_color(message.type);
        draw_set_color(indicator_color);
        draw_circle(x + width - 10, message_y + 8, 3, false);
    }
    
    draw_set_halign(fa_left);
}

/// @function get_feedback_panel_data()
/// @description Get current feedback/notification data for display
/// @return {struct} Feedback data structure
function get_feedback_panel_data() {
    // Check if feedback data exists in global scope
    if (variable_global_exists("feedback_messages")) {
        return {
            messages: global.feedback_messages,
            max_messages: variable_global_exists("max_feedback_messages") ? global.max_feedback_messages : 20
        };
    }
    
    // Return default feedback data if not initialized
    return {
        messages: [],
        max_messages: 20
    };
}

/// @function get_feedback_panel_layout(x, y, width, height)
/// @description Calculate layout positions for feedback panel elements
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @return {struct} Layout structure with positions
function get_feedback_panel_layout(x, y, width, height) {
    var message_height = 16;
    var spacing = 2;
    var max_visible_messages = floor((height - 50) / (message_height + spacing));
    
    return {
        panel_x: x,
        panel_y: y,
        panel_width: width,
        panel_height: height,
        title_x: x + width/2,
        title_y: y + 15,
        content_start_y: y + 45,
        message_height: message_height,
        spacing: spacing,
        max_visible_messages: max_visible_messages,
        timestamp_width: 50,
        indicator_x: x + width - 10
    };
}

/// @function update_feedback_panel_data()
/// @description Update feedback panel with latest data (called from UI controller)
/// @return {bool} True if update successful
function update_feedback_panel_data() {
    try {
        // Initialize feedback messages if they don't exist
        if (!variable_global_exists("feedback_messages")) {
            global.feedback_messages = [];
        }
        
        // Initialize max messages limit if it doesn't exist
        if (!variable_global_exists("max_feedback_messages")) {
            global.max_feedback_messages = 20;
        }
        
        // Clean up old messages if limit exceeded
        if (array_length(global.feedback_messages) > global.max_feedback_messages) {
            // Keep only the most recent messages
            var new_messages = [];
            var start_idx = array_length(global.feedback_messages) - global.max_feedback_messages;
            
            for (var i = start_idx; i < array_length(global.feedback_messages); i++) {
                array_push(new_messages, global.feedback_messages[i]);
            }
            
            global.feedback_messages = new_messages;
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating feedback panel data: " + string(error));
        return false;
    }
}

/// @function add_feedback_message(text, type)
/// @description Add a new message to the feedback system
/// @param {string} text Message text to display
/// @param {string} type Message type ("info", "success", "warning", "error", "action")
function add_feedback_message(text, type) {
    // Ensure feedback system is initialized
    update_feedback_panel_data();
    
    // Create new message
    var new_message = {
        text: text,
        type: type,
        timestamp: current_time
    };
    
    // Add to beginning of array (newest first)
    array_insert(global.feedback_messages, 0, new_message);
    
    // Debug output
    show_debug_message("[FEEDBACK " + string_upper(type) + "] " + text);
}

/// @function get_feedback_message_color(type)
/// @description Get color for feedback message based on type
/// @param {string} type Message type
/// @return {constant} Color constant for the message type
function get_feedback_message_color(type) {
    switch(type) {
        case "success": return c_green;
        case "error": return c_red;
        case "warning": return c_orange;
        case "action": return c_yellow;
        case "info": 
        default: return UI_COLOR_TEXT;
    }
}

/// @function get_feedback_type_indicator_color(type)
/// @description Get indicator color for feedback message type
/// @param {string} type Message type
/// @return {constant} Color constant for the type indicator
function get_feedback_type_indicator_color(type) {
    switch(type) {
        case "success": return c_lime;
        case "error": return c_red;
        case "warning": return c_orange;
        case "action": return c_aqua;
        case "info": 
        default: return c_white;
    }
}

/// @function format_feedback_timestamp(timestamp)
/// @description Format timestamp for display in feedback panel
/// @param {real} timestamp Game time when message was created
/// @return {string} Formatted timestamp string
function format_feedback_timestamp(timestamp) {
    var elapsed_ms = current_time - timestamp;
    var elapsed_seconds = floor(elapsed_ms / 1000);
    
    if (elapsed_seconds < 60) {
        return string(elapsed_seconds) + "s";
    } else if (elapsed_seconds < 3600) {
        var minutes = floor(elapsed_seconds / 60);
        return string(minutes) + "m";
    } else {
        var hours = floor(elapsed_seconds / 3600);
        return string(hours) + "h";
    }
}

/// @function feedback_panel_handle_click(x, y, mouse_x, mouse_y)
/// @description Handle mouse clicks in feedback panel area
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @return {bool} True if click was handled
function feedback_panel_handle_click(x, y, mouse_x, mouse_y) {
    // Feedback panel is display-only, but could be extended for:
    // - Click to clear messages
    // - Click to filter by message type
    // - Right-click for context menu
    
    // For now, just return false (no interaction)
    return false;
}

/// @function clear_feedback_messages()
/// @description Clear all feedback messages
function clear_feedback_messages() {
    if (variable_global_exists("feedback_messages")) {
        global.feedback_messages = [];
        add_feedback_message("Activity log cleared", "info");
    }
}
