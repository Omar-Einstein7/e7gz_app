# Design System: The Editorial Arena

## 1. Overview & Creative North Star: "The Digital Curator"
The objective of this design system is to transform a high-utility sports booking platform into a premium, editorial experience. We are moving away from the "busy" aesthetics of traditional booking engines and toward a **"Digital Curator"** philosophy. 

This system thrives on **intentional asymmetry, breathing room, and soft depth**. We don't just list football pitches; we curate athletic experiences. By leveraging expansive white space, overlapping glass layers, and high-contrast typography, we create a sense of professional luxury that builds immediate trust in the Egyptian market.

## 2. Colors & Surface Philosophy
The palette is rooted in the "Pitch Green" energy of the field, tempered by the "Deep Stadium Blue" of a night match.

### The "No-Line" Rule
**Explicit Instruction:** Do not use 1px solid borders to section content. Boundaries must be defined through **background color shifts** or **tonal transitions**. 
*   Place a `surface-container-low` card on a `surface` background to create separation. 
*   Visual hierarchy is earned through contrast, not outlines.

### Surface Hierarchy & Nesting
Treat the UI as physical layers of frosted glass.
*   **Base:** `surface` (#0b1326)
*   **Structural Sections:** `surface-container-low` (#131b2e)
*   **Interactive Cards:** `surface-container` (#171f33)
*   **Floating/Elevated Elements:** `surface-container-highest` (#2d3449) with 60% opacity and a 20px backdrop-blur.

### The "Glass & Gradient" Rule
To ensure the "Pitch Green" feels premium rather than "neon," use gradients.
*   **Signature CTA Gradient:** Transition from `primary` (#4be277) to `primary-container` (#22c55e) at a 135-degree angle. This adds "soul" and dimension to buttons.
*   **Glassmorphism:** For overlays (like booking summaries or filters), use `surface-variant` at 40% opacity with a `backdrop-filter: blur(16px)`.

## 3. Typography: The Editorial Scale
We use a dual-font strategy to balance athletic energy with functional clarity.

*   **Display & Headlines (Manrope):** This is our "Editorial" voice. Manrope’s geometric yet warm curves provide an authoritative, high-end feel. 
    *   *Usage:* Use `display-lg` for hero headlines (e.g., "The Pitch is Calling"). Use `headline-md` for stadium names.
*   **Body & UI (Inter):** Inter is our "Functional" voice. It handles high-density data—like booking times, EGP pricing, and payment details—with maximum legibility.
    *   *Usage:* `title-sm` for field specs; `label-md` for InstaPay/Vodafone Cash tags.

**Hierarchy Note:** Always maintain a high contrast ratio between `display` sizes and `body` sizes to avoid a "flat" layout.

## 4. Elevation & Depth
In this design system, depth is a feeling, not a shadow effect.

*   **The Layering Principle:** Achieve lift by stacking. A `surface-container-lowest` card placed on a `surface-container-low` section creates a natural, soft "sunken" or "raised" effect without a single drop shadow.
*   **Ambient Shadows:** Use only for high-importance floating elements (e.g., the final "Book Now" floating bar). 
    *   *Spec:* `0px 20px 40px rgba(0, 0, 0, 0.12)`. The shadow must be diffused and low-opacity.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility (e.g., input fields), use `outline-variant` (#3d4a3d) at **20% opacity**. Never use 100% opaque lines.
*   **Glassmorphism:** Use semi-transparent layers to allow the vibrant primary colors of the background to bleed through, making the layout feel integrated and "airy."

## 5. Components

### Buttons
*   **Primary:** Uses the **Signature CTA Gradient**. Border-radius: `full` (9999px) for a modern, athletic feel.
*   **Secondary:** `surface-container-highest` background with `on-surface` text. No border.
*   **Tertiary:** Transparent background, `primary` text, no-border. Used for "View All" actions.

### Cards & Booking Slots
*   **Rule:** Forbid divider lines. Use `md` (1.5rem) or `lg` (2rem) spacing to separate content.
*   **Booking Grid:** Use `surface-container-low` for unavailable slots and the `Signature Gradient` for selected ones.
*   **Radius:** Always use `xl` (3rem) for large stadium cards and `md` (1.5rem) for internal components.

### Input Fields (Payment & Search)
*   **Style:** `surface-container` background, `xl` corner radius.
*   **Focus State:** A 2px "Ghost Border" using `primary` at 40% opacity.
*   **Local Context:** Include dedicated icons for Egyptian payment methods (Vodafone Cash, InstaPay) as subtle `chips` within the flow.

### Sports-Specific Chips
*   **Status:** Use `primary-fixed-dim` for "Available" and `tertiary-container` for "Fully Booked." 
*   **Radius:** `full` (9999px).

## 6. Do's and Don'ts

### Do
*   **DO** use asymmetric layouts. Let a stadium image bleed off the edge of the screen to create a sense of scale.
*   **DO** use large typography for prices (e.g., "450 EGP"). Make the currency `label-sm` and the value `headline-sm`.
*   **DO** prioritize "Breathability." If a screen feels crowded, increase the vertical margin rather than adding a divider line.

### Don't
*   **DON'T** use pure black (#000000). Always use `surface` (#0b1326) for shadows and backgrounds to maintain the "Stadium Blue" depth.
*   **DON'T** use 1px dividers. They break the glass illusion. Use color blocks instead.
*   **DON'T** use sharp corners. This system is "Smooth UX"—everything should feel rounded, approachable, and high-velocity.