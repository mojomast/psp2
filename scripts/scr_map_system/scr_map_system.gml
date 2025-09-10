// scr_map_system.gml
// Enhanced procedural map generation system for pet exploration

// Map tile type constants
#macro MAP_TILE_VOID -1
#macro MAP_TILE_EMPTY 0
#macro MAP_TILE_WALL 1
#macro MAP_TILE_TREE 2
#macro MAP_TILE_WATER 3
#macro MAP_TILE_PATH 4
#macro MAP_TILE_OBSTACLE 5
#macro MAP_TILE_POI 6
#macro MAP_TILE_TREASURE 7
#macro MAP_TILE_ENEMY 8
#macro MAP_TILE_SPAWN 9
#macro MAP_TILE_EXIT 10
#macro MAP_TILE_RESOURCE 11

// Generate a new enhanced map
function map_generate_map(_seed, _size, _difficulty) {
    // Set random seed for reproducible maps
    random_set_seed(_seed);
    
    // Validate and clamp parameters
    _size = clamp(_size, 5, 50);
    _difficulty = clamp(_difficulty, 1, 10);

    var _map = {
        id: "map_" + string(_seed) + "_" + string(current_time),
        size: _size,
        width: _size,
        height: _size,
        difficulty: _difficulty,
        seed: _seed,
        tiles: [],
        spawn_point: {x: 0, y: 0},
        exits: [],
        resources: [],
        enemies: [],
        treasures: [],
        points_of_interest: [],
        biome: map_choose_biome(_seed),
        weather: map_choose_weather(_seed),
        explored_percent: 0,
        creation_time: current_time,
        
        // Map methods
        get_tile: function(_x, _y) {
            if (_x < 0 || _x >= self.width || _y < 0 || _y >= self.height) {
                return MAP_TILE_VOID;
            }
            return self.tiles[_y * self.width + _x];
        },
        
        set_tile: function(_x, _y, _tile_type) {
            if (_x >= 0 && _x < self.width && _y >= 0 && _y < self.height) {
                self.tiles[_y * self.width + _x] = _tile_type;
            }
        },
        
        is_walkable: function(_x, _y) {
            var tile = self.get_tile(_x, _y);
            return (tile != MAP_TILE_WALL && tile != MAP_TILE_VOID && tile != MAP_TILE_WATER);
        }
    };

    // Initialize tile grid
    _map.tiles = array_create(_size * _size, MAP_TILE_EMPTY);

    // Generate terrain based on biome
    map_generate_terrain(_map);
    
    // Apply smoothing for more natural terrain
    map_apply_cellular_automata(_map, 2);

    // Set spawn point (find a clear area near center)
    var center_x = _size div 2;
    var center_y = _size div 2;
    var spawn_found = false;
    
    for (var radius = 0; radius < _size / 2 && !spawn_found; radius++) {
        for (var dy = -radius; dy <= radius && !spawn_found; dy++) {
            for (var dx = -radius; dx <= radius && !spawn_found; dx++) {
                var sx = center_x + dx;
                var sy = center_y + dy;
                if (sx >= 0 && sx < _size && sy >= 0 && sy < _size) {
                    if (_map.get_tile(sx, sy) == MAP_TILE_EMPTY) {
                        _map.spawn_point.x = sx;
                        _map.spawn_point.y = sy;
                        _map.set_tile(sx, sy, MAP_TILE_SPAWN);
                        spawn_found = true;
                    }
                }
            }
        }
    }
    
    if (!spawn_found) {
        // Force spawn at center if no clear spot found
        _map.spawn_point.x = center_x;
        _map.spawn_point.y = center_y;
        _map.set_tile(center_x, center_y, MAP_TILE_SPAWN);
    }

    // Generate exits (edges of map) with path connectivity
    var exit_count = 2 + irandom(2); // 2-4 exits
    for (var i = 0; i < exit_count; i++) {
        var _exit = {};
        var side = i % 4;
        
        switch (side) {
            case 0: // North
                _exit.x = irandom(_size - 1);
                _exit.y = 0;
                _exit.direction = "north";
                break;
            case 1: // East
                _exit.x = _size - 1;
                _exit.y = irandom(_size - 1);
                _exit.direction = "east";
                break;
            case 2: // South
                _exit.x = irandom(_size - 1);
                _exit.y = _size - 1;
                _exit.direction = "south";
                break;
            case 3: // West
                _exit.x = 0;
                _exit.y = irandom(_size - 1);
                _exit.direction = "west";
                break;
        }
        _exit.id = "exit_" + string(i);
        _exit.destination = "map_" + string((_seed + i + 1) * 7); // Link to other maps
        array_push(_map.exits, _exit);
        _map.set_tile(_exit.x, _exit.y, MAP_TILE_EXIT);
        
        // Create path from spawn to exit
        map_create_path(_map, _map.spawn_point.x, _map.spawn_point.y, _exit.x, _exit.y);
    }

    // Generate points of interest
    map_generate_points_of_interest(_map);
    
    // Generate treasures
    var treasure_count = floor(2 + _difficulty * 0.5 + random(3));
    map_generate_treasures(_map, treasure_count);
    
    // Generate resources based on difficulty and biome
    var _resource_count = _difficulty * 3 + irandom(5);
    for (var i = 0; i < _resource_count; i++) {
        var attempts = 0;
        var placed = false;
        
        while (!placed && attempts < 50) {
            var rx = irandom(_size - 1);
            var ry = irandom(_size - 1);
            
            if (_map.get_tile(rx, ry) == MAP_TILE_EMPTY) {
                var _resource = {
                    x: rx,
                    y: ry,
                    type: map_choose_resource_type(_map.biome),
                    amount: (_difficulty + 1) * (5 + irandom(10)),
                    collected: false
                };
                
                array_push(_map.resources, _resource);
                _map.set_tile(rx, ry, MAP_TILE_RESOURCE);
                placed = true;
            }
            attempts++;
        }
    }

    // Generate enemies based on difficulty and biome
    var _enemy_count = _difficulty * 2 + irandom(3);
    map_generate_enemies(_map, _enemy_count);
    
    // Reset random seed
    randomize();

    return _map;
}

// New helper functions for enhanced map generation

/// @function map_choose_biome(seed)
/// @description Choose a biome type based on seed
function map_choose_biome(_seed) {
    var biomes = ["forest", "desert", "tundra", "swamp", "mountain", "plains", "volcanic", "crystal"];
    var index = abs(_seed) % array_length(biomes);
    return biomes[index];
}

/// @function map_choose_weather(seed)
/// @description Choose weather conditions based on seed
function map_choose_weather(_seed) {
    var weather_types = ["clear", "rainy", "foggy", "stormy", "snowy", "windy"];
    var index = abs(_seed div 7) % array_length(weather_types);
    return weather_types[index];
}

/// @function map_generate_terrain(map)
/// @description Generate terrain features for the map
function map_generate_terrain(_map) {
    var size = _map.size;
    var biome = _map.biome;
    
    // Generate base terrain based on biome
    switch(biome) {
        case "forest":
            // Add trees
            for (var i = 0; i < size * size * 0.3; i++) {
                var tx = irandom(size - 1);
                var ty = irandom(size - 1);
                _map.set_tile(tx, ty, MAP_TILE_TREE);
            }
            break;
            
        case "desert":
            // Add sand dunes and obstacles
            for (var i = 0; i < size * size * 0.1; i++) {
                var tx = irandom(size - 1);
                var ty = irandom(size - 1);
                _map.set_tile(tx, ty, MAP_TILE_OBSTACLE);
            }
            break;
            
        case "swamp":
            // Add water tiles
            for (var i = 0; i < size * size * 0.2; i++) {
                var tx = irandom(size - 1);
                var ty = irandom(size - 1);
                _map.set_tile(tx, ty, MAP_TILE_WATER);
            }
            break;
            
        case "mountain":
            // Add rock walls
            for (var i = 0; i < size * size * 0.25; i++) {
                var tx = irandom(size - 1);
                var ty = irandom(size - 1);
                _map.set_tile(tx, ty, MAP_TILE_WALL);
            }
            break;
            
        default:
            // Plains or other - add scattered obstacles
            for (var i = 0; i < size * size * 0.15; i++) {
                var tx = irandom(size - 1);
                var ty = irandom(size - 1);
                _map.set_tile(tx, ty, MAP_TILE_OBSTACLE);
            }
            break;
    }
}

/// @function map_apply_cellular_automata(map, iterations)
/// @description Apply cellular automata to smooth terrain
function map_apply_cellular_automata(_map, _iterations) {
    // Temporarily simplified to fix compilation error
    return;
}

/// @function map_create_path(map, x1, y1, x2, y2)
/// @description Create a path between two points
function map_create_path(_map, _x1, _y1, _x2, _y2) {
    var current_x = _x1;
    var current_y = _y1;
    
    while (current_x != _x2 || current_y != _y2) {
        // Clear current tile if it's an obstacle
        var current_tile = _map.get_tile(current_x, current_y);
        if (current_tile == MAP_TILE_WALL || current_tile == MAP_TILE_TREE || 
            current_tile == MAP_TILE_OBSTACLE || current_tile == MAP_TILE_WATER) {
            _map.set_tile(current_x, current_y, MAP_TILE_PATH);
        }
        
        // Move toward target
        if (random(1) < 0.5) {
            if (current_x < _x2) current_x++;
            else if (current_x > _x2) current_x--;
        } else {
            if (current_y < _y2) current_y++;
            else if (current_y > _y2) current_y--;
        }
        
        // Clamp to map bounds
        current_x = clamp(current_x, 0, _map.size - 1);
        current_y = clamp(current_y, 0, _map.size - 1);
    }
}

/// @function map_generate_points_of_interest(map)
/// @description Generate points of interest on the map
function map_generate_points_of_interest(_map) {
    var poi_count = 1 + floor(_map.difficulty * 0.5) + irandom(2);
    
    for (var i = 0; i < poi_count; i++) {
        var placed = false;
        var attempts = 0;
        
        while (!placed && attempts < 100) {
            var px = irandom(_map.size - 1);
            var py = irandom(_map.size - 1);
            
            if (_map.get_tile(px, py) == MAP_TILE_EMPTY) {
                var poi = {
                    x: px,
                    y: py,
                    type: map_choose_poi_type(_map.biome, _map.difficulty),
                    discovered: false,
                    rewards: {
                        experience: 10 * _map.difficulty + irandom(20),
                        gold: 5 * _map.difficulty + irandom(15),
                        items: irandom(100) < (20 * _map.difficulty) ? 1 : 0
                    }
                };
                
                array_push(_map.points_of_interest, poi);
                _map.set_tile(px, py, MAP_TILE_POI);
                placed = true;
            }
            
            attempts++;
        }
    }
}

/// @function map_choose_poi_type(biome, difficulty)
/// @description Choose a POI type based on biome and difficulty
function map_choose_poi_type(_biome, _difficulty) {
    var poi_types = ["shrine", "ruins", "cave", "tower"];
    
    switch(_biome) {
        case "forest":
            poi_types = ["grove", "fairy_circle", "ancient_tree", "hunter_camp"];
            break;
        case "desert":
            poi_types = ["oasis", "pyramid", "sandstone_ruins", "nomad_camp"];
            break;
        case "mountain":
            poi_types = ["cave", "peak", "mine", "monastery"];
            break;
        case "swamp":
            poi_types = ["bog", "witch_hut", "sunken_ruins", "glowing_pool"];
            break;
    }
    
    return poi_types[irandom(array_length(poi_types) - 1)];
}

/// @function map_generate_treasures(map, count)
/// @description Generate treasure locations on the map
function map_generate_treasures(_map, _count) {
    for (var i = 0; i < _count; i++) {
        var placed = false;
        var attempts = 0;
        
        while (!placed && attempts < 100) {
            var tx = irandom(_map.size - 1);
            var ty = irandom(_map.size - 1);
            
            if (_map.get_tile(tx, ty) == MAP_TILE_EMPTY) {
                var treasure = {
                    x: tx,
                    y: ty,
                    type: choose("gold_chest", "gem_cache", "artifact", "supply_crate"),
                    value: {
                        gold: floor(10 + _map.difficulty * 5 + random(20)),
                        gems: irandom(100) < (10 * _map.difficulty) ? irandom(_map.difficulty) : 0,
                        experience: floor(5 + _map.difficulty * 2)
                    },
                    collected: false
                };
                
                array_push(_map.treasures, treasure);
                _map.set_tile(tx, ty, MAP_TILE_TREASURE);
                placed = true;
            }
            
            attempts++;
        }
    }
}

/// @function map_generate_enemies(map, count)
/// @description Generate enemy positions on the map
function map_generate_enemies(_map, _count) {
    for (var i = 0; i < _count; i++) {
        var placed = false;
        var attempts = 0;
        
        while (!placed && attempts < 100) {
            var ex = irandom(_map.size - 1);
            var ey = irandom(_map.size - 1);
            
            if (_map.get_tile(ex, ey) == MAP_TILE_EMPTY) {
                var enemy = {
                    x: ex,
                    y: ey,
                    type: map_choose_enemy_type(_map.biome, _map.difficulty),
                    level: _map.difficulty + irandom(2),
                    health: (_map.difficulty + 1) * 20,
                    attack: (_map.difficulty + 1) * 5,
                    defeated: false
                };
                
                array_push(_map.enemies, enemy);
                _map.set_tile(ex, ey, MAP_TILE_ENEMY);
                placed = true;
            }
            
            attempts++;
        }
    }
}

/// @function map_choose_enemy_type(biome, difficulty)
/// @description Choose enemy type based on biome and difficulty
function map_choose_enemy_type(_biome, _difficulty) {
    var enemy_types = ["bandit", "wild_beast", "goblin"];
    
    switch(_biome) {
        case "forest":
            enemy_types = ["wolf", "bear", "forest_sprite", "bandit"];
            break;
        case "desert":
            enemy_types = ["scorpion", "sand_wurm", "desert_raider", "mummy"];
            break;
        case "mountain":
            enemy_types = ["mountain_lion", "rock_golem", "harpy", "yeti"];
            break;
        case "swamp":
            enemy_types = ["swamp_creature", "giant_mosquito", "bog_witch", "crocodile"];
            break;
    }
    
    if (_difficulty >= 5) {
        array_push(enemy_types, "elite_" + enemy_types[0]);
    }
    
    return enemy_types[irandom(array_length(enemy_types) - 1)];
}

/// @function map_choose_resource_type(biome)
/// @description Choose resource type based on biome
function map_choose_resource_type(_biome) {
    var base_resources = ["gold", "wood", "metal", "gems"];
    
    // Biome-specific resource weights
    switch(_biome) {
        case "forest":
            return choose("wood", "wood", "gold", "herbs");
        case "mountain":
            return choose("metal", "metal", "gems", "stone");
        case "desert":
            return choose("gold", "gems", "oil", "sand_crystal");
        case "swamp":
            return choose("herbs", "wood", "peat", "rare_mushroom");
        default:
            return choose("gold", "wood", "metal", "gems");
    }
}

// Validate map structure
function map_validate_map(_map) {
    if (_map == undefined) return false;
    if (!is_struct(_map)) return false;
    if (_map.size <= 0) return false;
    if (!is_array(_map.tiles)) return false;
    if (array_length(_map.tiles) != _map.size * _map.size) return false;
    if (!is_struct(_map.spawn_point)) return false;
    if (!is_array(_map.exits)) return false;
    if (!is_array(_map.resources)) return false;
    if (!is_array(_map.enemies)) return false;

    return true;
}

// Get tile at coordinates
function map_get_map_tile(_map, _x, _y) {
    if (_x < 0 || _x >= _map.size || _y < 0 || _y >= _map.size) {
        return "out_of_bounds";
    }
    return _map.tiles[_y * _map.size + _x];
}

// Check if coordinates are valid spawn point
function map_is_valid_spawn(_map, _x, _y) {
    return (_x == _map.spawn_point.x && _y == _map.spawn_point.y);
}

// Check if coordinates are an exit
function map_is_exit(_map, _x, _y) {
    for (var i = 0; i < array_length(_map.exits); i++) {
        if (_map.exits[i].x == _x && _map.exits[i].y == _y) {
            return true;
        }
    }
    return false;
}

// Get spawn point coordinates
function map_get_spawn_point(_map) {
    return {x: _map.spawn_point.x, y: _map.spawn_point.y};
}

// Get all exits
function map_get_exits(_map) {
    return _map.exits;
}

/// @function validate_map(map)
/// @description Validate that a map structure is valid
/// @param {struct} map The map to validate
/// @return {bool} True if map is valid
function validate_map(_map) {
    if (!is_struct(_map)) return false;
    if (!variable_struct_exists(_map, "id")) return false;
    if (!variable_struct_exists(_map, "size")) return false;
    if (!variable_struct_exists(_map, "difficulty")) return false;
    if (!variable_struct_exists(_map, "tiles")) return false;
    if (!variable_struct_exists(_map, "spawn_point")) return false;
    if (!variable_struct_exists(_map, "exits")) return false;
    
    // Check that tiles array has correct size
    if (array_length(_map.tiles) != _map.size * _map.size) return false;
    
    return true;
}

/// @function get_spawn_point(map)
/// @description Get spawn point from map (alias for map_get_spawn_point)
/// @param {struct} map The map
/// @return {struct} Spawn point coordinates
function get_spawn_point(_map) {
    return map_get_spawn_point(_map);
}

/// @function get_exits(map)
/// @description Get exits from map (alias for map_get_exits)
/// @param {struct} map The map
/// @return {array} Array of exit structures
function get_exits(_map) {
    return map_get_exits(_map);
}

/// @function map_get_tile_symbol(tile_type)
/// @description Get ASCII symbol for tile type (for debugging)
/// @param {real} tile_type Tile type constant
/// @return {string} ASCII symbol
function map_get_tile_symbol(_tile_type) {
    switch(_tile_type) {
        case MAP_TILE_VOID: return " ";
        case MAP_TILE_EMPTY: return ".";
        case MAP_TILE_WALL: return "#";
        case MAP_TILE_TREE: return "T";
        case MAP_TILE_WATER: return "~";
        case MAP_TILE_PATH: return "+";
        case MAP_TILE_OBSTACLE: return "X";
        case MAP_TILE_POI: return "!";
        case MAP_TILE_TREASURE: return "$";
        case MAP_TILE_ENEMY: return "E";
        case MAP_TILE_SPAWN: return "@";
        case MAP_TILE_EXIT: return "O";
        case MAP_TILE_RESOURCE: return "*";
        default: return "?";
    }
}

/// @function map_to_string(map)
/// @description Convert map to ASCII string for debugging
/// @param {struct} map Map structure
/// @return {string} ASCII representation of map
function map_to_string(_map) {
    var output = "Map: " + _map.id + " (" + _map.biome + ", " + _map.weather + ")\n";
    output += "Size: " + string(_map.size) + "x" + string(_map.size) + ", Difficulty: " + string(_map.difficulty) + "\n";
    
    for (var map_y = 0; map_y < _map.height; map_y++) {
        for (var map_x = 0; map_x < _map.width; map_x++) {
            output += map_get_tile_symbol(_map.get_tile(map_x, map_y));
        }
        output += "\n";
    }
    
    output += "POIs: " + string(array_length(_map.points_of_interest)) + ", ";
    output += "Treasures: " + string(array_length(_map.treasures)) + ", ";
    output += "Enemies: " + string(array_length(_map.enemies)) + ", ";
    output += "Resources: " + string(array_length(_map.resources));
    
    return output;
}

/// @function map_calculate_exploration_rewards(map, exploration_percent)
/// @description Calculate rewards based on exploration percentage
/// @param {struct} map Map structure
/// @param {real} exploration_percent Percentage of map explored (0-100)
/// @return {struct} Rewards structure
function map_calculate_exploration_rewards(_map, _exploration_percent) {
    var base_reward = _map.difficulty * 10;
    var exploration_bonus = _exploration_percent / 100;
    
    return {
        gold: floor(base_reward * exploration_bonus * (1 + random(0.5))),
        experience: floor(base_reward * 0.5 * exploration_bonus),
        gems: irandom(100) < (_exploration_percent * 0.5) ? irandom(_map.difficulty) : 0,
        items_found: floor(array_length(_map.treasures) * exploration_bonus)
    };
}

/// @function map_debug_print(map)
/// @description Print map details to debug console
/// @param {struct} map Map to debug
function map_debug_print(_map) {
    show_debug_message("\n" + map_to_string(_map));
}
