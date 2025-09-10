// scr_game_state.gml
// Game state management functions

// Save game to JSON
function save_game() {
    var _save_data = {
        player_name: global.player_name,
        player_level: global.player_level,
        player_experience: global.player_experience,
        resources: global.resources,
        pets: global.pets,
        inventory: global.inventory,
        last_save_time: current_time
    };
    
    var _json = json_stringify(_save_data);
    var _file = file_text_open_write("savegame.json");
    file_text_write_string(_file, _json);
    file_text_close(_file);
    
    show_debug_message("Game saved");
}

// Load game from JSON
function load_game() {
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
function auto_save() {
    if (current_time - global.last_save_time > 300000) { // 5 minutes in milliseconds
        save_game();
        global.last_save_time = current_time;
    }
}

// Update game state (called every step)
function update_game_state() {
    auto_save();
    // Add other periodic updates here
}
