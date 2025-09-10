// scr_pokemon_cards.gml
// Pokemon card system for the idle game

// Pokemon card data structure
function create_pokemon_card(_name, _type, _rarity, _base_value) {
    var _card = {
        name: _name,
        type: _type,
        rarity: _rarity,
        base_value: _base_value,
        level: 1,
        experience: 0,
        stats: {
            hp: 100,
            attack: 10,
            defense: 5,
            speed: 8
        },
        abilities: [],
        owner: "",
        collected_date: current_time
    };
    
    // Add type-specific bonuses
    switch (_type) {
        case "fire":
            _card.stats.attack += 5;
            break;
        case "water":
            _card.stats.hp += 20;
            break;
        case "grass":
            _card.stats.defense += 5;
            break;
        case "electric":
            _card.stats.speed += 10;
            break;
    }
    
    return _card;
}

// Card collection
global.pokemon_cards = [];

function add_pokemon_card(_card) {
    array_push(global.pokemon_cards, _card);
}

function get_pokemon_card(_index) {
    if (_index >= 0 && _index < array_length(global.pokemon_cards)) {
        return global.pokemon_cards[_index];
    }
    return undefined;
}

// Card trading/purchasing
function purchase_pokemon_card(_card_name, _type, _rarity) {
    // Check if player has enough gold
    var _cost = 100; // Base cost
    if (_rarity == "rare") _cost = 200;
    if (_rarity == "epic") _cost = 500;
    
    if (global.resources.gold >= _cost) {
        global.resources.gold -= _cost;
        
        // Create and add card
        var _card = create_pokemon_card(_card_name, _type, _rarity, _cost div 2);
        add_pokemon_card(_card);
        
        show_debug_message("Purchased " + _card_name + " card for " + string(_cost) + " gold");
        return true;
    }
    show_debug_message("Not enough gold to purchase " + _card_name + " card");
    return false;
}

// Convert resources to cards
function convert_resources_to_card(_resource_type, _amount) {
    var _conversion_rate = 10; // 10 wood = 1 card, etc.
    var _required = _amount * _conversion_rate;
    
    if (_resource_type == "wood" && global.resources.wood >= _required) {
        global.resources.wood -= _required;
        var _card = create_pokemon_card("Converted Card", "normal", "common", _amount * 5);
        add_pokemon_card(_card);
        return true;
    } else if (_resource_type == "metal" && global.resources.metal >= _required) {
        global.resources.metal -= _required;
        var _card = create_pokemon_card("Metal Card", "steel", "common", _amount * 10);
        add_pokemon_card(_card);
        return true;
    } else if (_resource_type == "gems" && global.resources.gems >= _required) {
        global.resources.gems -= _required;
        var _card = create_pokemon_card("Gem Card", "crystal", "rare", _amount * 20);
        add_pokemon_card(_card);
        return true;
    }
    
    return false;
}

// Card leveling
function level_up_pokemon_card(_card) {
    _card.level++;
    _card.experience = 0;
    
    // Increase stats
    _card.stats.hp += 10;
    _card.stats.attack += 2;
    _card.stats.defense += 1;
    _card.stats.speed += 1;
}

// Card battle system
function battle_pokemon_cards(_card1, _card2) {
    // Simple battle simulation
    var _damage1 = _card1.stats.attack - _card2.stats.defense;
    var _damage2 = _card2.stats.attack - _card1.stats.defense;
    
    if (_damage1 > 0) _card2.stats.hp -= _damage1;
    if (_damage2 > 0) _card1.stats.hp -= _damage2;
    
    // Determine winner
    if (_card1.stats.hp > _card2.stats.hp) {
        _card1.experience += 10;
        return _card1;
    } else if (_card2.stats.hp > _card1.stats.hp) {
        _card2.experience += 10;
        return _card2;
    } else {
        return undefined; // Tie
    }
}

// Card collection management
function get_total_card_value() {
    var _total = 0;
    for (var i = 0; i < array_length(global.pokemon_cards); i++) {
        _total += global.pokemon_cards[i].base_value;
    }
    return _total;
}

function find_pokemon_card_by_name(_name) {
    for (var i = 0; i < array_length(global.pokemon_cards); i++) {
        if (global.pokemon_cards[i].name == _name) {
            return global.pokemon_cards[i];
        }
    }
    return undefined;
}
