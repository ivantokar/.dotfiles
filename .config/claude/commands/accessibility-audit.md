---
description: Check accessibility compliance for VoiceOver and keyboard navigation
---

Perform a comprehensive accessibility audit of the application:

## VoiceOver Support
1. All interactive elements have accessibility labels
2. Custom controls have proper traits
3. Images have descriptions
4. Reading order is logical
5. Grouping is appropriate

## Keyboard Navigation
1. Full keyboard access to all features
2. Visible focus indicators
3. Logical tab order
4. Standard keyboard shortcuts work
5. No keyboard traps

## Visual Accessibility
1. Color contrast ratios meet standards (4.5:1 for text)
2. Don't rely on color alone for information
3. Support for Increase Contrast
4. Support for Reduce Motion
5. Support for Reduce Transparency

## Dynamic Type
1. Text scales appropriately
2. UI doesn't break at larger sizes
3. Fixed sizes only where necessary (editor)

## Testing Steps
1. Enable VoiceOver (⌘F5) and navigate the app
2. Use only keyboard to complete common tasks
3. Test with Accessibility Inspector
4. Enable Increase Contrast and verify
5. Test with larger text sizes

Provide a report with:
- Issues found with severity (critical/major/minor)
- Specific locations in code
- Recommended fixes with examples
- Testing instructions

Reference Apple's Accessibility Guidelines:
https://developer.apple.com/accessibility/macos/
