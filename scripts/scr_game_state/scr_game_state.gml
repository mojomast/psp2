// scr_game_state.gml
// Game state management functions

// Save game to JSON
function game_state_save_game() {
    global.last_save_time = current_time; // Update last save time before saving
    
    var _save_data = {
        player_name: global.player_name,
        player_level: global.player_level,
        player_experience: global.player_experience,
        resources: global.resources,
        pets: global.pets,
        inventory: global.inventory,
        last_save_time: global.last_save_time
    };
    
    var _json = json_stringify(_save_data);
    var _file = file_text_open_write("savegame.json");
    file_text_write_string(_file, _json);
    file_text_close(_file);
    
    show_debug_message("Game saved");
}

// Load game from JSON
function game_state_load_game() {
    if (!file_exists("savegame.json")) {
        show_debug_message("No save file found");
        return;
    }
    
    var _file = file_text_open_read("savegame.json");
    var _json = file_text_read_string(_file);
    file_text_close(_file);
    
    var _save_data = json_parse(_json);
    
    global.player_name = _save_data.player_name;
    global.player_level = _save_data.player_level;
    global.player_experience = _save_data.player_experience;
    global.resources = _save_data.resources;
    global.pets = _save_data.pets;
    global.inventory = _save_data.inventory;
    global.last_save_time = _save_data.last_save_time;
    
    show_debug_message("Game loaded");
}

// Auto-save every 5 minutes
function game_state_auto_save() {
    game_state_save_game();
    // Note: last_save_time is already updated in game_state_save_game()
}

// Update game state (called every step) - OPTIMIZED VERSION
function game_state_update_game_state() {
    // Update idle timer (only update, don't process every frame)
    global.idle_timer += delta_time / 1000000; // Convert microseconds to seconds

    // PERFORMANCE OPTIMIZATION: Only process idle income every 1 second instead of every frame
    global.idle_accumulator += delta_time / 1000000;
    if (global.idle_accumulator >= 1.0) { // Process once per second
        var _seconds_passed = global.idle_accumulator;
        global.idle_accumulator = 0;

        // PERFORMANCE OPTIMIZATION: Cache pet bonuses instead of recalculating every frame
        if (!variable_global_exists("cached_pet_bonuses") || global.pet_bonus_cache_timer <= 0) {
            global.cached_pet_bonuses = { gold: 0, wood: 0, metal: 0, gems: 0 };
            if (variable_global_exists("pets")) {
                for (var i = 0; i < array_length(global.pets); i++) {
                    var _pet = global.pets[i];
                    if (_pet.status == "idle") {
                        global.cached_pet_bonuses.gold += _pet.level * 0.5;
                        global.cached_pet_bonuses.wood += _pet.level * 0.3;
                        global.cached_pet_bonuses.metal += _pet.level * 0.2;
                        global.cached_pet_bonuses.gems += _pet.level * 0.1;
                    }
                }
            }
            global.pet_bonus_cache_timer = 300; // Recache every 5 seconds
        } else {
            global.pet_bonus_cache_timer -= _seconds_passed;
        }

        // Base idle income
        var _gold_income = 1 + (global.player_level * 0.5) + global.cached_pet_bonuses.gold;
        var _wood_income = 0.5 + (global.player_level * 0.2) + global.cached_pet_bonuses.wood;
        var _metal_income = 0.2 + (global.player_level * 0.1) + global.cached_pet_bonuses.metal;
        var _gems_income = 0.1 + (global.player_level * 0.05) + global.cached_pet_bonuses.gems;

        // Apply idle income (scaled by time)
        global.resources.gold += _gold_income * (_seconds_passed * global.idle_speed);
        global.resources.wood += _wood_income * (_seconds_passed * global.idle_speed);
        global.resources.metal += _metal_income * (_seconds_passed * global.idle_speed);
        global.resources.gems += _gems_income * (_seconds_passed * global.idle_speed);
    }

    // Reset idle timer periodically to prevent overflow (less frequent check)
    if (global.idle_timer > 3600) { // Reset every hour
        global.idle_timer = 0;
        global.idle_start_time = current_time;
    }

    // PERFORMANCE OPTIMIZATION: Auto-save timer with reduced frequency check
    global.auto_save_timer += delta_time / 1000000; // Convert microseconds to seconds
    if (global.auto_save_timer >= global.auto_save_interval) {
        game_state_auto_save();
        global.auto_save_timer = 0;
    }
}

// Wrapper functions for external access
function save_game() {
    game_state_save_game();
}

function load_game() {
    game_state_load_game();
}

function auto_save() {
    game_state_auto_save();
}

function update_game_state() {
    game_state_update_game_state();
}
