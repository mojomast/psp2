/// @description Crafting Panel Functions
/// Specialized functions for crafting panel display and recipe management
/// Part of T030 - Crafting panel functions

/// @function draw_crafting_panel(x, y, width, height, panel_data)
/// @description Draw the crafting panel with available recipes
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @param {struct} panel_data Additional panel configuration data
function draw_crafting_panel(x, y, width, height, panel_data) {
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
    draw_text(x + width/2, _content_y, "CRAFTING");
    _content_y += 30;
    
    draw_set_halign(fa_left);
    
    // Get crafting data
    var crafting_data = get_crafting_panel_data();
    
    if (array_length(crafting_data.recipes) == 0) {
        draw_text(x + 10, _content_y, "No recipes available");
        return;
    }
    
    // Draw recipes list
    var recipe_height = 50;
    var spacing = 5;
    
    for (var i = 0; i < array_length(crafting_data.recipes); i++) {
        var recipe = crafting_data.recipes[i];
        var recipe_y = _content_y + (i * (recipe_height + spacing));
        
        // Skip if recipe would be outside panel
        if (recipe_y + recipe_height > y + height - 10) {
            break;
        }
        
        // Draw recipe background (highlight if selected)
        var bg_color = (recipe.id == crafting_data.selected_recipe_id) ? UI_COLOR_SELECTED : UI_COLOR_SLOT_BG;
        draw_set_color(bg_color);
        draw_rectangle(x + 5, recipe_y, x + width - 5, recipe_y + recipe_height, false);
        
        // Draw recipe border
        draw_set_color(UI_COLOR_BORDER);
        draw_rectangle(x + 5, recipe_y, x + width - 5, recipe_y + recipe_height, true);
        
        // Draw recipe name
        draw_set_color(UI_COLOR_TEXT);
        draw_text(x + 10, recipe_y + 8, recipe.name);
        
        // Draw requirements
        var req_text = "";
        for (var j = 0; j < array_length(recipe.requirements); j++) {
            var req = recipe.requirements[j];
            if (j > 0) req_text += ", ";
            req_text += req.name + " x" + string(req.quantity);
        }
        
        draw_set_color(c_gray);
        draw_text(x + 10, recipe_y + 24, req_text);
        
        // Draw craftability indicator
        var can_craft = check_recipe_craftable(recipe);
        var craft_color = can_craft ? c_green : c_red;
        draw_set_color(craft_color);
        draw_circle(x + width - 15, recipe_y + 25, 4, false);
        
        // Draw result item on right
        draw_set_color(UI_COLOR_TEXT);
        draw_set_halign(fa_right);
        draw_text(x + width - 25, recipe_y + 8, "→ " + recipe.result.name);
        draw_set_halign(fa_left);
    }
    
    // Draw crafting controls at bottom if space available
    var controls_y = y + height - 25;
    if (controls_y > _content_y + (array_length(crafting_data.recipes) * (recipe_height + spacing))) {
        draw_set_color(UI_COLOR_TEXT);
        draw_set_halign(fa_center);
        draw_text(x + width/2, controls_y, "Click recipe to select, press C to craft");
        draw_set_halign(fa_left);
    }
}

/// @function get_crafting_panel_data()
/// @description Get current crafting data for display
/// @return {struct} Crafting data structure
function get_crafting_panel_data() {
    // Check if crafting data exists in global scope
    if (variable_global_exists("crafting_recipes")) {
        return {
            recipes: global.crafting_recipes,
            selected_recipe_id: variable_global_exists("selected_recipe_id") ? global.selected_recipe_id : -1,
            unlocked_recipes: variable_global_exists("unlocked_recipes") ? global.unlocked_recipes : []
        };
    }
    
    // Return default crafting data if not initialized
    return {
        recipes: get_default_crafting_recipes(),
        selected_recipe_id: -1,
        unlocked_recipes: [1, 2, 3] // Default unlocked recipes
    };
}

/// @function get_default_crafting_recipes()
/// @description Get default crafting recipes for initialization
/// @return {array} Array of default crafting recipes
function get_default_crafting_recipes() {
    return [
        {
            id: 1,
            name: "Wooden Sword",
            requirements: [
                { name: "Wood", quantity: 3 },
                { name: "Stone", quantity: 1 }
            ],
            result: { name: "Wooden Sword", quantity: 1 },
            unlock_level: 1
        },
        {
            id: 2,
            name: "Health Potion",
            requirements: [
                { name: "Herbs", quantity: 2 },
                { name: "Water", quantity: 1 }
            ],
            result: { name: "Health Potion", quantity: 1 },
            unlock_level: 1
        },
        {
            id: 3,
            name: "Stone Axe",
            requirements: [
                { name: "Wood", quantity: 2 },
                { name: "Stone", quantity: 2 }
            ],
            result: { name: "Stone Axe", quantity: 1 },
            unlock_level: 2
        }
    ];
}

/// @function get_crafting_panel_layout(x, y, width, height)
/// @description Calculate layout positions for crafting panel elements
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} width Panel width
/// @param {real} height Panel height
/// @return {struct} Layout structure with positions
function get_crafting_panel_layout(x, y, width, height) {
    var recipe_height = 50;
    var spacing = 5;
    var max_visible_recipes = floor((height - 70) / (recipe_height + spacing)); // Account for title and controls
    
    return {
        panel_x: x,
        panel_y: y,
        panel_width: width,
        panel_height: height,
        title_x: x + width/2,
        title_y: y + 15,
        content_start_y: y + 45,
        recipe_height: recipe_height,
        spacing: spacing,
        max_visible_recipes: max_visible_recipes,
        controls_y: y + height - 25
    };
}

/// @function update_crafting_panel_data()
/// @description Update crafting panel with latest data (called from UI controller)
/// @return {bool} True if update successful
function update_crafting_panel_data() {
    try {
        // Initialize crafting recipes if they don't exist
        if (!variable_global_exists("crafting_recipes")) {
            global.crafting_recipes = get_default_crafting_recipes();
        }
        
        // Initialize selected recipe id if it doesn't exist
        if (!variable_global_exists("selected_recipe_id")) {
            global.selected_recipe_id = -1;
        }
        
        // Initialize unlocked recipes if they don't exist
        if (!variable_global_exists("unlocked_recipes")) {
            global.unlocked_recipes = [1, 2, 3]; // Default unlocked recipes
        }
        
        return true;
    } catch(error) {
        show_debug_message("Error updating crafting panel data: " + string(error));
        return false;
    }
}

/// @function crafting_panel_handle_click(x, y, mouse_x, mouse_y)
/// @description Handle mouse clicks in crafting panel area for recipe selection
/// @param {real} x Panel x position
/// @param {real} y Panel y position
/// @param {real} mouse_x Mouse x position
/// @param {real} mouse_y Mouse y position
/// @return {bool} True if click was handled
function crafting_panel_handle_click(x, y, mouse_x, mouse_y) {
    var crafting_data = get_crafting_panel_data();
    
    if (array_length(crafting_data.recipes) == 0) {
        return false;
    }
    
    var layout = get_crafting_panel_layout(x, y, 300, 200); // Default size for click detection
    var content_y = layout.content_start_y;
    
    // Check each recipe for clicks
    for (var i = 0; i < array_length(crafting_data.recipes); i++) {
        var recipe_y = content_y + (i * (layout.recipe_height + layout.spacing));
        
        // Skip if recipe would be outside visible area
        if (recipe_y + layout.recipe_height > y + layout.panel_height - 30) {
            break;
        }
        
        // Check if click is within this recipe
        if (mouse_x >= x + 5 && mouse_x <= x + layout.panel_width - 5 &&
            mouse_y >= recipe_y && mouse_y <= recipe_y + layout.recipe_height) {
            
            // Select this recipe
            global.selected_recipe_id = crafting_data.recipes[i].id;
            show_debug_message("Selected recipe: " + crafting_data.recipes[i].name);
            return true;
        }
    }
    
    return false;
}

/// @function get_selected_recipe_data()
/// @description Get data for currently selected crafting recipe
/// @return {struct|undefined} Selected recipe data or undefined if none selected
function get_selected_recipe_data() {
    var crafting_data = get_crafting_panel_data();
    
    if (crafting_data.selected_recipe_id == -1) {
        return undefined;
    }
    
    // Find recipe with selected ID
    for (var i = 0; i < array_length(crafting_data.recipes); i++) {
        if (crafting_data.recipes[i].id == crafting_data.selected_recipe_id) {
            return crafting_data.recipes[i];
        }
    }
    
    return undefined;
}

/// @function check_recipe_craftable(recipe)
/// @description Check if a recipe can be crafted with current resources
/// @param {struct} recipe Recipe to check
/// @return {bool} True if recipe can be crafted
function check_recipe_craftable(recipe) {
    if (!variable_global_exists("resources")) {
        return false;
    }
    
    // Check each requirement
    for (var i = 0; i < array_length(recipe.requirements); i++) {
        var req = recipe.requirements[i];
        var resource_key = string_lower(req.name);
        
        if (!variable_struct_exists(global.resources, resource_key)) {
            return false;
        }
        
        if (variable_struct_get(global.resources, resource_key) < req.quantity) {
            return false;
        }
    }
    
    return true;
}

/// @function craft_selected_recipe()
/// @description Attempt to craft the currently selected recipe
/// @return {bool} True if crafting successful
function craft_selected_recipe() {
    var recipe = get_selected_recipe_data();
    
    if (recipe == undefined) {
        show_debug_message("No recipe selected for crafting");
        return false;
    }
    
    if (!check_recipe_craftable(recipe)) {
        show_debug_message("Cannot craft " + recipe.name + " - insufficient resources");
        return false;
    }
    
    // Consume resources
    for (var i = 0; i < array_length(recipe.requirements); i++) {
        var req = recipe.requirements[i];
        var resource_key = string_lower(req.name);
        var current_amount = variable_struct_get(global.resources, resource_key);
        variable_struct_set(global.resources, resource_key, current_amount - req.quantity);
    }
    
    // Add result to inventory (simplified - assumes inventory system exists)
    if (variable_global_exists("inventory")) {
        array_push(global.inventory, {
            id: recipe.result.id || recipe.id + 100, // Generate unique ID
            name: recipe.result.name,
            type: "crafted",
            quantity: recipe.result.quantity,
            rarity: "common"
        });
    }
    
    show_debug_message("Crafted " + recipe.result.name + " x" + string(recipe.result.quantity));
    return true;
}
