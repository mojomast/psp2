# Title Screen Layout Specification

## Screen Dimensions
- **Resolution**: 1366x768 (Full Screen)
- **Aspect Ratio**: 16:9

## Layout Structure

### Upper Section (0-600px)
**Main Visual Area**
- Pawn Stars Idle Game logo/artwork
- Background imagery or branding
- Primary visual focus area

### Lower Section (600-768px)  
**Menu and Information Area**
- Menu options (Start Game, Settings, Exit)
- Creator credits
- Version information
- Navigation instructions

## Creator Information Display
**Position**: Bottom section (620-750px)
**Content**:
```
Created by:
KYLE DUREPOS & MATTHEW DUREPOS

Pawn Stars Idle Game
Version 1.0
```

## Menu Options Layout
**Position**: Bottom-left area (620-750px, x: 50-400px)
- **Start Game** - Transition to Room1
- **Settings** - Game configuration (if implemented)
- **Exit** - Close application

## Color Scheme Recommendations
- **Background**: Dark gradient (professional look)
- **Text**: White or light gold for readability
- **Accent**: Pawn shop themed colors (gold, brown, burgundy)
- **Menu Highlights**: Bright gold for selected items

## Fonts
- **Title/Logo**: `fnt_title` (Arial Bold 24pt)
- **Menu Items**: `fnt_ui_main` (Arial 12pt)
- **Credits**: `fnt_ui_main` (Arial 12pt)

## Interactive Elements
- **Keyboard Navigation**: Arrow keys + Enter
- **Mouse Support**: Click to select menu items
- **Controller Support**: D-pad + A button (future enhancement)

## Implementation Notes
- Use `spr_title_logo` as full-screen background
- Draw text overlays using GameMaker's draw_text functions
- Implement smooth transitions between menu states
- Maintain 60fps performance
- Support for different screen resolutions (scaling)

## GameMaker Implementation
```gml
// In obj_title_controller Draw_64 event:
// Draw full-screen background
draw_sprite(spr_title_logo, 0, display_get_gui_width()/2, display_get_gui_height()/2);

// Draw creator credits
draw_set_font(fnt_ui_main);
draw_set_color(c_white);
draw_text(50, display_get_gui_height() - 100, "Created by:");
draw_text(50, display_get_gui_height() - 80, "KYLE DUREPOS & MATTHEW DUREPOS");
```
