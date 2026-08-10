# Game Feel — Hit-Feedback & Juice

## Hit-Feedback-Kette

```
Normal Hit:
  Enemy Flash (60ms white)
  → Damage Number (+color)
  → Hit SFX
  → Knockback (2px)
  → Particle Burst (small)

Critical Hit:
  ALL ABOVE +
  → Larger Number (+50% scale)
  → Stronger SFX
  → Larger Particles
  → Screen Shake (2px, 50ms)
  → Enemy Flash (yellow)

Kill:
  ALL ABOVE +
  → Death Animation (6 frames)
  → XP Orb flies to player
  → Death SFX
```

## Boss Death (Spektakel)

```
Boss HP = 0
  → Freeze Frame (100ms)
  → Movement Stop
  → Screen Shake (10px, 400ms)
  → Explosion (center)
  → Particle Burst (200 particles, radial)
  → Loot Explosion (items fly outward)
  → Music Change
  → Victory Banner (top center)
```

## Damage Numbers

| Type | Color | Size | Example |
|---|---|---|---|
| Physical | White | 16px | 25 |
| Fire | Orange | 16px | 25 |
| Ice | Light Blue | 16px | 25 |
| Lightning | Yellow | 16px | 25 |
| Poison | Green | 16px | 25 |
| Crit | Gold, bold | 22px | **50!** |
| Healing | Green | 16px | +10 |

## Screen Effects

| Trigger | Effect | Duration |
|---|---|---|
| Low HP (<25%) | Red Vignette + Heartbeat | Permanent |
| Level Up | Gold Flash + SFX | 500ms |
| Boss Appears | Screen Edge Darken | 2s |
| Room Clear | Brief Bright Flash | 300ms |

## Audio Priorities

| Priority | Sound |
|---|---|
| 1 (highest) | Player Hit |
| 2 | Player Death |
| 3 | Boss Death |
| 4 | Critical Hit |
| 5 | Normal Hit |
| 6 | Enemy Death |
| 7 | Fireball Cast |
| 8 | UI Click |
