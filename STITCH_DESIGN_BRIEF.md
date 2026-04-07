# 📱 **Mahafez** — Google Stitch Design Brief
## Comprehensive UI/UX Design Specification for AI Design Generation

---

## **Project Overview**

**App Name:** Mahafez (محافظ) — Business E-Wallet Transaction Tracker

**Purpose:** Help a business operating 5+ Vodafone Cash / InstaPay wallets track all incoming/outgoing payments in real-time. Multiple Android devices listen to payment SMS automatically; all team members (including iPhone users) see transactions instantly, can mark payments as settled, add notes, and view full audit history.

**Problem Solved:** 
- Team members couldn't verify if payment was already received/settled
- No searchable record of who paid what when
- Customers asking "Did you get my money?" led to confusion
- Solution: auto-synced, real-time, permanent record with full audit trail

**Why This Matters:** Non-technical operators need instant, zero-friction visibility into business cash flow. Zero WhatsApp chaos. One-tap payment confirmation.

---

## **Design Philosophy**

1. **RTL-First & Arabic Native** — Design assumes Arabic as primary language; English is secondary. All text aligns right; icons/buttons positioned for RTL tap patterns.
2. **Non-Technical Users** — Vocabulary simple, colors mean something (green=paid, red=unpaid), interactions are obvious (swipe right to mark paid).
3. **Glanceable Data** — A 5-second look at the app should answer: "Did we get paid today?" and "How much?" and "Who marked it?"
4. **Real-Time Feel** — Animations reflect live data: new transactions should appear with subtle entrance animation; status changes should reflect instantly.
5. **Accessible to Everyone** — Dad doesn't use apps much; everything should be big, clear, high contrast. Color-blind friendly (no red-green-only coding).
6. **Mobile-First** — Designed for phones (iOS 14+, Android 10+); assume 360-428px width as smallest, 412-600px as typical.

---

## **Color Palette & Theming**

### **System Default**
- App respects device dark/light mode
- Light theme: clean, high contrast, readable in sunlight
- Dark theme: comfortable for evening use, reduces eye strain

### **Semantic Colors** (same in light and dark)
- **Green (#10B981)** — Status: Paid ✅ | Interaction: Positive action
- **Red (#EF4444)** — Status: Unpaid 🔴 | Interaction: Negative/undo
- **Amber/Orange (#F59E0B)** — Warning: Swipe preview, pending action
- **Blue (#3B82F6)** — Medium amount tier, secondary info
- **Grey** — Low amount tier, disabled state, secondary text
- **Gold/Warm Orange (#FB923C)** — High amount tier
- **Dark Red (#B91C1C)** — Very high amount tier (>10k)

### **Amount Tier Badge Colors**
- **< 1,000 EGP** — Grey badge, small icon
- **1,000 – 4,999 EGP** — Blue badge, medium icon
- **5,000 – 9,999 EGP** — Orange badge, larger icon
- **≥ 10,000 EGP** — Red/Crimson badge, largest icon

### **Provider Badges**
- **Vodafone Cash** — Red/Orange background (brand color), white text: "فودافون كاش"
- **InstaPay** — Teal/Blue background, white text: "InstaPay"

---

## **Typography & Spacing**

### **Font Scale**
- **Display Large** — 32sp, bold — Transaction amount in detail sheet
- **Headline** — 24sp, bold — Screen titles, wallet number summary
- **Title** — 20sp, bold — Tab titles, section headers
- **Body** — 16sp, regular — Transaction list items, main content
- **Label** — 14sp, medium — Chip labels, badges, secondary info
- **Small** — 12sp, regular — Footnotes, timestamps, "by X · time ago"
- **Tiny** — 10sp, regular — Status history details

### **Spacing System**
- **4px** — Hairline spacing (rarely used)
- **8px** — Padding inside small chips, gaps in compact layouts
- **12px** — Standard gap between elements
- **16px** — Standard content padding (left/right margins)
- **24px** — Large gap, section separator
- **32px** — Extra large, screen margins in landscape

### **Line Height**
- Headlines: 1.2x
- Body: 1.5x
- Labels: 1.0x (tight)

---

## **Navigation Structure**

### **Bottom Tab Navigation**
```
┌────────────────────────────────────────┐
│                                        │
│ [Tab Content Area - all screen stack] │
│                                        │
├────────────────────────────────────────┤
│ [📥] [📤] [👛]  ⋯  [⚙️ Settings]     │
│ المستلم  المرسل  المحافظ    Settings  │
└────────────────────────────────────────┘
```

- **Tab 0 (default on launch):** 📥 المستلم / Received
- **Tab 1:** 📤 المرسل / Sent
- **Tab 2:** 👛 المحافظ / Wallets
- **Trailing Icon (AppBar):** ⚙️ Settings (always visible)

### **Recommended Icon Set**
- Use Material Design 3 icons for consistency
- **Inbox** for Received
- **Outbox** for Sent
- **Wallet** or **Account Balance Wallet** for Wallets
- **Gear/Settings** for Settings
- All icons should support RTL mirroring automatically

---

## **Screen 1: Login & Name Confirmation**

### **Login Screen (No User Logged In)**
**Layout:**
- Logo/app name "محافظ" centered top (if you have logo, place here; else just text)
- Tagline below: "إدارة محافظك الخاصة بالأعمال بسهولة" (Manage your business wallets easily)
- Large spacing
- `[Continue with Google]` button (full width, 56px height, Google branding)
- Horizontal divider: "أو / Or"
- Email input field (`your@email.com` hint)
- Password input field (masked, `••••••`)
- `[Sign In]` button (secondary color, 56px height, full width)
- Small text below: "ليس لديك حساب؟ / Don't have an account?" with "اشترك الآن / Sign Up Now" link
- Fine print bottom: "نحن نحترم خصوصيتك / We respect your privacy"

**Interactions:**
- Google Sign-In: opens native Google auth flow
- Email/Password fields: typical form validation
- "Sign Up Now" link: shows email/password form for registration
- After any successful auth: navigate to Name Confirmation screen

### **Name Confirmation Screen (Post-Auth)**
**Layout:**
- Headline: "ما اسمك؟ / What's your name?"
- Subheading: "سيظهر اسمك عند تحديث حالة الدفع / Your name appears when you mark payments"
- Text input field (auto-filled from Google displayName if Google auth, else empty)
- Placeholder: "مثلاً: أحمد محمود / e.g. Ahmed Mahmoud"
- `[تأكيد / Confirm]` button (primary color, full width, 56px)
- Optional: "تخطي / Skip" link (grey, small)

**Interactions:**
- Typing updates field in real-time
- Confirm button validates non-empty input
- On confirm: updates Firebase Auth displayName + Firestore user doc + sets `nameConfirmed=true` + navigates to Home
- If skipped: still navigates but shows again next session

---

## **Screen 2: Received Transactions Tab** (Default)

### **Layout Structure**
```
┌─ AppBar
│  └─ Title: "المستلم" (Received) | Trailing: Settings icon
├─ (Optional: Quick Stats Row)
│  └─ "اليوم: 2500 جنيه | التاريخ: 8500 جنيه" (Today/Period totals)
├─ (Optional: Filter/Search Bar)
│  └─ Search by name/phone, Date range picker
├─ Transaction List (Grouped by Date)
│  │
│  ├─ "اليوم / Today" — Sticky date header
│  │  ├─ Transaction Card 1
│  │  └─ Transaction Card 2
│  │
│  ├─ "أمس / Yesterday" — Sticky date header
│  │  └─ Transaction Card 3
│  │
│  └─ "الأحد، 2 أبريل / Sunday, Apr 2" — Sticky date header
│     └─ Transaction Card N
│
└─ Empty State (if no transactions)
   └─ Icon + "لا توجد عمليات / No transactions yet"
```

### **Transaction Card** (Received)
**Dimensions:** Full width, ~120px height, 12px left/right margin, 8px vertical gap between cards

**Visual Hierarchy:**
```
┌─ [Padding 12px]
│  ┌─ Row 1: Amount + Badge
│  │  ├─ "500 جنيه" [24sp, bold, green]
│  │  ├─ [AmountTier badge: Grey/Blue/Orange/Red]
│  │  └─ [Source badge: "فودافون كاش" / "InstaPay"]
│  │
│  ├─ Row 2: Counterparty
│  │  ├─ "محمد على" [16sp, bold]
│  │  └─ "01012345678" [14sp, grey]
│  │
│  ├─ Row 3: Metadata
│  │  ├─ "أحمد راضى" [14sp, grey] — who received it
│  │  └─ "اليوم 2:30م" [14sp, grey] — operation date
│  │
│  └─ Row 4: Status + Marked By (if paid)
│     ├─ "✅ مدفوع" [14sp, green] — if paid
│     │  └─ "بواسطة راضى • منذ ساعة" [12sp, grey, small]
│     └─ "🔴 غير مدفوع" [14sp, red] — if unpaid
│
└─ [Padding 12px]
```

**Interactive States:**
- **Default:** Subtle drop shadow, white/dark background
- **Hover:** 1px darker shade, shadow increases
- **Swiped Right (preview):** Green background, 0.3 opacity overlay, checkmark icon fades in
- **Swiped Left (preview):** Orange/red background, 0.3 opacity overlay, X icon fades in
- **Tap:** Navigation to detail sheet

**Gesture Recognition:**
- **Swipe right > 30% of card width** → Animate to 100%, show undo snackbar (3s)
- **Swipe left > 30% of card width** → Animate to 100%, show undo snackbar (3s)
- **Swipe back** → Reverse animation
- **Tap** → Open detail bottom sheet

### **Empty State (Received Tab)**
```
┌──────────────────────────┐
│                          │
│      📥 [Icon]          │
│                          │
│  "لا توجد عمليات مستلمة"  │
│   [No received trans]    │
│                          │
│  "الفحوصات المستلمة"     │
│  "ستظهر هنا"             │
│                          │
│  [Refresh button - light]│
│                          │
└──────────────────────────┘
```

---

## **Screen 3: Sent Transactions Tab**

### **Layout & Card Design**
- **Identical to Received tab** but:
  - No swipe actions
  - No status chip (sent = always "paid by definition")
  - Same transaction cards, read-only appearance (lighter shade, disabled cursor)
  - Tap still opens detail sheet (notes/history visible, but no status edits)

### **Sent Card Visual**
```
┌─ [Padding 12px]
│  ├─ Row 1: Amount + Badges
│  │  └─ "500 جنيه" + AmountTier + "تم إرسالها" (Sent label)
│  │
│  ├─ Row 2: Recipient
│  │  └─ "محمد على" + "01012345678"
│  │
│  ├─ Row 3: Metadata
│  │  └─ "أحمد راضى" + "اليوم 2:30م"
│  │
│  └─ Row 4: Static Label
│     └─ "تم إرسالها بنجاح" [12sp, green, italicized]
│
└─ [Padding 12px]
```

---

## **Screen 4: Wallets Tab** (New)

### **Layout Structure**
```
┌─ AppBar
│  └─ Title: "المحافظ" (Wallets)
├─ (Optional: Filter/Search)
│  └─ Provider filter chips: [All] [فودافون] [InstaPay]
├─ (Optional: Sort dropdown)
│  └─ "آخر نشاط / Last Activity" | "أعلى رصيد / Highest Balance" | "عدد العمليات / Most Transactions"
├─ Wallet List
│  ├─ Wallet Card 1
│  ├─ Wallet Card 2
│  └─ ...
└─ Empty State (if no wallets yet)
```

### **Wallet Summary Card**
**Dimensions:** Full width, ~140px height, 12px left/right margin, 12px vertical gap

**Visual Layout:**
```
┌─ [Padding 12px]
│  ├─ Row 1: Wallet Number + Provider
│  │  ├─ "01102564881" [18sp, bold]
│  │  └─ [Provider badge: "فودافون كاش" / "InstaPay" / "مختلط"]
│  │
│  ├─ Row 2: Balance (Large, Prominent)
│  │  ├─ "الرصيد الحالي:" [12sp, grey]
│  │  └─ "4,277.33 جنيه" [24sp, bold, primary color]
│  │     [Or grey if balance unavailable: "غير متاح"]
│  │
│  ├─ Row 3: Stats
│  │  ├─ "آخر عملية: اليوم 4:30م" [12sp, grey]
│  │  └─ "عدد العمليات: 42" [12sp, grey]
│  │
│  └─ Row 4: Chips (optional)
│     └─ [Receiving: 30] [Sent: 12] — mini chips showing direction split
│
└─ [Padding 12px]
```

**Interactive States:**
- **Default:** Subtle shadow, white/dark background, subtle divider at bottom
- **Tap:** Navigate to Wallet Transaction Explorer screen
- **Long-press** (optional): Copy wallet number to clipboard + toast

### **Wallet Transaction Explorer Screen**
**When user taps a wallet card, opens this modal/sheet:**

```
┌─ Header
│  ├─ Close button (X, top-left RTL = top-right)
│  ├─ Wallet number: "01102564881"
│  └─ Provider label
├─ Filter Chips (horizontal scroll)
│  ├─ [All] [Vodafone] [InstaPay] [Received] [Sent]
│  └─ Active filter highlighted in primary color
├─ Transaction List (same styling as Received/Sent tabs)
│  └─ Filtered transactions for this wallet
└─ Empty State (if no transactions match filters)
```

---

## **Screen 5: Transaction Detail Bottom Sheet**

**Trigger:** User taps any transaction card

**Layout:** Full-screen bottom sheet (draggable handle at top, swipe-down to close)

### **Section 1: Header**
```
┌─ Draggable Handle (grey pill, 4x40px, centered top)
├─ Amount (Display Large, 32sp, bold, primary color)
│  └─ "500.00 جنيه"
├─ Direction + Source Badges (row)
│  ├─ "مستلم" badge or "مرسل" badge
│  └─ "فودافون كاش" or "InstaPay"
├─ Operation Date/Time (Body, 16sp, grey)
│  └─ "الأحد، 5 أبريل 2026 • 4:30م"
└─ Divider
```

### **Section 2: Parties (Counterparty Info)**
```
├─ Row 1: Counterparty Name
│  └─ Label: "من / الذي أرسل" [12sp, grey] → Value: "محمد على" [16sp, bold]
├─ Row 2: Counterparty Phone (Tappable)
│  └─ Label: "رقم الهاتف" → Value: "01012345678" [tappable, blue, copy icon]
│  └─ Tap copies to clipboard + toast: "تم النسخ"
├─ Row 3: Received On Wallet
│  └─ Label: "استُقبل على" → Value: "01098765432" (device wallet number)
├─ Row 4: Received By Person
│  └─ Label: "استُقبل بواسطة" → Value: "أحمد راضى" (Firebase Auth displayName)
└─ Divider
```

### **Section 3: Status (Received Only; Sent Tab Shows Nothing)**
```
├─ Current Status (row)
│  ├─ Status Chip: "✅ مدفوع" [green] OR "🔴 غير مدفوع" [red]
│  └─ Toggle Button: [تغيير / Change]
│     └─ Tap → flips status, updates Firestore, animates chip color change
├─ Marked By Info (if status != null)
│  └─ "تم تحديثه بواسطة [name] في [date/time]"
│     └─ Text size 12sp, grey
└─ Divider
```

### **Section 4: Status History (Received Only)**
```
├─ Header: "سجل التغييرات / Status History" [14sp, bold, grey]
├─ Timeline (vertical list)
│  ├─ Entry 1
│  │  ├─ Timeline dot (green if → paid, red if → unpaid)
│  │  └─ "أحمد راضى غيّر من غير مدفوع إلى مدفوع"
│  │     "Timestamp: الأحد، 5 أبريل • 4:30م"
│  ├─ Entry 2
│  │  └─ (similar structure)
│  └─ ... (oldest at bottom)
└─ Divider
```

### **Section 5: Notes (All Transactions)**
```
├─ Header: "ملاحظات / Notes" [14sp, bold, grey]
├─ Note List (vertical)
│  ├─ Note Card 1
│  │  ├─ Author Avatar (initials, colored background)
│  │  ├─ Row 1: Author Name + Timestamp
│  │  │  └─ "أحمد محمود • منذ ساعتين" [12sp, grey]
│  │  ├─ Row 2: Note Text (editable on tap)
│  │  │  └─ "تم تسليم المبلغ للعميل" [14sp, black]
│  │  └─ Action Icons (hover/tap to reveal)
│  │     ├─ ✏️ Edit (inline edit field appears, replaces text)
│  │     └─ 🗑️ Delete (shows AlertDialog confirmation)
│  └─ Note Card N
├─ Add Note Button (full width, 44px)
│  └─ "[+ إضافة ملاحظة / Add Note]" [dashed border, grey]
│  └─ Tap → inline text field appears, user types + confirms (✓ button)
│  └─ New note added to top of list with current user name + timestamp
└─ Divider
```

### **Section 6: Open SMS** (Android Only, Same-Wallet Device Only)
```
├─ [Open SMS] Button (full width, secondary color, 44px)
│  └─ Only visible if:
│     - Platform.isAndroid == true
│     - smsId > 0 (valid SMS ID)
│     - tx.walletNumber == currentDeviceWalletNumber
│  └─ Tap → launches Android intent to open SMS app to that message
└─ [Close] Button (dismiss sheet)
```

### **Detail Sheet Interactions**
- **Draggable Handle:** Swipe down anywhere on sheet closes it
- **Status Toggle:** Immediate animation + Firestore update + snackbar confirmation
- **Notes:** Inline editing, real-time persistence
- **Open SMS:** Direct Android SMS app deep link

---

## **Screen 6: Settings Screen**

### **Layout**
```
┌─ AppBar
│  └─ Title: "الإعدادات / Settings"
├─ Profile Section
│  ├─ Avatar (initials)
│  ├─ Display Name (editable text field)
│  │  └─ Save button (hidden until text changes)
│  └─ Divider
├─ Device Info Section (Android Only)
│  ├─ Wallet Number (display-only text)
│  │  └─ Value: "[مسجل] 01102564881"
│  └─ Divider (iOS shows: "لا يلزم على iOS / Not required on iOS")
├─ Preferences Section
│  ├─ Language Picker (dropdown/radio)
│  │  ├─ System (default)
│  │  ├─ العربية
│  │  └─ English
│  ├─ Theme Picker (dropdown/radio)
│  │  ├─ System (default)
│  │  ├─ Light
│  │  └─ Dark
│  └─ Divider
├─ About Section
│  ├─ App Version (display-only)
│  │  └─ "الإصدار 1.0.0 / Version 1.0.0"
│  └─ Divider
└─ Sign Out Button (full width, red/warning color, 44px)
   └─ Tap → AlertDialog confirmation → signs out → navigates to Login
```

### **Display Name Edit**
- Text field pre-filled with current name
- Save button appears only when text differs from saved value
- On Save: Updates Firebase Auth displayName + Firestore doc + toast confirmation
- Validation: Non-empty, max 100 chars

---

## **Global Components & Patterns**

### **AppBar**
- **Background:** Matches theme (light/dark)
- **Title:** 24sp, bold, RTL-aligned (right-aligned in Arabic, left-aligned in English)
- **Trailing Icon:** Settings (gear icon, 24px, tappable with ripple effect)
- **Height:** 56px (Material standard)

### **Bottom Navigation Bar**
- **Height:** 56px (Material standard)
- **Labels:** Always visible (not hidden on unselected tabs)
- **Icons + Text:** Centered in RTL
- **Active Tab:** Primary color background, white icon + text
- **Inactive Tabs:** Grey icon + text, darker background on hover
- **Ripple:** 200ms animation on tap

### **Snackbar**
- **Position:** Bottom (standard)
- **Duration:** 3s for success, 5s for undo options
- **Action Button:** Always available (if applicable)
- **Text:** Centered, 14sp, high contrast on background
- **RTL:** Message text right-aligned

### **AlertDialog** (Status Confirmation, Delete Note, Sign Out)
- **Title:** 20sp, bold
- **Message:** 16sp, body text
- **Action Buttons:** 2-3 buttons (typically "Cancel" + "Confirm")
- **Buttons:** Full width, stacked or side-by-side on large screens
- **RTL:** Title and message right-aligned

### **Chip / Badge**
- **Heights:** 28px (small), 36px (medium), 44px (large)
- **Padding:** 8px horizontal, 4px vertical
- **Border Radius:** 16px (rounded pill)
- **Text:** 12sp, bold, contrasting color
- **Icon:** 16px, included inside padding
- **Filled chip:** Solid background, white text
- **Outlined chip:** Transparent, colored border, colored text

### **Text Input Field**
- **Height:** 48px (Material standard)
- **Padding:** 12px left/right
- **Border:** 1px solid on unfocused, 2px on focused (primary color)
- **Hint Text:** 12sp, grey, italicized
- **Label** (optional): 12sp, grey, floats above field on focus
- **Error State:** Red border, red error text below (12sp)

### **Button Styles**

**Primary Button** (Call-to-Action)
- Background: Primary color (blue)
- Text: White, 16sp, bold
- Height: 48-56px
- Border Radius: 12px
- Ripple: White 0.2 opacity on tap
- Width: Full width (standard)

**Secondary Button** (Alternative Actions)
- Background: Transparent
- Border: 1px primary color outline
- Text: Primary color, 16sp, bold
- Height: 44-48px
- Border Radius: 12px

**Danger Button** (Sign Out, Delete)
- Background: Red (#EF4444)
- Text: White, 16sp, bold
- Height: 48px

**Small/Icon Button** (Copy, Edit, Delete)
- Background: Transparent on default, grey on hover
- Icon only, 24px
- Ripple circle: 40px diameter

### **Loading States**
- **Spinner:** CircularProgressIndicator, centered on screen or inside card
- **Skeleton:** Light grey animated shimmer (if data is expected)
- **Placeholder:** "جاري التحميل... / Loading..." text

### **Empty States**
- **Large icon** (64x64px, grey)
- **Headline:** 20sp, bold, centered
- **Description:** 14sp, grey, centered, max 60 chars
- **Action button** (optional): "جديد / Retry" or similar
- **Total height:** ~200px, centered vertically in screen

---

## **Animation & Transitions**

- **Card swipe:** 300ms ease-out slide + fade
- **Status change:** 200ms color fade (old color → new color)
- **Snackbar slide-in:** 300ms ease-out from bottom
- **Bottom sheet appear:** 250ms ease-out slide from bottom
- **Tab switch:** 150ms fade (no slide)
- **Chip tap ripple:** 300ms scale + fade
- **Data list appear:** 100ms fade per item (staggered, 30ms apart)

---

## **Accessibility Considerations**

1. **Color Contrast:** All text meets WCAG AA (7:1 for body, 4.5:1 for secondary)
2. **Touch Targets:** All interactive elements ≥ 44x44px (minimum Android/iOS standard)
3. **Font Size:** Minimum 14sp for body text, 12sp for labels (readable without pinch-zoom)
4. **Semantic Labels:** All buttons have visible text + semantic meaning (no icon-only unless tooltip available)
5. **RTL Support:** Full RTL layout flipping (mirrors icon positions, reverses text alignment, etc.)
6. **High Contrast Mode:** Dark theme uses darker backgrounds to reduce glare
7. **Animation Accessibility:** Respect `prefers-reduced-motion` system setting

---

## **Localization Notes**

### **Arabic (Default) - RTL Layout**
- All text right-aligned
- Icons/buttons position mirrored (close ✕ on top-left, not top-right)
- Swipe directions preserved (swipe right to mark paid = natural RTL motion)
- Numerals: Use Arabic-Indic numerals (٠١٢٣٤٥٦٧٨٩) in some places (SMS display), Western (0-9) in others (amounts, dates) — follow design conventions

### **English - LTR Layout**
- All text left-aligned
- Icons/buttons standard LTR positions
- Same functionality, mirrored layout

### **Ambiguous Strings**
- "من" = "from/by" (context-dependent)
- "تم استلام" = "received" (past tense)
- "تم إرسال" = "sent" (past tense)
- All strings must be pulled from localization files (ARB format in Flutter)

---

## **Platform-Specific Notes**

### **iOS**
- Notch/safe area aware (top: 44-48px, bottom: 34px on iPhone 12+)
- Home indicator consideration (bottom: 24px minimum)
- Status bar color matches theme
- No SMS reading — view-only mode

### **Android**
- Status bar color matches theme + system bar icons (light/dark)
- Navigation bar consideration (bottom: 48-56px)
- Back button in bottom navigation handled by Flutter Navigator
- SMS reading enabled (background listener runs)

---

## **Responsive Breakpoints**

- **320px width:** Minimum (older devices)
- **360px width:** Small phone (typical Android)
- **390px width:** Medium phone (iPhone 13)
- **428px width:** Large phone (iPhone 14 Pro)
- **600px+ width:** Tablet (not in scope for first release, but plan for landscape)

At all breakpoints: 16px side padding, full-width cards minus padding.

---

## **Implementation Checklist for Designer**

- [ ] Create color palette (light/dark theme tokens)
- [ ] Design login screen (Google + Email/Password)
- [ ] Design name confirmation flow
- [ ] Design Received tab (cards, swipe states, empty state)
- [ ] Design Sent tab (read-only variant)
- [ ] Design Wallets tab + Wallet Explorer modal
- [ ] Design Transaction Detail sheet (6 sections)
- [ ] Design Settings screen
- [ ] Create typography scale (Material 3 recommended)
- [ ] Create spacing scale (4px, 8px, 12px, 16px, 24px, 32px)
- [ ] Create button styles (primary, secondary, danger, small)
- [ ] Create chip/badge variants (amount tiers, source providers, status)
- [ ] Design micro-interactions (swipe, tap, status toggle)
- [ ] Design empty states + loading states
- [ ] Verify RTL/LTR layouts mirror correctly
- [ ] Accessibility audit (contrast, touch targets, semantic meaning)
- [ ] Create component library/design system file
- [ ] Export all assets (@1x, @2x, @3x for mobile)
- [ ] Create animation specs (duration, easing curves)
- [ ] Create responsive grid system for different phone sizes

---

## **Design Inspiration & Reference**

- **Banking Apps:** Revolut, N26 (transaction clarity, real-time updates)
- **Business Apps:** Shared workspace tools, approval workflows (multi-user trust, shared context)
- **E-Payment:** Vodafone Cash official app, WhatsApp (simplicity, speed)
- **Arabic UI:** Medium blogs on RTL UX (e.g., by Rayan Alshagawi, Farah Qustiti)

---

## **Final Notes**

1. **Color consistency:** Use Material Design 3 tokens as baseline; adapt for Arabic market preferences
2. **Readability:** Test all text sizes at arm's length (typical phone viewing distance)
3. **RTL First:** Design in Arabic first, then mirror to English (not vice versa)
4. **Non-Technical User:** Ask yourself: "Would a 60-year-old understand this without instructions?"
5. **Real-Time Feel:** Emphasize that transactions appear instantly across all devices
6. **Trust/Transparency:** Make audit trail (who/when) visible everywhere — builds trust across the business
