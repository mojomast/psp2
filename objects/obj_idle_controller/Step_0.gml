// Step Event - Handle input and update game state

// Auto-return to normal mode after 5 seconds
if (display_mode != "normal" && current_time - last_key_time > 5000) {
    display_mode = "normal";
}

// Manual test runner
if (keyboard_check_pressed(ord("T"))) {
    show_debug_message("=== RUNNING TEST SUITE ===");
    run_all_tests();
    display_mode = "normal";
    last_key_time = current_time;
}

// Reset game state
if (keyboard_check_pressed(ord("R"))) {
    show_debug_message("=== RESETTING GAME STATE ===");
    file_delete("savegame.json");
    game_restart();
}

// Display help
if (keyboard_check_pressed(ord("H"))) {
    show_debug_message("=== CONTROLS ===");
    show_debug_message("T - Run tests");
    show_debug_message("R - Reset game");
    show_debug_message("S - Open shop");
    show_debug_message("I - Show status");
    show_debug_message("H - Show this help");
    show_debug_message("G - Full user guide");
    show_debug_message("Shop commands: buy <number>, sell <number>");
    show_debug_message("Note: Make sure to click on the game window first!");
    display_mode = "help";
    last_key_time = current_time;
}

// Display full user guide
if (keyboard_check_pressed(ord("G"))) {
    display_mode = "guide";
    last_key_time = current_time;
}

// Display shop
if (keyboard_check_pressed(ord("S"))) {
    show_debug_message("=== PAWN SHOP ===");
    
    if (variable_global_exists("resources")) {
        show_debug_message("Gold: " + string(global.resources.gold));
    } else {
        show_debug_message("Gold: Loading...");
    }
    
    show_debug_message("");
    show_debug_message("Items for sale:");
    
    if (variable_global_exists("shop_items")) {
        for (var i = 0; i < array_length(global.shop_items); i++) {
            var _item = global.shop_items[i];
            show_debug_message(string(i) + ". " + _item.name + " - " + string(_item.price) + " gold");
            show_debug_message("   " + _item.description);
        }
    } else {
        show_debug_message("Shop items loading...");
    }
    
    show_debug_message("");
    show_debug_message("Your inventory:");
    if (variable_global_exists("inventory")) {
        if (array_length(global.inventory) == 0) {
            show_debug_message("Empty");
        } else {
            for (var j = 0; j < array_length(global.inventory); j++) {
                var _inv_item = global.inventory[j];
                show_debug_message(string(j) + ". " + _inv_item.name + " (Sell for " + string(25) + " gold)");
            }
        }
    } else {
        show_debug_message("Inventory loading...");
    }
    
    show_debug_message("");
    show_debug_message("Commands: buy <number>, sell <number>");
    show_debug_message("Note: Shop commands not yet implemented - use for browsing only");
    display_mode = "shop";
    last_key_time = current_time;
}

// Display status
if (keyboard_check_pressed(ord("I"))) {
    show_debug_message("=== PLAYER STATUS ===");
    
    if (variable_global_exists("player_name")) {
        show_debug_message("Name: " + global.player_name);
        show_debug_message("Level: " + string(global.player_level));
        show_debug_message("Experience: " + string(global.player_experience));
    } else {
        show_debug_message("Player data loading...");
    }
    
    if (variable_global_exists("resources")) {
        show_debug_message("Resources: Gold=" + string(global.resources.gold) + 
                         ", Wood=" + string(global.resources.wood) + 
                         ", Metal=" + string(global.resources.metal) + 
                         ", Gems=" + string(global.resources.gems));
    } else {
        show_debug_message("Resources loading...");
    }
    
    if (variable_global_exists("pets") && variable_global_exists("inventory") && variable_global_exists("pokemon_cards")) {
        show_debug_message("Pets: " + string(array_length(global.pets)));
        show_debug_message("Inventory: " + string(array_length(global.inventory)));
        show_debug_message("Pokemon Cards: " + string(array_length(global.pokemon_cards)));
    } else {
        show_debug_message("Game data loading...");
    }
    
    display_mode = "status";
    last_key_time = current_time;
}

// Periodic status update (every 30 seconds)
if (variable_global_exists("idle_timer") && variable_global_exists("resources") && 
    floor(global.idle_timer) >= last_status_update + 30 && global.idle_timer > 0) {
    show_debug_message("=== STATUS UPDATE ===");
    show_debug_message("Time played: " + string(floor(global.idle_timer)) + " seconds");
    show_debug_message("Resources: Gold=" + string(global.resources.gold) + 
                     ", Wood=" + string(global.resources.wood) + 
                     ", Metal=" + string(global.resources.metal) + 
                     ", Gems=" + string(global.resources.gems));
    if (variable_global_exists("pets") && array_length(global.pets) > 0) {
        show_debug_message("Active pets: " + string(array_length(global.pets)));
    }
    show_debug_message("💡 Press H for help, S for shop, I for status");
    last_status_update = floor(global.idle_timer);
}

// Update game systems
if (variable_global_exists("idle_timer")) {
    update_game_state();
}
if (variable_global_exists("pets")) {
    update_pets();
}
