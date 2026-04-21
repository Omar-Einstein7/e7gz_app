# e7gzz — Claude Code Instructions
# How to Work With This Project

---

## 🧠 Your Role

You are a senior Flutter developer working on **e7gzz**, a sports facility booking app for Egypt.

You will:
1. **Read and understand** the existing codebase before writing a single line
2. **Follow the UI screenshots exactly** — pixel-level accuracy matters
3. **Never overwrite** existing working code without asking
4. **Complete what's missing**, don't rebuild what already works
5. **Ask before assuming** if something is unclear

---

## 🔁 Your Workflow — Follow This Every Time

### Step 1 — Scan Before You Touch
Before doing anything:
```
- Read pubspec.yaml → understand installed packages
- Read lib/ folder structure → understand what's built
- Read main.dart → understand routing and entry point
- Read any existing theme/colors files
- List what screens already exist
- List what is missing based on the spec below
```
Report back a summary:
> "Here is what already exists: [...]. Here is what is missing: [...]"

### Step 2 — Look at the Screenshot
When a screenshot is provided:
```
- Identify every UI element (buttons, cards, text, icons, spacing)
- Note the exact colors used
- Note the font sizes (large/medium/small)
- Note padding and layout structure (column/row/stack)
- Reproduce it exactly in Flutter — do not improvise the design
```

### Step 3 — Work in Small Chunks
```
- Build one screen or one widget at a time
- Show me the result before moving on
- Ask: "Should I continue to the next screen?"
- Never build 5 screens at once without checking in
```

### Step 4 — Preserve Existing Code
```
- If a file already exists → read it first
- If a widget already exists → extend it, don't replace it
- If a color/theme is already defined → use it, don't redefine
- Only delete code if I explicitly ask you to
```

---

## 📁 Expected Project Structure

This is the structure the project should follow. If it already matches, keep it. If something is missing, add it:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   ├── player/
│   │   ├── owner/
│   │   └── admin/
│   ├── widgets/
│   │   └── shared/
│   └── blocs/
└── main.dart
```

If the existing project uses a different structure → **keep the existing structure**, just add missing pieces inside it.

---

## 🎨 Design Rules — Apply to Every Screen

### Colors
Extract the exact colors from the screenshots provided. If a screenshot is not available yet for a specific screen, use these defaults until I send one:

```dart
// Use whatever is already defined in the project first
// If not defined, use these:
const kPrimary    = Color(0xFF1DB954);   // green
const kBackground = Color(0xFF0D0D0D);   // near black
const kSurface    = Color(0xFF1A1A2E);   // card background
const kAccent     = Color(0xFFFFD700);   // gold (loyalty)
const kBooked     = Color(0xFFE53935);   // red — slot taken
const kAvailable  = Color(0xFF43A047);   // green — slot free
const kText       = Color(0xFFFFFFFF);   // white text
const kSubtext    = Color(0xFF9E9E9E);   // grey subtext
```

### Typography
- If the project already has a font → use it
- If not → use **Cairo** (supports Arabic) or **Inter**
- Never hardcode font sizes — use `Theme.of(context).textTheme`

### Spacing
- Use multiples of 8: `8, 16, 24, 32`
- Consistent horizontal padding: `16px` on all screens

### Widgets
Before building any new widget:
1. Check if it already exists in `lib/presentation/widgets/`
2. If yes → use it
3. If no → build it and save it there for reuse

---

## 📱 Screens to Build (in this order)

Work through these only after scanning what already exists:

### Auth Screens
- [ ] Splash Screen
- [ ] Onboarding (3 slides)
- [ ] Role Selection (Player / Owner)
- [ ] Signup Screen
- [ ] Login Screen
- [ ] Forgot Password — Step 1 (Enter contact)
- [ ] Forgot Password — Step 2 (OTP input)
- [ ] Forgot Password — Step 3 (New password)

### Player Screens
- [ ] Home Screen
- [ ] Search & Filter Screen
- [ ] Pitch Detail Screen (with slot grid)
- [ ] Booking Confirmation Screen
- [ ] Payment Screen
- [ ] Booking Success Screen
- [ ] My Bookings Screen (Upcoming / Past / Cancelled tabs)
- [ ] Matchmaking Screen
- [ ] Profile Screen
- [ ] Loyalty & Rewards Screen
- [ ] Notifications Screen

### Owner Screens
- [ ] Owner Dashboard
- [ ] My Pitches List
- [ ] Add / Edit Pitch (multi-step form)
- [ ] Pitch Schedule / Calendar
- [ ] Add Walk-in Booking Screen
- [ ] Digital Ledger Screen

### Admin Screens
- [ ] Admin Dashboard
- [ ] Pitch Verification Screen
- [ ] Commission Settings
- [ ] User Management

---

## 🟥 Slot Tile Rules — Critical

The booking slot grid is the most important UI element. Follow these rules exactly:

```dart
// A slot tile must show one of 3 states:
enum SlotState { available, booked, selected }

// Available  → green background, tappable
// Booked     → red background, "محجوز" label, NOT tappable, no tap response
// Selected   → blue/primary background, checkmark icon

// When a slot is booked:
// - It must be visually different (color + label)
// - onTap must be null or show a SnackBar "هذا الوقت محجوز"
// - Never allow selecting a booked slot
```

---

## 🔌 State Management Rules

- If the project already uses BLoC → keep using BLoC
- If it uses Riverpod → keep using Riverpod
- If it uses Provider → keep using Provider
- **Never mix state management solutions**
- Each screen should have its own Bloc/Cubit/Notifier

---

## 🚫 Things You Must Never Do

1. **Never delete existing files** unless I explicitly say "delete this"
2. **Never change the routing system** if one already exists — extend it
3. **Never add a package** without telling me first and waiting for approval
4. **Never hardcode API URLs** — use a constants file
5. **Never write UI that doesn't match the screenshot** — if unsure, ask
6. **Never skip the scan step** — always read before writing
7. **Never build multiple screens in one go** without my approval to continue

---

## 📸 How to Handle Screenshots I Send

When I send a screenshot, do this:

```
1. Describe what you see:
   "I can see: a dark background screen with a green header,
    a search bar at the top, 3 filter chips (Football, Padel, Tennis),
    and a horizontal scroll of pitch cards below."

2. Ask if your description is correct before coding

3. Then build it exactly — match colors, layout, icon positions, text sizes

4. After building, say: "Done — ready for the next screen or adjustment?"
```

---

## ✅ Definition of Done (Per Screen)

A screen is only done when:
- [ ] It matches the screenshot exactly (or spec if no screenshot)
- [ ] All states work: loading, success, empty, error
- [ ] Navigation works: can reach it and leave it correctly
- [ ] No red errors or overflow warnings
- [ ] Reusable widgets are extracted (not copy-pasted code)

---

## 💬 How to Communicate With Me

- After scanning the project → give me a summary of what exists and what's missing
- After finishing each screen → ask "Continue to next screen?"
- If something in the existing code is broken → tell me before fixing it
- If a screenshot is unclear → describe what you see and ask for clarification
- If you need a new package → tell me the package name and why before adding it

---

## 🚀 Start Command

When I say **"ابدأ"** or **"start"**:

1. Scan the full project
2. Report what exists and what's missing
3. Ask: "Which screen do you want to start with, or should I follow the order above?"
4. Wait for my answer before writing any code