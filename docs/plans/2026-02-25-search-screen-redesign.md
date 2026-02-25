# Search Screen Redesign — 2026-02-25

## Goal
Full glassmorphism redesign of `search_screen.dart` and all widgets in `search/widgets/`, consistent with the existing design system (Catppuccin + Apple Vision Pro aesthetic).

## Components

### SearchProfileCard (+ placeholder)
- Vertical glass card ~90×120px
- Circular avatar (56px) centered at top with 2px teal ring + teal glow shadow
- Username: bold, 11px, `onPrimary/0.90`, truncated
- Subtitle: event count or role, 9px, `onPrimaryContainer`
- Surface: `primaryContainer/0.60` + BackdropFilter blur(14) + `onPrimary/0.10` border + radius 20
- Placeholder: same shape with shimmer lines

### Section Headers
- Pinned glass pill: BackdropFilter blur(16) + `primaryContainer/0.70`
- 3px teal left accent bar
- Label: 13px, weight 700, uppercase, `onPrimary/0.85`
- Count badge: `secondary/0.15` fill + `secondary/0.40` border

### State Placeholders
- **Initial**: glass circle icon (teal search icon + glow) + title + subtitle + teal CTA pill
- **Empty**: same circle dimmed with search_off icon + "Aucun résultat pour «query»"
- **Loading**: vertical profile skeletons + existing event card placeholders

### Screen
- Profile horizontal scroll height: 130px (up from 100px)
- All BLoC logic, routing, scroll pagination unchanged
