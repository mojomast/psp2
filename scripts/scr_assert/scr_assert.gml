// scr_assert.gml
// Shared assertion and utility functions for all tests

function assert(_condition, _message) {
    if (!_condition) {
        show_debug_message("ASSERTION FAILED: " + string(_message));
        throw("Assertion failed: " + string(_message));
    }
}

// Helper function to check if array contains item
function array_contains(_array, _item) {
    for (var i = 0; i < array_length(_array); i++) {
        var _current = _array[i];
        
        // Handle different types of items
        if (is_string(_item)) {
            // If item is a string, check if any array element has that name
            if (is_struct(_current) && struct_exists(_current, "name")) {
                if (_current.name == _item) {
                    return true;
                }
            } else if (_current == _item) {
                return true;
            }
        } else if (is_struct(_item)) {
            // If item is a struct, check for matching struct
            if (is_struct(_current) && _current == _item) {
                return true;
            }
        } else {
            // Direct comparison for other types
            if (_current == _item) {
                return true;
            }
        }
    }
    return false;
}
