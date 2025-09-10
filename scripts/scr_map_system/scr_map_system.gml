// scr_map_system.gml
// Procedural map generation system

// Generate a new map
function map_generate_map(_seed, _size, _difficulty) {
    // Set random seed for reproducible maps
    random_set_seed(_seed);

    var _map = {
        id: "map_" + string(_seed),
        size: _size,
        difficulty: _difficulty,
        seed: _seed,
        tiles: [],
        spawn_point: {x: 0, y: 0},
        exits: [],
        resources: [],
        enemies: []
    };

    // Initialize tile grid
    _map.tiles = array_create(_size * _size, "empty");

    // Generate terrain
    for (var i = 0; i < _size * _size; i++) {
        var _x = i mod _size;
        var _y = i div _size;

        // Use noise for natural terrain generation
        var _noise = random(1);
        if (_noise < 0.3) {
            _map.tiles[i] = "forest";
        } else if (_noise < 0.5) {
            _map.tiles[i] = "mountain";
        } else if (_noise < 0.7) {
            _map.tiles[i] = "water";
        } else {
            _map.tiles[i] = "plains";
        }
    }

    // Set spawn point (center of map)
    _map.spawn_point.x = _size div 2;
    _map.spawn_point.y = _size div 2;
    _map.tiles[_map.spawn_point.y * _size + _map.spawn_point.x] = "spawn";

    // Generate exits (edges of map)
    for (var i = 0; i < 4; i++) {
        var _exit = {};
        switch (i) {
            case 0: // North
                _exit.x = irandom(_size - 1);
                _exit.y = 0;
                break;
            case 1: // East
                _exit.x = _size - 1;
                _exit.y = irandom(_size - 1);
                break;
            case 2: // South
                _exit.x = irandom(_size - 1);
                _exit.y = _size - 1;
                break;
            case 3: // West
                _exit.x = 0;
                _exit.y = irandom(_size - 1);
                break;
        }
        _exit.id = "exit_" + string(i);
        array_push(_map.exits, _exit);
        _map.tiles[_exit.y * _size + _exit.x] = "exit";
    }

    // Generate resources based on difficulty
    var _resource_count = _difficulty * 3 + irandom(5);
    for (var i = 0; i < _resource_count; i++) {
        var _resource = {
            x: irandom(_size - 1),
            y: irandom(_size - 1),
            type: choose("gold", "wood", "metal", "gems"),
            amount: (_difficulty + 1) * (5 + irandom(10))
        };

        // Don't place on spawn or exits
        var _tile_index = _resource.y * _size + _resource.x;
        if (_map.tiles[_tile_index] != "spawn" && _map.tiles[_tile_index] != "exit") {
            array_push(_map.resources, _resource);
            _map.tiles[_tile_index] = "resource";
        }
    }

    // Generate enemies based on difficulty
    var _enemy_count = _difficulty * 2 + irandom(3);
    for (var i = 0; i < _enemy_count; i++) {
        var _enemy = {
            x: irandom(_size - 1),
            y: irandom(_size - 1),
            type: choose("goblin", "orc", "troll", "dragon"),
            level: _difficulty + irandom(2),
            health: (_difficulty + 1) * 20,
            attack: (_difficulty + 1) * 5
        };

        // Don't place on spawn or exits
        var _tile_index = _enemy.y * _size + _enemy.x;
        if (_map.tiles[_tile_index] != "spawn" && _map.tiles[_tile_index] != "exit") {
            array_push(_map.enemies, _enemy);
            _map.tiles[_tile_index] = "enemy";
        }
    }

    return _map;
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
