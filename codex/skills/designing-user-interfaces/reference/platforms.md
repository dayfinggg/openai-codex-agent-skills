# Platforms

Follow the conventions of the platform the product runs on, and check the current guidelines for the OS version the app targets.

## Apple platforms

### Liquid Glass

Liquid Glass is Apple's material for the controls and navigation layer, introduced in 2025 across iOS, iPadOS, macOS, watchOS, tvOS, and visionOS.

- Use it for the layer above content, such as tab bars, toolbars, sidebars, and navigation controls. Keep it out of the content layer, except for transient controls such as a slider while it is dragged.
- Standard SwiftUI and UIKit components adopt it automatically, so prefer them. Apply `glassEffect` to custom controls sparingly.
- Use the regular variant by default. The clear variant suits controls over photos and video, with a dimming layer behind text when the media is bright.
- Do not stack glass on glass.
- Users can change how transparent glass looks, and Reduce Transparency and Increase Contrast change it further, so legibility never depends on transparency and text meets contrast in every setting.

### Sizes and type

| Platform | Default hit target | Minimum | Default text size |
|---|---|---|---|
| iOS, iPadOS | 44 by 44 pt | 28 by 28 pt | 17 pt |
| macOS | 28 by 28 pt | 20 by 20 pt | 13 pt |
| watchOS | 44 by 44 pt | 28 by 28 pt | 16 pt |
| visionOS | 60 by 60 pt | 28 by 28 pt | 17 pt |
| tvOS | 66 by 66 pt | 56 by 56 pt | 29 pt |

Leave about 12 points around bezeled controls and 24 points around controls without a bezel.

### Conventions

- SF Pro and the system text styles, so Dynamic Type works, with text enlargement of at least 200 percent. SF Symbols for icons and system colors for dark mode and Increase Contrast.
- Tab bars for top-level sections on iPhone, sidebars on iPad and Mac, navigation stacks for drill-down, sheets for focused tasks.
- Respect safe areas, the Dynamic Island, and the home indicator, and never override system gestures such as swipe back.
- Ask for permissions in context, when the feature needs them, with a clear reason.

## Android and Material Design 3

- Material 3 components and dynamic color with color roles such as primary, surface, and on-surface, not fixed hex values.
- Touch targets at least 48 by 48 dp, even for a 24 dp icon. Material type scale with font scaling.
- Navigation bar for three to five top destinations on phones, navigation rail on tablets and foldables, and window size classes to adapt layouts. The back gesture always works.
- Use Material 3 Expressive where the brand calls for more shape, color, and motion, and keep core flows calm.

## Web

- CSS custom properties for tokens, `rem` for type and spacing so browser font settings apply, and container queries for components.
- Respect `prefers-color-scheme`, `prefers-reduced-motion`, and `prefers-contrast`.
- Target good Core Web Vitals, reserve space for images to avoid layout shift, and lazy-load below the fold.
