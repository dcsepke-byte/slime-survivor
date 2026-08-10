# Combat System — Regeln & Formeln

## Damage Formula

```
FINAL_DAMAGE = Base × Multiplier × Crit × Resistance + Bonus
```

| Komponente | Quelle | Beispiel |
|---|---|---|
| Base | Weapon/Ability | 10 |
| Multiplier | Buffs, Passives | 1.5 (Berserker) |
| Crit | Crit-Chance × Crit-Mult | 1.0 oder 2.0 |
| Resistance | Target Resists | 0.7 (30% Fire-Resist) |
| Bonus | Flat-Damage-Items | +3 |

## 11 Damage Types

| Type | Icon | Strong vs | Weak vs | Status |
|---|---|---|---|---|
| **Physical** | 🗡️ | — | Armor | Bleed |
| **Fire** | 🔥 | Ice, Undead | Water, Demon | Burn |
| **Ice** | ❄️ | Fire, Beast | Ice, Golem | Freeze |
| **Lightning** | ⚡ | Water, Metal | Ground | Shock |
| **Poison** | 🧪 | Organic | Mech, Undead | Poison |
| **Arcane** | ✨ | Physical | Arcane | Silence |
| **Shadow** | 🌑 | Holy, Life | Shadow | Curse |
| **Holy** | ☀️ | Shadow, Undead | Holy | Blind |
| **Bleed** | 🩸 | Organic | Armor, Mech | Bleed (stack) |
| **Explosion** | 💥 | Group, Swarm | — | Knockback |
| **True Damage** | 💀 | ALL | NOTHING | — |

## 14 Status Effects

| Status | Effect | Duration | Stack? |
|---|---|---|---|
| **Burn** | 3% HP/sec | 4s | Refresh |
| **Freeze** | Cannot move | 2s | No |
| **Shock** | 50% slow + chain | 3s | No |
| **Poison** | 2% HP/sec | 6s | ×5 |
| **Bleed** | 5 flat/sec | 4s | ×3 |
| **Curse** | -30% damage dealt | 5s | Refresh |
| **Slow** | -40% move speed | 3s | Refresh |
| **Stun** | Cannot act | 1.5s | No |
| **Silence** | No abilities | 4s | No |
| **Weakness** | -25% damage | 5s | Refresh |
| **Vulnerability** | +50% damage taken | 4s | Refresh |
| **Regeneration** | +2% HP/sec | 5s | Refresh |
| **Shield** | Absorbs next hit | Until broken | No |
| **Invulnerability** | Immune to damage | 2s | No |

## Informationshierarchie (HUD)

| Position | Info |
|---|---|
| Top-Left | HP Bar, XP Bar, Level |
| Top-Right | Minimap, Floor |
| Bottom-Left | Weapon Slots, Active Items |
| Bottom-Right | Abilities, Cooldowns |
| Center-Top | Damage Numbers (floating) |
| Center | Boss HP Bar (when active) |
| Corners | Buff/Debuff Icons |
