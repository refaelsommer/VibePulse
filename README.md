# VibePulse

SwiftUI + WidgetKit interview assignment.

## What is included

- One-screen SwiftUI vibe picker.
- Shared `VibeSnapshot` stored through App Groups.
- WidgetKit extension showing the latest vibe and weekly count.
- Every 7th pick triggers an in-app burst and a celebratory widget state.
- Widget deep link: `vibepulse://selected-vibe`.

## App Group setup

The project uses this placeholder group:

```text
group.com.refaelsommer.vibepulse
```

In Xcode, enable **App Groups** for both the app target and widget target, then either create this group or replace it in:

- `Shared/Vibe.swift`
- `VibePulse/VibePulse.entitlements`
- `VibePulseWidget/VibePulseWidget.entitlements`

## Next design pass

The functional skeleton is intentionally ready for a visual direction pass: photos, palette, brand style, and final animation personality.
