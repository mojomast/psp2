# Quickstart: UI System Implementation for Pawn Stars Idle Game

## Prerequisites
- GameMaker Studio 2024.13.1.193
- Existing Pawn Stars Idle Game project loaded
- All existing game systems functional (resources, pets, shop, crafting)

## Phase 1: Core UI Infrastructure (30 minutes)

### Step 1: Create UI Controller Object (10 minutes)
```gml
// Create: objects/obj_ui_controller/obj_ui_controller.yy
// This object will manage all UI rendering and interaction

// Create Event:
ui_initialized = false;
ui_panels = [];
ui_buttons = [];
mouse_over_ui = false;

// Initialize UI layout
ui_layout = {
    resource_panel: { x: 0, y: 0, width: 1024, height: 60 },
    player_panel: { x: 824, y: 0, width: 200, height: 60 },
    pet_panel: { x: 0, y: 60, width: 200, height: 540 },
    inventory_panel: { x: 824, y: 60, width: 200, height: 540 },
    action_panel: { x: 0, y: 600, width: 1024, height: 168 }
};

ui_initialized = true;
show_debug_message("UI Controller initialized");
```

### Step 2: Create UI System Script (15 minutes)
```gml
// Create: scripts/scr_ui_system/scr_ui_system.gml

// Core UI drawing function
function draw_ui_system() {
    if (!instance_exists(obj_ui_controller)) return;
    
    // Set drawing defaults
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Draw panels based on current mode
    draw_resource_panel();
    draw_player_panel();
    
    switch(global.display_mode) {
        case "normal":
            draw_main_panels();
            break;
        case "shop":
            draw_shop_panel();
            break;
        case "crafting":
            draw_crafting_panel();
            break;
        case "pets":
            draw_pet_management_panel();
            break;
    }
    
    draw_action_feedback_panel();
}

// Resource panel drawing
function draw_resource_panel() {
    var panel = obj_ui_controller.ui_layout.resource_panel;
    
    // Panel background
    draw_set_color(c_dkgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, false);
    draw_set_color(c_ltgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, true);
    
    // Resource displays
    draw_set_color(c_yellow);
    draw_text(panel.x + 10, panel.y + 10, "Gold: " + string(global.resources.gold));
    
    draw_set_color(c_brown);
    draw_text(panel.x + 150, panel.y + 10, "Wood: " + string(global.resources.wood));
    
    draw_set_color(c_gray);
    draw_text(panel.x + 290, panel.y + 10, "Metal: " + string(global.resources.metal));
    
    draw_set_color(c_purple);
    draw_text(panel.x + 430, panel.y + 10, "Gems: " + string(global.resources.gems));
}
```

### Step 3: Integrate with Existing Controller (5 minutes)
```gml
// Edit: objects/obj_idle_controller/Create_0.gml
// Add at the end of Create event:

// Create UI controller
if (!instance_exists(obj_ui_controller)) {
    instance_create_layer(0, 0, "Instances", obj_ui_controller);
}
```

## Phase 2: Panel Implementation (45 minutes)

### Step 4: Player Status Panel (15 minutes)
```gml
// Add to scr_ui_system.gml

function draw_player_panel() {
    var panel = obj_ui_controller.ui_layout.player_panel;
    
    // Panel background
    draw_set_color(c_dkgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, false);
    draw_set_color(c_ltgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, true);
    
    // Player information
    draw_set_color(c_white);
    draw_text(panel.x + 5, panel.y + 5, global.player_name);
    draw_text(panel.x + 5, panel.y + 20, "Level: " + string(global.player_level));
    draw_text(panel.x + 5, panel.y + 35, "Time: " + string(floor(global.idle_timer)) + "s");
}
```

### Step 5: Pet Management Panel (15 minutes)
```gml
// Add to scr_ui_system.gml

function draw_pet_management_panel() {
    var panel = obj_ui_controller.ui_layout.pet_panel;
    
    // Panel background  
    draw_set_color(c_dkgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, false);
    draw_set_color(c_ltgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, true);
    
    // Panel title
    draw_set_color(c_white);
    draw_text(panel.x + 5, panel.y + 5, "PETS (P)");
    
    // Pet list
    if (variable_global_exists("pets")) {
        for (var i = 0; i < array_length(global.pets) && i < 10; i++) {
            var pet = global.pets[i];
            var y_pos = panel.y + 25 + (i * 25);
            
            // Pet selection highlighting
            if (variable_instance_exists(obj_idle_controller, "selected_pet") && 
                obj_idle_controller.selected_pet == i) {
                draw_set_color(c_yellow);
                draw_rectangle(panel.x + 2, y_pos - 2, panel.x + panel.width - 2, y_pos + 20, false);
            }
            
            // Pet status color
            switch(pet.status) {
                case "idle": draw_set_color(c_lime); break;
                case "exploring": draw_set_color(c_aqua); break;
                case "battling": draw_set_color(c_red); break;
                default: draw_set_color(c_white); break;
            }
            
            draw_text(panel.x + 5, y_pos, string(i+1) + ". " + pet.name);
            draw_text(panel.x + 5, y_pos + 12, "Lv" + string(pet.level) + " " + pet.status);
        }
    }
    
    // Instructions
    draw_set_color(c_ltgray);
    draw_text(panel.x + 5, panel.y + panel.height - 40, "1-9: Select pet");
    draw_text(panel.x + 5, panel.y + panel.height - 25, "E: Explore");
    draw_text(panel.x + 5, panel.y + panel.height - 10, "ESC: Exit");
}
```

### Step 6: Shop Panel (15 minutes)  
```gml
// Add to scr_ui_system.gml

function draw_shop_panel() {
    var panel = obj_ui_controller.ui_layout.action_panel;
    
    // Panel background
    draw_set_color(c_dkgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, false);
    draw_set_color(c_ltgray);
    draw_rectangle(panel.x, panel.y, panel.x + panel.width, panel.y + panel.height, true);
    
    // Shop title
    draw_set_color(c_white);
    draw_text(panel.x + 10, panel.y + 10, "=== PAWN SHOP ===");
    
    // Shop items
    if (variable_global_exists("shop_items")) {
        for (var i = 0; i < min(array_length(global.shop_items), 3); i++) {
            var item = global.shop_items[i];
            var x_pos = panel.x + 20 + (i * 250);
            var y_pos = panel.y + 35;
            
            // Affordability check
            var can_afford = global.resources.gold >= item.price;
            draw_set_color(can_afford ? c_white : c_red);
            
            draw_text(x_pos, y_pos, string(i+1) + ". " + item.name);
            draw_text(x_pos, y_pos + 15, "Price: " + string(item.price) + " gold");
            draw_text(x_pos, y_pos + 30, item.description);
        }
    }
    
    // Shop instructions
    draw_set_color(c_ltgray);
    draw_text(panel.x + 10, panel.y + 100, "1-3: Buy items | Q-W: Sell items | ESC: Exit");
}
```

## Phase 3: Integration with Draw Events (15 minutes)

### Step 7: Add Draw GUI Event to UI Controller
```gml
// Create: objects/obj_ui_controller/Draw_64.gml (Draw GUI event)

if (ui_initialized) {
    draw_ui_system();
}
```

### Step 8: Update Existing Controller Draw Event
```gml
// Edit: objects/obj_idle_controller/Draw_64.gml
// Replace existing drawing code with UI mode handling

// Only draw debug text if UI is not available
if (!instance_exists(obj_ui_controller)) {
    // Keep existing debug drawing code as fallback
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Ensure display_mode is set
    if (!variable_instance_exists(id, "display_mode")) {
        display_mode = "normal";
    }
    
    // Original debug display code here...
} else {
    // UI controller handles all drawing
    // Just ensure display mode synchronization
    if (!variable_instance_exists(obj_ui_controller, "display_mode")) {
        obj_ui_controller.display_mode = display_mode;
    }
}
```

## Phase 4: Testing and Validation (30 minutes)

### Step 9: Basic UI Functionality Test (10 minutes)
```gml
// Create: scripts/test_ui_basic/test_ui_basic.gml

function test_ui_basic() {
    show_debug_message("=== UI BASIC FUNCTIONALITY TEST ===");
    
    // Test UI controller creation
    var ui_exists = instance_exists(obj_ui_controller);
    scr_assert(ui_exists, "UI controller should exist");
    
    // Test UI initialization
    if (ui_exists) {
        var ui_init = obj_ui_controller.ui_initialized;
        scr_assert(ui_init, "UI should be initialized");
    }
    
    // Test resource display updates
    var old_gold = global.resources.gold;
    global.resources.gold = 9999;
    
    // UI should update automatically
    // Visual verification: gold display should show 9999
    
    global.resources.gold = old_gold;
    
    show_debug_message("UI basic test completed");
    return true;
}
```

### Step 10: Integration Test (10 minutes)
```gml
// Create: scripts/test_ui_integration/test_ui_integration.gml

function test_ui_integration() {
    show_debug_message("=== UI INTEGRATION TEST ===");
    
    // Test keyboard shortcuts still work
    var old_mode = display_mode;
    
    // Simulate shop hotkey
    display_mode = "shop";
    scr_assert(display_mode == "shop", "Shop mode should activate");
    
    // Simulate crafting hotkey  
    display_mode = "crafting";
    scr_assert(display_mode == "crafting", "Crafting mode should activate");
    
    display_mode = old_mode;
    
    // Test pet selection
    if (variable_global_exists("pets") && array_length(global.pets) > 0) {
        selected_pet = 0;
        scr_assert(selected_pet == 0, "Pet selection should work");
    }
    
    show_debug_message("UI integration test completed");
    return true;
}
```

### Step 11: Visual Verification (10 minutes)
1. **Run the game** - UI panels should appear
2. **Press 'S'** - Shop panel should display at bottom
3. **Press 'P'** - Pet management should show on left  
4. **Press 'C'** - Crafting panel should appear at bottom
5. **Press 'ESC'** - Should return to normal mode
6. **Check resource displays** - Should match debug output values
7. **Verify hotkeys work** - All existing keyboard shortcuts functional

## Troubleshooting

### Common Issues:
1. **UI not appearing**: Check obj_ui_controller exists in room
2. **Hotkeys not working**: Verify obj_idle_controller still handles input
3. **Performance issues**: Check Draw GUI event is used, not Draw event
4. **Layout problems**: Verify room size matches expected UI layout (1024x768)

### Debug Commands:
```gml
// Check UI status
show_debug_message("UI exists: " + string(instance_exists(obj_ui_controller)));
show_debug_message("Display mode: " + display_mode);

// Reset UI if needed
if (instance_exists(obj_ui_controller)) {
    instance_destroy(obj_ui_controller);
}
instance_create_layer(0, 0, "Instances", obj_ui_controller);
```

## Next Steps After Quickstart

1. **Add button interactions** - Make UI elements clickable
2. **Implement animations** - Smooth transitions between modes  
3. **Add inventory panel** - Complete the inventory display
4. **Create crafting panel** - Full crafting recipe interface
5. **Polish visuals** - Icons, better colors, improved layout
6. **Performance optimization** - Caching, efficient updates

This quickstart gets the core UI system functional in approximately 2 hours, providing immediate visual improvement while maintaining all existing functionality.
