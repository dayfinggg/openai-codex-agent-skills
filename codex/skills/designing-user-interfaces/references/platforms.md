# Platforms

Follow the conventions of the platform the product runs on, because people bring their habits from every other app they use. Check the current guidelines for the OS version the app targets.

## Contents

- Apple platforms
- Android and Material Design 3
- Web

## Apple platforms

### Principles

The Human Interface Guidelines organize design around hierarchy, harmony, and consistency. Content leads and controls support it, the interface fits the shape and behavior of the device, and the app follows the system's conventions so it feels familiar.

### Liquid Glass

Liquid Glass is Apple's material for the controls and navigation layer, introduced in 2025 across iOS, iPadOS, macOS, watchOS, tvOS, and visionOS.

- Use it for the layer that floats above content, such as tab bars, toolbars, sidebars, and navigation controls. Do not use it in the content layer, except for transient controls such as a slider while it is being dragged.
- Standard SwiftUI and UIKit components adopt it automatically, so prefer them. Apply `glassEffect` to custom controls sparingly.
- Use the regular variant by default. The clear variant suits controls over photos and video, with a dimming layer behind text when the media is bright.
- Do not stack glass on glass.
- Users can change how transparent glass looks, and Reduce Transparency and Increase Contrast change it further, so never depend on transparency for legibility. Text must meet contrast in every setting.

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

- Use SF Pro and the system text styles so Dynamic Type works, and support text enlargement by at least 200 percent.
- Use SF Symbols for icons so they match text weight and scale.
- Use system colors, which adapt to dark mode and Increase Contrast.
- Tab bars for top-level sections on iPhone, sidebars on iPad and Mac, navigation stacks for drill-down, sheets for focused tasks.
- Respect safe areas, the Dynamic Island, and the home indicator.
- Support standard gestures, such as swipe back, and never override system gestures.
- Under Reduce Motion, replace movement and depth animations with fades.
- Ask for permissions in context, at the moment the feature needs them, with a clear reason.

## Android and Material Design 3

- Use Material 3 components and its dynamic color system, with color roles such as primary, surface, and on-surface instead of fixed hex values.
- Touch targets at least 48 by 48 dp, even when the icon is 24 dp.
- Use the Material type scale and support font scaling.
- Navigation bar for three to five top destinations on phones, navigation rail on tablets and foldables, back gesture always works.
- Use window size classes to adapt layouts across phones, tablets, and foldables.
- Material 3 Expressive adds more shape, color, and motion variety, so use it where the brand calls for it and keep core flows calm.

## Web

- Semantic HTML first, CSS custom properties for tokens, and layouts built with flexbox and grid.
- Responsive from 320 pixels wide upward, using content-driven breakpoints and container queries for components.
- Respect `prefers-color-scheme`, `prefers-reduced-motion`, and `prefers-contrast`.
- Use `rem` for type and spacing so browser font settings apply.
- Familiar patterns, such as the logo linking home, navigation at the top or side, search with a magnifier icon, and a visible cart or account area.
- Keep pages fast, because performance is part of UX. Target good Core Web Vitals, reserve space for images to avoid layout shift, and lazy-load below the fold.
- Every link looks like a link, and every button looks pressable.
