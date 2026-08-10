# Art Bible — Slime Survivor

## Canvas & Resolution

| Parameter | Value |
|---|---|
| Canvas | 1920 × 1080 |
| Internal Resolution | 480 × 270 |
| Pixel Scale | 4× |
| Tile Size | 16 × 16 |
| Character | 32 × 32 |
| Large Enemy | 48 × 48 |
| Boss | 64 × 64 – 128 × 128 |

## Color System

| Element | Hex | Usage |
|---|---|---|
| Background | `#1a1a2e` | Dungeon-Floor |
| Floor | `#16213e` | Room-Interior |
| Wall | `#0f3460` | Room-Borders |
| Shadow | `#000000` (40% α) | Depth |
| Player | `#00ff88` | HP Bar, Outline |
| Enemy | `#ff4444` | HP Bar, Damage |
| Elite | `#ffaa00` | HP Bar, Glow |
| Boss | `#ff0000` | HP Bar, Screen-Edge |
| Damage | `#ff3333` | Numbers, Flash |
| Healing | `#33ff33` | Numbers, Particles |
| Fire | `#ff6600` | Fire Effects |
| Ice | `#66ccff` | Ice Effects |
| Lightning | `#ffff00` | Lightning Effects |
| UI | `#ffffff` (80% α) | Text, Icons |

## Visual Hierarchy

```
BOSS HP BAR (center-top, largest)
    ↓
PLAYER HP + XP (top-left, prominent)
    ↓
DAMAGE NUMBERS (floating, color-coded)
    ↓
ENEMY HP BARS (above enemies, small)
    ↓
BUFF/DEBUFF ICONS (corners, icons)
    ↓
MINIMAP (top-right, small)
```

## Animation Guidelines

- **Idle:** 4 frames, subtle bounce
- **Walk:** 6 frames, smooth loop
- **Attack:** 6 frames, clear wind-up + impact
- **Death:** 6 frames, dissolve/fade
- **Hit:** 60ms white flash, no animation
