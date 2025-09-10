// obj_idle_controller Step Event
// Handle all keyboard shortcuts

// Don't process input if we're in the title screen
if (room == Room_Title) return;
// Display help
if (keyboard_check_pressed(ord("H"))) {
    show_debug_message("=== CONTROLS ===");
    show_debug_message("T - Run test suite");
    show_debug_message("R - Reset game state");
    show_debug_message("S - Open pawn shop");
    show_debug_message("I - Show player status");
    show_debug_message("C - Open crafting system");
    show_debug_message("P - Manage pets");
    show_debug_message("H - Show this help");
    show_debug_message("G - Full user guide");
    show_debug_message("");
    show_debug_message("=== SHOP SHORTCUTS (when in shop) ===");
    show_debug_message("1-3 - Buy items 0-2");
    show_debug_message("Q-W - Sell items 0-1");
    show_debug_message("ESC - Exit shop");
    show_debug_message("");
    show_debug_message("=== CRAFTING SHORTCUTS (when in crafting) ===");
    show_debug_message("1-8 - Craft items 0-7");
    show_debug_message("ESC - Exit crafting");
    show_debug_message("");
    show_debug_message("=== PET SHORTCUTS (when in pets) ===");
    show_debug_message("1-9 - Select pet 0-8");
    show_debug_message("E - Explore with selected pet");
    show_debug_message("ESC - Exit pets");
    show_debug_message("");
    show_debug_message("Note: Make sure to click on the game window first!");
    
    // Tell UI to show help/status panel
    if (instance_exists(obj_ui_controller)) {
        obj_ui_controller.ui_active_panel = "resources"; // Default to resources for now
    }
    
    display_mode = "help";
    last_key_time = current_time;
}

// Reset game state
if (keyboard_check_pressed(ord("R"))) {
    show_debug_message("=== RESETTING GAME STATE ===");
    file_delete("savegame.json");
    game_restart();
}

// Display full user guide
if (keyboard_check_pressed(ord("G"))) {
    display_mode = "guide";
    last_key_time = current_time;
}

// Run test suite
if (keyboard_check_pressed(ord("T"))) {
    run_all_tests();
    display_mode = "normal";
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
    show_debug_message("Press 1-3 to buy, Q-W to sell, ESC to exit");
    
    // Tell UI to show shop panel
    if (instance_exists(obj_ui_controller)) {
        obj_ui_controller.ui_active_panel = "shop";
    }
    
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

    // Tell UI to show resources panel (for status)
    if (instance_exists(obj_ui_controller)) {
        obj_ui_controller.ui_active_panel = "resources";
    }
    
    display_mode = "status";
    last_key_time = current_time;
}

// Display crafting
if (keyboard_check_pressed(ord("C"))) {
    show_debug_message("=== CRAFTING SYSTEM ===");

    var _recipes = crafting_get_crafting_recipes();
    for (var i = 0; i < array_length(_recipes); i++) {
        var _recipe = _recipes[i];
        show_debug_message(string(i) + ". " + _recipe.name);
        show_debug_message("   Requirements: " + json_stringify(_recipe.requirements));
        show_debug_message("   Result: " + _recipe.result);
    }
    show_debug_message("Press 1-8 to craft, ESC to exit");

    // Tell UI to show crafting panel
    if (instance_exists(obj_ui_controller)) {
        obj_ui_controller.ui_active_panel = "crafting";
    }
    
    display_mode = "crafting";
    last_key_time = current_time;
}

// Display pets
if (keyboard_check_pressed(ord("P"))) {
    show_debug_message("=== PET MANAGEMENT ===");

    if (variable_global_exists("pets")) {
        for (var i = 0; i < array_length(global.pets); i++) {
            var _pet = global.pets[i];
            show_debug_message(string(i) + ". " + _pet.name + " (" + _pet.type + ") - Level " + string(_pet.level) + " - " + _pet.status);
        }
    }
    show_debug_message("Press 1-9 to select pet, E to explore, ESC to exit");

    // Tell UI to show pets panel
    if (instance_exists(obj_ui_controller)) {
        obj_ui_controller.ui_active_panel = "pets";
    }
    
    display_mode = "pets";
    last_key_time = current_time;
}

// Handle shop shortcuts
if (display_mode == "shop") {
    // Buy items
    if (keyboard_check_pressed(ord("1"))) {
        process_shop_command("buy 0");
    } else if (keyboard_check_pressed(ord("2"))) {
        process_shop_command("buy 1");
    } else if (keyboard_check_pressed(ord("3"))) {
        process_shop_command("buy 2");
    }
    // Sell items
    else if (keyboard_check_pressed(ord("Q"))) {
        process_shop_command("sell 0");
    } else if (keyboard_check_pressed(ord("W"))) {
        process_shop_command("sell 1");
    }
    // Exit
    else if (keyboard_check_pressed(vk_escape)) {
        display_mode = "normal";
        show_debug_message("Exited shop");
        last_key_time = current_time;
    }
}

// Handle crafting shortcuts
if (display_mode == "crafting") {
    // Craft items
    if (keyboard_check_pressed(ord("1"))) {
        process_crafting_command("craft 0");
    } else if (keyboard_check_pressed(ord("2"))) {
        process_crafting_command("craft 1");
    } else if (keyboard_check_pressed(ord("3"))) {
        process_crafting_command("craft 2");
    } else if (keyboard_check_pressed(ord("4"))) {
        process_crafting_command("craft 3");
    } else if (keyboard_check_pressed(ord("5"))) {
        process_crafting_command("craft 4");
    } else if (keyboard_check_pressed(ord("6"))) {
        process_crafting_command("craft 5");
    } else if (keyboard_check_pressed(ord("7"))) {
        process_crafting_command("craft 6");
    } else if (keyboard_check_pressed(ord("8"))) {
        process_crafting_command("craft 7");
    }
    // Exit
    else if (keyboard_check_pressed(vk_escape)) {
        display_mode = "normal";
        show_debug_message("Exited crafting");
        last_key_time = current_time;
    }
}

// Handle pet shortcuts
if (display_mode == "pets") {
    // Select pet
    if (keyboard_check_pressed(ord("1"))) {
        selected_pet = 0;
        show_debug_message("Selected pet 0");
    } else if (keyboard_check_pressed(ord("2"))) {
        selected_pet = 1;
        show_debug_message("Selected pet 1");
    } else if (keyboard_check_pressed(ord("3"))) {
        selected_pet = 2;
        show_debug_message("Selected pet 2");
    } else if (keyboard_check_pressed(ord("4"))) {
        selected_pet = 3;
        show_debug_message("Selected pet 3");
    } else if (keyboard_check_pressed(ord("5"))) {
        selected_pet = 4;
        show_debug_message("Selected pet 4");
    } else if (keyboard_check_pressed(ord("6"))) {
        selected_pet = 5;
        show_debug_message("Selected pet 5");
    } else if (keyboard_check_pressed(ord("7"))) {
        selected_pet = 6;
        show_debug_message("Selected pet 6");
    } else if (keyboard_check_pressed(ord("8"))) {
        selected_pet = 7;
        show_debug_message("Selected pet 7");
    } else if (keyboard_check_pressed(ord("9"))) {
        selected_pet = 8;
        show_debug_message("Selected pet 8");
    }
    // Pet actions
    else if (keyboard_check_pressed(ord("E"))) {
        if (selected_pet != undefined) {
            process_pet_command("explore " + string(selected_pet));
        } else {
            show_debug_message("Select a pet first (press 1-9)");
        }
    }
    // Exit
    else if (keyboard_check_pressed(vk_escape)) {
        display_mode = "normal";
        selected_pet = undefined;
        show_debug_message("Exited pet management");
        last_key_time = current_time;
    }
}// Periodic status update (every 30 seconds)
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
    show_debug_message("💡 Press H for help, S for shop, C for crafting, P for pets");
    last_status_update = floor(global.idle_timer);
}

// Update game systems
if (variable_global_exists("idle_timer")) {
    update_game_state();
}
if (variable_global_exists("pets")) {
    update_pets();
}
