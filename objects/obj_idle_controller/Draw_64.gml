// Draw GUI Event - Game Interface
// Set default drawing settings
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Check if UI controller exists and is handling display
var _ui_exists = instance_exists(obj_ui_controller);
var _ui_visible = false;
if (_ui_exists && variable_instance_exists(obj_ui_controller, "ui_visible")) {
    _ui_visible = obj_ui_controller.ui_visible;
}

// If UI is visible, let it handle the display instead of drawing legacy UI
if (_ui_visible) {
    // Draw minimal debug info when UI is active
    draw_set_color(c_white);
    draw_set_alpha(0.5);
    draw_text(10, display_get_gui_height() - 20, "Press Tab to toggle UI | ESC for debug");
    draw_set_alpha(1);
    return;
}

// Ensure display_mode is set
if (!variable_instance_exists(id, "display_mode")) {
    display_mode = "normal";
}

// Draw based on display mode
switch (display_mode) {
    case "normal":
        // Draw main game status
        draw_text(20, 20, "=== PAWN STARS IDLE GAME ===");
        
        // Check if global variables exist before drawing
        if (variable_global_exists("idle_timer")) {
            draw_text(20, 50, "Time played: " + string(floor(global.idle_timer)) + " seconds");
        } else {
            draw_text(20, 50, "Time played: Loading...");
        }
        
        draw_text(20, 80, "Resources:");
        if (variable_global_exists("resources")) {
            draw_text(40, 100, "Gold: " + string_format(global.resources.gold, 0, 2));
            draw_text(40, 120, "Wood: " + string_format(global.resources.wood, 0, 2));
            draw_text(40, 140, "Metal: " + string_format(global.resources.metal, 0, 2));
            draw_text(40, 160, "Gems: " + string_format(global.resources.gems, 0, 2));
        } else {
            draw_text(40, 100, "Loading resources...");
        }
        
        if (variable_global_exists("pets")) {
            draw_text(20, 190, "Active pets: " + string(array_length(global.pets)));
        } else {
            draw_text(20, 190, "Active pets: Loading...");
        }
        
    draw_text(20, 220, "💡 Press H for help, S for shop, I for status");
    // Compact on-screen controls summary so players see key bindings immediately
    draw_text(20, 250, "Controls: T-tests  R-reset  S-shop  I-status  C-craft  P-pets  H-help  G-guide");
    draw_text(20, 270, "Shop shortcuts: 1-3 buy  |  Q-W sell  |  ESC exit (when in shop)");
    draw_text(20, 290, "Crafting: 1-8 craft  |  ESC exit (when in crafting)");
    draw_text(20, 310, "Pet management: 1-9 select  |  E explore  |  ESC exit (when in pets)");
    draw_text(20, 330, "Note: Click the game window to ensure the keyboard is focused.");
    break;
        
    case "help":
        // Draw help screen
        draw_text(20, 20, "=== CONTROLS ===");
        draw_text(20, 50, "T - Run test suite");
        draw_text(20, 70, "R - Reset game state");
        draw_text(20, 90, "S - Open pawn shop");
        draw_text(20, 110, "I - Show player status");
        draw_text(20, 130, "C - Open crafting system");
        draw_text(20, 150, "P - Manage pets");
        draw_text(20, 170, "H - Show this help");
        draw_text(20, 190, "G - Full user guide");
        draw_text(20, 210, "");
        draw_text(20, 230, "=== SHOP SHORTCUTS (when in shop) ===");
        draw_text(20, 250, "1-3 - Buy items 0-2");
        draw_text(20, 270, "Q-W - Sell items 0-1");
        draw_text(20, 290, "ESC - Exit shop");
        draw_text(20, 310, "");
        draw_text(20, 330, "=== CRAFTING SHORTCUTS (when in crafting) ===");
        draw_text(20, 350, "1-8 - Craft items 0-7");
        draw_text(20, 370, "ESC - Exit crafting");
        draw_text(20, 390, "");
        draw_text(20, 410, "=== PET SHORTCUTS (when in pets) ===");
        draw_text(20, 430, "1-9 - Select pet 0-8");
        draw_text(20, 450, "E - Explore with selected pet");
        draw_text(20, 470, "ESC - Exit pets");
        draw_text(20, 490, "");
        draw_text(20, 510, "Note: Make sure to click on the game window first!");
        break;
        
    case "status":
        // Draw detailed status
        draw_text(20, 20, "=== PLAYER STATUS ===");
        
        if (variable_global_exists("player_name")) {
            draw_text(20, 50, "Name: " + global.player_name);
            draw_text(20, 70, "Level: " + string(global.player_level));
            draw_text(20, 90, "Experience: " + string(global.player_experience));
        } else {
            draw_text(20, 50, "Player data loading...");
        }
        
        draw_text(20, 110, "Resources:");
        if (variable_global_exists("resources")) {
            draw_text(40, 130, "Gold: " + string_format(global.resources.gold, 0, 2));
            draw_text(40, 150, "Wood: " + string_format(global.resources.wood, 0, 2));
            draw_text(40, 170, "Metal: " + string_format(global.resources.metal, 0, 2));
            draw_text(40, 190, "Gems: " + string_format(global.resources.gems, 0, 2));
        } else {
            draw_text(40, 130, "Loading resources...");
        }
        
        if (variable_global_exists("pets") && variable_global_exists("inventory") && variable_global_exists("pokemon_cards")) {
            draw_text(20, 210, "Pets: " + string(array_length(global.pets)));
            draw_text(20, 230, "Inventory: " + string(array_length(global.inventory)));
            draw_text(20, 250, "Pokemon Cards: " + string(array_length(global.pokemon_cards)));
        } else {
            draw_text(20, 210, "Loading game data...");
        }
        break;
        
    case "shop":
        // Draw shop interface
        draw_text(20, 20, "=== PAWN SHOP ===");
        
        if (variable_global_exists("resources")) {
            draw_text(20, 50, "Gold: " + string_format(global.resources.gold, 0, 2));
        } else {
            draw_text(20, 50, "Gold: Loading...");
        }
        
        draw_text(20, 80, "Items for sale:");
        var _y = 100;
        
        if (variable_global_exists("shop_items")) {
            for (var i = 0; i < array_length(global.shop_items); i++) {
                var _item = global.shop_items[i];
                draw_text(40, _y, string(i) + ". " + _item.name + " - " + string(_item.price) + " gold");
                draw_text(60, _y + 20, _item.description);
                _y += 50;
            }
        } else {
            draw_text(40, _y, "Loading shop items...");
            _y += 30;
        }
        
        draw_text(20, _y + 20, "Your inventory:");
        if (variable_global_exists("inventory")) {
            if (array_length(global.inventory) == 0) {
                draw_text(40, _y + 40, "Empty");
            } else {
                for (var j = 0; j < array_length(global.inventory); j++) {
                    var _inv_item = global.inventory[j];
                    draw_text(40, _y + 40 + j * 20, string(j) + ". " + _inv_item.name + " (Sell for 25 gold)");
                }
            }
            draw_text(20, _y + 60 + array_length(global.inventory) * 20, "Press 1-3 to buy, Q-W to sell, ESC to exit");
        } else {
            draw_text(40, _y + 40, "Loading inventory...");
        }
        break;
        
    case "crafting":
        // Draw crafting interface
        draw_text(20, 20, "=== CRAFTING SYSTEM ===");
        
        draw_text(20, 50, "Recipes:");
        var _y = 70;
        
        var _recipes = get_crafting_recipes();
        for (var i = 0; i < array_length(_recipes); i++) {
            var _recipe = _recipes[i];
            draw_text(40, _y, string(i) + ". " + _recipe.name);
            draw_text(60, _y + 20, "Requirements: " + json_stringify(_recipe.requirements));
            draw_text(60, _y + 40, "Result: " + _recipe.result);
            _y += 70;
        }
        
        draw_text(20, _y + 20, "Press 1-8 to craft, ESC to exit");
        break;
        
    case "pets":
        // Draw pet management interface
        draw_text(20, 20, "=== PET MANAGEMENT ===");
        
        draw_text(20, 50, "Your pets:");
        var _y = 70;
        
        if (variable_global_exists("pets")) {
            for (var i = 0; i < array_length(global.pets); i++) {
                var _pet = global.pets[i];
                draw_text(40, _y, string(i) + ". " + _pet.name + " (" + _pet.type + ") - Level " + string(_pet.level));
                draw_text(60, _y + 20, "Status: " + _pet.status);
                _y += 50;
            }
        } else {
            draw_text(40, _y, "No pets found");
            _y += 30;
        }
        
        draw_text(20, _y + 20, "Press 1-9 to select pet, E to explore, ESC to exit");
        break;
        
    case "guide":
        // Draw user guide (first part - can be scrollable later)
        draw_text(20, 20, "=== PAWN STARS IDLE GAME - USER GUIDE ===");
        draw_text(20, 50, "🎯 WELCOME TO PAWN STARS IDLE!");
        draw_text(20, 70, "Your journey as a pawn shop owner begins here.");
        draw_text(20, 90, "Build your empire through idle resource gathering,");
        draw_text(20, 110, "pet exploration, crafting, and trading!");
        draw_text(20, 140, "🎮 GETTING STARTED");
        draw_text(20, 160, "• Click on the game window to focus it");
        draw_text(20, 180, "• Press H for help, S for shop, I for status");
        draw_text(20, 200, "• Resources accumulate automatically over time");
        draw_text(20, 220, "• Your pet 'Buddy' is ready for adventure!");
        draw_text(20, 250, "⌨️ CONTROLS");
        draw_text(20, 270, "T - Run test suite (developer mode)");
        draw_text(20, 290, "R - Reset game to starting state");
        draw_text(20, 310, "S - Open pawn shop (browse items)");
        draw_text(20, 330, "I - Show detailed player status");
        draw_text(20, 350, "H - Show this help");
        draw_text(20, 370, "G - Full user guide");
        break;
        
    default:
        // Fallback
        draw_text(20, 20, "Unknown display mode: " + string(display_mode));
        draw_text(20, 50, "Press H for help");
        break;
}
