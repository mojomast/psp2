// scr_game_state.gml
// Game state management functions

// Save game to JSON
function save_game() {
    game_state_save_game();
}

// Load game from JSON
function load_game() {
    game_state_load_game();
}

// Auto-save every 5 minutes
function auto_save() {
    game_state_auto_save();
}

// Update game state (called every step)
function update_game_state() {
    game_state_update_game_state();
    auto_save();
    // Add other periodic updates here
}
