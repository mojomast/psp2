// Debug controller Step Event
frame_count++;

if (frame_count % debug_interval == 0) {
    show_debug_message("=== DEBUG INFO (Frame " + string(frame_count) + ") ===");
    show_debug_message("Current room: " + room_get_name(room));
    show_debug_message("Instance count: " + string(instance_count));
    show_debug_message("Title controller exists: " + string(instance_exists(obj_title_controller)));
    show_debug_message("UI controller exists: " + string(instance_exists(obj_ui_controller)));
}
