// Draw GUI Event - Game Interface
// Set default drawing settings
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

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
        break;
        
    case "help":
        // Draw help screen
        draw_text(20, 20, "=== CONTROLS ===");
        draw_text(20, 50, "T - Run test suite");
        draw_text(20, 70, "R - Reset game state");
        draw_text(20, 90, "S - Open pawn shop");
        draw_text(20, 110, "I - Show player status");
        draw_text(20, 130, "H - Show this help");
        draw_text(20, 150, "G - Full user guide");
        draw_text(20, 170, "Shop commands: buy <number>, sell <number>");
        draw_text(20, 190, "Note: Make sure to click on the game window first!");
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
            draw_text(20, _y + 60 + array_length(global.inventory) * 20, "Commands: buy <number>, sell <number>");
            draw_text(20, _y + 80 + array_length(global.inventory) * 20, "Note: Shop commands not yet implemented - use for browsing only");
        } else {
            draw_text(40, _y + 40, "Loading inventory...");
        }
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
