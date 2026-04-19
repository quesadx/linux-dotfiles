# Color Palette - Niri Desktop Theme

## Primary Colors (User Specified)
- **Primary Purple**: `#866EC7` - Base accent color
- **Bright Purple**: `#8F71FF` - Interactive elements
- **Sky Blue**: `#82ACFF` - Information/Links
- **Cyan**: `#B7FBFF` - Highlights/Active states

## Extended Palette

### Backgrounds
- **Darkest**: `#0F0A1A` - Niri background/deepest layers
- **Dark**: `#1A1530` - Base background
- **Dark Alt**: `#241F3C` - Secondary/hovered backgrounds
- **Surface**: `#2D2850` - Card/panel backgrounds

### Text & Foreground
- **Text Primary**: `#E0DCFF` - Main text
- **Text Secondary**: `#A89BC6` - Secondary text
- **Text Muted**: `#6F5B8B` - Disabled/muted

### Borders & Decorations
- **Border**: `#866EC7` - Primary border color
- **Border Alt**: `#5A4A7F` - Secondary borders
- **Focus Ring**: `#8F71FF` - Window focus indicator

### States
- **Hover/Active**: `#8F71FF` - Interactive hover state
- **Selected**: `#82ACFF` - Selected/highlighted
- **Warning**: `#FFB366` - Warning state
- **Critical**: `#FF6B9D` - Error/critical state
- **Success**: `#95E1D3` - Success/valid state

## CSS/Config Implementation

### Bright Palette (for terminal)
```
Black:       #0F0A1A
Red:         #FF6B9D
Green:       #95E1D3
Yellow:      #FFE66D
Blue:        #82ACFF
Magenta:     #8F71FF
Cyan:        #B7FBFF
White:       #E0DCFF
```

### Border Radius (Fibonacci Sequence)
- `1px` - Subtle rounded corners
- `2px` - Small interactive elements
- `3px` - Buttons/inputs
- `5px` - **Recommended default** - Panels/cards/waybar
- `8px` - Large containers/rounded effect

## Usage Guide
- **Waybar**: Use `#1A1530` bg, `#E0DCFF` text, border-radius `5px` (bottom only)
- **Niri Focus Ring**: `#8F71FF` for active, `#5A4A7F` for inactive
- **Foot Terminal**: Custom ANSI colors from "Bright Palette"
- **Fuzzel Launcher**: `#1A1530` bg, `#E0DCFF` text, `#8F71FF` selection
