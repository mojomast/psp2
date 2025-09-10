// Force assets to be included in build
// This function references assets that GameMaker might think are unused
// Call this from a persistent object's create event or game initialization

function force_assets() {
    // Reference fonts to prevent them from being removed
    var _fonts = [fnt_title, fnt_ui_main];
    
    // Reference sprites to prevent them from being removed
    var _sprites = [spr_title_logo, spr_ui_buttons, spr_ui_icons];
    
    // This ensures the assets are seen as "used" by GameMaker's dependency checker
    // The variables won't actually be used but this prevents asset removal
    show_debug_message("Assets referenced for inclusion in build");
}
