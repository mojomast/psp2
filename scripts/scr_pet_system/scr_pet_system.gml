// scr_pet_system.gml
// Core pet system functions

// Create a new pet
function pet_create_pet(_name, _type) {
    // Initialize global pet ID counter if it doesn't exist
    if (!variable_global_exists("next_pet_id")) {
        global.next_pet_id = 1;
    }
    
    var _pet = {
        id: global.next_pet_id++,  // Assign unique ID
        name: _name,
        type: _type,
        level: 1,
        experience: 0,
        status: "idle",
        current_map: "",
        stats: [100, 10, 5, 8, 1], // [health, attack, defense, speed, luck]
        inventory: [],
        explore: function(_map) {
            self.status = "exploring";
            if (is_string(_map)) {
                // Backward compatibility: _map is a string ID
                self.current_map = _map;
                self.map_data = undefined;
            } else if (is_struct(_map)) {
                // New functionality: _map is a map struct
                self.current_map = _map.id;
                self.map_data = _map;
            } else {
                // Fallback
                self.current_map = string(_map);
                self.map_data = undefined;
            }
        },
        battle: function() {
            self.status = "battling";
            // Simple battle: reduce health by random amount
            var _damage = irandom_range(5, 15);
            self.stats[0] = max(0, self.stats[0] - _damage);
            
            // Chance to win and gain experience
            if (random(1) < 0.6) { // 60% win rate
                self.experience += 15;
            }
        },
        level_up: function() {
            self.level++;
            self.stats[0] += 10; // health
            self.stats[1] += 2;  // attack
            self.stats[2] += 1;  // defense
        }
    };

    // Add type-specific bonuses
    switch (_type) {
        case "dog":
            _pet.stats[1] += 3; // attack
            break;
        case "cat":
            _pet.stats[3] += 3; // speed
            break;
        case "dragon":
            _pet.stats[0] += 20; // health
            _pet.stats[1] += 5;  // attack
            break;
        case "rabbit":
            _pet.stats[4] += 2; // luck
            break;
        case "explorer":
            _pet.stats[3] += 2; // speed
            _pet.stats[2] += 2; // defense
            break;
    }

    return _pet;
}

// Add pet to global pets array
function pet_add_pet(_pet) {
    if (!variable_global_exists("pets")) {
        global.pets = [];
    }
    array_push(global.pets, _pet);
}

// Get pet by index
function pet_get_pet(_index) {
    if (_index >= 0 && _index < array_length(global.pets)) {
        return global.pets[_index];
    }
    return undefined;
}

// Update all pets (called each step) - OPTIMIZED VERSION
function pet_update_pets() {
    if (!variable_global_exists("pets")) return;

    // PERFORMANCE OPTIMIZATION: Only process pet updates every 0.5 seconds instead of every frame
    if (!variable_global_exists("pet_update_timer")) {
        global.pet_update_timer = 0;
    }
    global.pet_update_timer += delta_time / 1000000;

    if (global.pet_update_timer >= 0.5) { // Process every 0.5 seconds
        var _time_passed = global.pet_update_timer;
        global.pet_update_timer = 0;

        for (var i = 0; i < array_length(global.pets); i++) {
            var _pet = global.pets[i];

            // Handle exploration
            if (_pet.status == "exploring") {
                // PERFORMANCE OPTIMIZATION: Batch experience gain instead of per-frame
                _pet.experience += _time_passed * 2; // 2 exp per second instead of 1 per frame

                // Chance to level up (less frequent check)
                if (_pet.experience >= _pet.level * 100) {
                    _pet.level_up();
                    _pet.experience = 0;
                }

                // PERFORMANCE OPTIMIZATION: Reduced exploration return chance
                if (random(1) < 0.02) { // 2% chance per 0.5 seconds (4% per second total)
                    _pet.status = "idle";
                    _pet.current_map = "";

                    // Reward resources based on map difficulty
                    var _base_gold = _pet.level * 5;
                    var _base_wood = _pet.level * 2;

                    if (variable_struct_exists(_pet, "map_data") && _pet.map_data != undefined && variable_struct_exists(_pet.map_data, "difficulty")) {
                        _base_gold *= (1 + _pet.map_data.difficulty * 0.5);
                        _base_wood *= (1 + _pet.map_data.difficulty * 0.3);
                    }

                    global.resources.gold += _base_gold;
                    global.resources.wood += _base_wood;

                    _pet.map_data = undefined;
                }
            }

            // Handle battling
            if (_pet.status == "battling") {
                // PERFORMANCE OPTIMIZATION: Reduced battle completion chance
                if (random(1) < 0.05) { // 5% chance per 0.5 seconds (10% per second total)
                    _pet.status = "idle";
                    _pet.experience += 10;

                    // Chance to level up
                    if (_pet.experience >= _pet.level * 100) {
                        _pet.level_up();
                        _pet.experience = 0;
                    }
                }
            }
        }
    }
}

// Process pet command
function pet_process_pet_command(_command) {
    var _parts = string_split(_command, " ");
    
    if (array_length(_parts) < 2) return;
    
    var _action = _parts[0];
    var _index = real(_parts[1]);
    
    if (_index < 0 || _index >= array_length(global.pets)) {
        show_debug_message("Invalid pet index");
        return;
    }
    
    var _pet = global.pets[_index];
    
    if (_action == "explore") {
        if (_pet.status == "idle") {
            // Generate a random map
            var _seed = irandom(999999);
            var _size = 10 + irandom(10); // 10-20
            var _difficulty = 1 + irandom(4); // 1-5
            var _map = generate_map(_seed, _size, _difficulty);
            _pet.explore(_map);
            show_debug_message("Sent " + _pet.name + " to explore a map (difficulty " + string(_difficulty) + ")");
        } else {
            show_debug_message(_pet.name + " is already " + _pet.status);
        }
    } else if (_action == "status") {
        show_debug_message("Pet: " + _pet.name + " (" + _pet.type + ")");
        show_debug_message("Level: " + string(_pet.level) + ", Experience: " + string(_pet.experience));
        show_debug_message("Status: " + _pet.status);
        show_debug_message("Stats: HP=" + string(_pet.stats[0]) + ", ATK=" + string(_pet.stats[1]) + ", DEF=" + string(_pet.stats[2]) + ", SPD=" + string(_pet.stats[3]) + ", LCK=" + string(_pet.stats[4]));
    }
}
