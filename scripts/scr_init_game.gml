// scr_init_game.gml
// Initialize global variables for the idle incremental game

// Player data
global.player_name = "Player";
global.player_level = 1;
global.player_experience = 0;

// Resources
global.resources = {
    gold: 0,
    wood: 0,
    metal: 0,
    gems: 0
};

// Pets array
global.pets = [];

// Inventory
global.inventory = [];

// Game settings
global.idle_speed = 1; // seconds per real second
global.last_save_time = current_time;

// Initialize game state
function init_game_state() {
    // Load from save file if exists
    if (file_exists("savegame.json")) {
        load_game();
    } else {
        // New game defaults
        global.player_name = "Pawn Shop Owner";
        global.resources.gold = 100;
        global.resources.wood = 50;
    }
    
    show_debug_message("Game initialized");
}
