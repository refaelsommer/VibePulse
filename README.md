# VibePulse

Compact SwiftUI app with a WidgetKit companion for tracking a daily vibe.

## Features

- Pick one of six vibes: Focus, Power, Chill, Joy, Flow, or Spark.
- The app shows the selected vibe, weekly pick count, and progress toward the next burst.
- Every 7th pick opens an in-app celebration with confetti and orbiting vibe emojis.
- The widget shows the latest vibe and weekly count in small and medium sizes.
- Milestone widget entries use timeline phases for a short time-based celebration.
- Widget tap opens the app through `vibepulse://selected-vibe`.

## Shared Data

The app and widget sync through App Groups using:

```text
group.com.refaelsommer.vibepulse
```

The shared snapshot is stored in `UserDefaults` from `SharedVibeData`.

## Project Structure

```text
VibePulse/
  App/
  Components/
  Core/
    AppConfig/
    Design/
    Localization/
    Models/
    Persistence/
  Screens/

VibePulseWidget/
  Models/
  ViewModels/
  Views/
```

## Notes

- Main app: SwiftUI.
- Widget: WidgetKit.
- Shared model/config/design code is used by both targets.
- Widget animation is implemented with preplanned timeline entries because widgets cannot run continuous custom animations.
