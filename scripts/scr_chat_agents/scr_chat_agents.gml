// scr_chat_agents.gml
// Chat agent system for LLM integration

// Chat agent data structure
function create_chat_agent(_name, _personality) {
    var _agent = {
        name: _name,
        personality: _personality,
        conversation_history: [],
        mood: "neutral",
        knowledge_base: [],
        last_interaction: current_time
    };
    
    return _agent;
}

// Global chat agents
global.chat_agents = [];

function add_chat_agent(_agent) {
    array_push(global.chat_agents, _agent);
}

function get_chat_agent(_index) {
    if (_index >= 0 && _index < array_length(global.chat_agents)) {
        return global.chat_agents[_index];
    }
    return undefined;
}

// Simple chat response (placeholder for LLM integration)
function chat_with_agent(_agent, _message) {
    // Add user message to history
    array_push(_agent.conversation_history, {speaker: "user", message: _message, time: current_time});
    
    // Generate response based on personality
    var _response = generate_agent_response(_agent, _message);
    
    // Add agent response to history
    array_push(_agent.conversation_history, {speaker: _agent.name, message: _response, time: current_time});
    
    _agent.last_interaction = current_time;
    
    return _response;
}

function generate_agent_response(_agent, _message) {
    // Simple response generation based on keywords
    var _lower_message = string_lower(_message);
    
    if (string_pos("hello", _lower_message) > 0 || string_pos("hi", _lower_message) > 0) {
        return "Hello! I'm " + _agent.name + ". How can I help you today?";
    } else if (string_pos("pet", _lower_message) > 0) {
        return "Pets are wonderful companions! I see you have some amazing pets in your collection.";
    } else if (string_pos("craft", _lower_message) > 0) {
        return "Crafting is an art! What are you working on?";
    } else if (string_pos("gold", _lower_message) > 0 || string_pos("resource", _lower_message) > 0) {
        return "Resources are the lifeblood of any good shop owner. Keep gathering!";
    } else {
        return "That's interesting! Tell me more about " + _message + ".";
    }
}

// Agent mood system
function update_agent_mood(_agent) {
    var _time_since_interaction = current_time - _agent.last_interaction;
    
    if (_time_since_interaction > 86400000) { // 24 hours
        _agent.mood = "lonely";
    } else if (_time_since_interaction > 3600000) { // 1 hour
        _agent.mood = "bored";
    } else {
        _agent.mood = "happy";
    }
}

// Agent knowledge system
function teach_agent(_agent, _topic, _information) {
    var _knowledge = {
        topic: _topic,
        information: _information,
        learned_date: current_time
    };
    
    array_push(_agent.knowledge_base, _knowledge);
}

function agent_recall(_agent, _topic) {
    for (var i = 0; i < array_length(_agent.knowledge_base); i++) {
        if (_agent.knowledge_base[i].topic == _topic) {
            return _agent.knowledge_base[i].information;
        }
    }
    return "I don't recall learning about that topic yet.";
}
