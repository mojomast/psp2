// scr_game_state.gml
// Game state management functions

// Local constants - these should be defined in scr_ui_constants but adding here as fallback
// If you're still getting errors, the constants from scr_ui_constants may not be loading properly
#macro IDLE_UPDATE_INTERVAL_LOCAL 1.0
#macro AUTOSAVE_INTERVAL_LOCAL 60
#macro PET_BONUS_CACHE_TIME_LOCAL 5
#macro BASE_GOLD_INCOME_LOCAL 1.0
#macro BASE_WOOD_INCOME_LOCAL 0.5
#macro BASE_METAL_INCOME_LOCAL 0.2
#macro BASE_GEMS_INCOME_LOCAL 0.1

// Save game to JSON
function game_state_save_game() {
    global.last_save_time = current_time; // Update last save time before saving
    
    var _save_data = {
        version: "1.0.0", // Save file version for compatibility
        player_name: global.player_name,
        player_level: global.player_level,
        player_experience: global.player_experience,
        resources: global.resources,
        pets: global.pets,
        inventory: global.inventory,
        pokemon_cards: variable_global_exists("pokemon_cards") ? global.pokemon_cards : [],
        chat_agents: variable_global_exists("chat_agents") ? global.chat_agents : [],
        last_save_time: global.last_save_time
    };
    
    var _json = json_stringify(_save_data);
    var _file = file_text_open_write("savegame.json");
    file_text_write_string(_file, _json);
    file_text_close(_file);
    
    show_debug_message("Game saved");
}

// Load game from JSON with validation
function game_state_load_game() {
    if (!file_exists("savegame.json")) {
        show_debug_message("No save file found");
        return false;
    }
    
    try {
        var _file = file_text_open_read("savegame.json");
        var _json = file_text_read_string(_file);
        file_text_close(_file);
        
        var _save_data = json_parse(_json);
        
        // Validate save data
        if (!is_struct(_save_data)) {
            show_debug_message("Invalid save file format");
            return false;
        }
        
        // Check version compatibility (could add migration logic here)
        var save_version = variable_struct_exists(_save_data, "version") ? _save_data.version : "0.0.0";
        show_debug_message("Loading save file version: " + save_version);
        
        // Load with validation
        global.player_name = variable_struct_exists(_save_data, "player_name") ? _save_data.player_name : "Player";
        global.player_level = variable_struct_exists(_save_data, "player_level") ? _save_data.player_level : 1;
        global.player_experience = variable_struct_exists(_save_data, "player_experience") ? _save_data.player_experience : 0;
        global.resources = variable_struct_exists(_save_data, "resources") ? _save_data.resources : {gold: 100, wood: 50, metal: 25, gems: 10};
        global.pets = variable_struct_exists(_save_data, "pets") ? _save_data.pets : [];
        global.inventory = variable_struct_exists(_save_data, "inventory") ? _save_data.inventory : [];
        global.pokemon_cards = variable_struct_exists(_save_data, "pokemon_cards") ? _save_data.pokemon_cards : [];
        global.chat_agents = variable_struct_exists(_save_data, "chat_agents") ? _save_data.chat_agents : [];
        global.last_save_time = variable_struct_exists(_save_data, "last_save_time") ? _save_data.last_save_time : current_time;
        
        show_debug_message("Game loaded successfully");
        return true;
        
    } catch(_error) {
        show_debug_message("Error loading save file: " + string(_error));
        return false;
    }
}

// Auto-save every 5 minutes
function game_state_auto_save() {
    game_state_save_game();
    // Note: last_save_time is already updated in game_state_save_game()
}

// Update game state (called every step) - OPTIMIZED VERSION
function game_state_update_game_state() {
    // Convert delta_time once and reuse
    var dt_seconds = delta_time / 1000000; // Convert microseconds to seconds
    
    // Update idle timer
    global.idle_timer += dt_seconds;

    // PERFORMANCE OPTIMIZATION: Only process idle income at set intervals
    global.idle_accumulator += dt_seconds;
    if (global.idle_accumulator >= IDLE_UPDATE_INTERVAL_LOCAL) { // Use local constant
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
            global.pet_bonus_cache_timer = PET_BONUS_CACHE_TIME_LOCAL; // Use local constant
        } else {
            global.pet_bonus_cache_timer -= _seconds_passed;
        }

        // Base idle income using local constants
        var _gold_income = BASE_GOLD_INCOME_LOCAL + (global.player_level * 0.5) + global.cached_pet_bonuses.gold;
        var _wood_income = BASE_WOOD_INCOME_LOCAL + (global.player_level * 0.2) + global.cached_pet_bonuses.wood;
        var _metal_income = BASE_METAL_INCOME_LOCAL + (global.player_level * 0.1) + global.cached_pet_bonuses.metal;
        var _gems_income = BASE_GEMS_INCOME_LOCAL + (global.player_level * 0.05) + global.cached_pet_bonuses.gems;

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

    // Auto-save timer
    global.auto_save_timer += dt_seconds; // Reuse converted time
    if (global.auto_save_timer >= AUTOSAVE_INTERVAL_LOCAL) { // Use local constant
        game_state_auto_save();
        global.auto_save_timer = 0;
    }
}

// Wrapper functions for external access (prevent infinite loops)
function save_game() {
    return game_state_save_game();
}

function load_game() {
    return game_state_load_game();
}

function auto_save() {
    return game_state_auto_save();
}

function update_game_state() {
    return game_state_update_game_state();
}
