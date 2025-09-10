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

// Pokemon cards
global.pokemon_cards = [];

// Chat agents
global.chat_agents = [];

// Shop items
global.shop_items = [
    {
        name: "Wooden Sword",
        type: "weapon",
        price: 50,
        description: "A basic wooden sword"
    },
    {
        name: "Iron Ore",
        type: "resource", 
        price: 25,
        description: "Raw iron ore for crafting"
    },
    {
        name: "Healing Potion",
        type: "consumable",
        price: 30,
        description: "Restores pet health"
    }
];

// Idle mechanics
global.idle_timer = 0;
global.idle_start_time = current_time;
global.auto_save_timer = 0;
global.auto_save_interval = 60; // 60 seconds (1 minute)

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
        global.resources.metal = 25;
        global.resources.gems = 10;
        
        // Add a starting pet
        var _starting_pet = create_pet("Buddy", "dog");
        add_pet(_starting_pet);
    }

    // Initialize idle timer
    global.idle_timer = 0;
    global.idle_start_time = current_time;
    global.auto_save_timer = 0;

    // PERFORMANCE OPTIMIZATION: Initialize caching variables
    global.idle_accumulator = 0;
    global.cached_pet_bonuses = { gold: 0, wood: 0, metal: 0, gems: 0 };
    global.pet_bonus_cache_timer = 0;
    global.pet_update_timer = 0;
}

// Shop system functions
function buy_from_shop(_item_index) {
    return shop_buy_from_shop(_item_index);
}

function sell_to_shop(_item_index) {
    return shop_sell_to_shop(_item_index);
}

function process_shop_command(_command) {
    return shop_process_shop_command(_command);
}

// Crafting system functions
function craft_item(_recipe) {
    return crafting_craft_item(_recipe);
}

function get_crafting_recipes() {
    return crafting_get_crafting_recipes();
}

function can_craft_item(_recipe) {
    return crafting_can_craft_item(_recipe);
}

function process_crafting_command(_command) {
    return crafting_process_crafting_command(_command);
}

// Pet system functions
function create_pet(_name, _type) {
    return pet_create_pet(_name, _type);
}

function add_pet(_pet) {
    return pet_add_pet(_pet);
}

function get_pet(_index) {
    return pet_get_pet(_index);
}

function process_pet_command(_command) {
    return pet_process_pet_command(_command);
}

function update_pets() {
    return pet_update_pets();
}

// Map generation function
function generate_map(_seed, _size, _difficulty) {
    return map_generate_map(_seed, _size, _difficulty);
}

// Test functions
function run_all_tests() {
    return test_run_all_tests();
}
