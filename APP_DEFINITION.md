# 📱 **Mahafez** — E-Wallet Transaction Sync Tracker
## App Definition & Overview

---

## **What This App Solves**

**The Problem:**
Your business operates 5+ Vodafone Cash / InstaPay wallet numbers across different phones. When money is received:
- Team member A gets an SMS on their phone
- Team member B has no way to know if that money was already received or paid out
- Customers return asking "Did you get my money?" — and no one can verify without manual checking
- Tracking happens via WhatsApp groups or notebooks — chaotic, unsearchable, unmaintainable

**The Solution:**
Mahafez automatically reads incoming payment SMS from all business wallets, syncs them in real-time to a shared backend, and lets anyone (even on iPhone) mark payments as settled — with full history of who marked what and when.

---

## **Core Features at a Glance**

| Feature | What It Does |
|---------|-------------|
| **Auto SMS Sync** | Android devices silently read Vodafone Cash & InstaPay SMS; transactions appear on everyone's screen in ~200ms |
| **Received Tab** | All received transactions grouped by date; swipe to mark paid/unpaid; full history of status changes |
| **Sent Tab** | Read-only log of money sent out; provides context/proof |
| **Wallets Tab** | View all 5+ registered wallet numbers; each shows latest balance, transaction count, last activity |
| **Real-Time** | Everyone sees new transactions instantly; works offline too — syncs when reconnected |
| **Full Audit Trail** | See who marked a payment as settled and when; full status history preserved |
| **Notes** | Add hints to any transaction (e.g., "paid to customer John") — multiple notes per transaction, anyone can add/edit/delete |
| **Multi-Language** | Arabic (default) + English; respects system theme (light/dark) |
| **iOS + Android** | iPhone users get read-only view; Android devices do the SMS listening |
| **No Installation Friction** | Google Sign-In (preferred) or Email/Password; no sign-out required — session lasts forever until explicit logout |

---

## **Target Users**

- **Dad / Mom** — not tech-savvy; needs simple one-tap marking and instant visibility
- **You & siblings** — manage payments, verify claims, mark accounts settled
- **iPhone users** — view-only; see all transactions but don't receive SMS on your phone

---

## **Key Screens & Flows**

### **1. Login Screen**
- `[Continue with Google]` button (primary)
- Email / Password fields (secondary)
- One-time name confirmation after login

### **2. Received Tab** (default)
```
┌─ Today
│  ├─ محمد على   500 جنيه   [فودافون كاش]
│  │  من 01012345678 • أحمد راضى • غير مدفوع
│  │  
│  └─ سارة محمد   200 جنيه   [InstaPay]
│     من 01098765432 • أحمد • ✅ مدفوع (بواسطة راضى • أمس 4:15م)
│
├─ Yesterday
│  └─ [similar cards]
```
- **Tap card** → detail sheet (full history, notes, status timeline)
- **Swipe right** → mark paid (green indicator, undo option)
- **Swipe left** → mark unpaid (orange indicator, undo option)

### **3. Sent Tab**
- Same layout as Received, but read-only
- No swiping, no status marking
- Useful for viewing what was sent out

### **4. Wallets Tab**
- List of all registered wallet numbers
- Each card shows:
  - Wallet number (e.g., `01102564881`)
  - Provider (Vodafone Cash / InstaPay / Mixed)
  - Latest known balance (from last SMS)
  - Last transaction date
  - Total transactions count
- **Tap card** → Wallet Transaction Explorer
  - All transactions for that wallet number
  - Filter by provider (VF Cash only / InstaPay only)
  - Filter by direction (Received / Sent)

### **5. Transaction Detail Sheet**
Six sections (swipe up to expand):
1. **Header** — Amount (large), source badge, direction, date/time
2. **Parties** — Who sent/received, phone (tap to copy), wallet number, captured by
3. **Status** — Current status, who marked it, when (received only)
4. **History** — Timeline of all status changes (paid → unpaid → paid, etc.)
5. **Notes** — Add/edit/delete hints ("delivered to customer", etc.)
6. **Open SMS** — Android only; jump to the original SMS in your SMS app

### **6. Settings Screen**
- Edit display name (synced instantly)
- Wallet number info (Android) / "Not required on iOS" (iPhone)
- Language picker (System / العربية / English)
- Theme picker (System / Light / Dark)
- Sign Out button
- App version

---

## **Transaction Model**

Every transaction has:
- **Amount** (color-coded by tier: <1K gray, 1-5K blue, 5-10K orange, >10K red)
- **Source** (Vodafone Cash or InstaPay)
- **Direction** (Received or Sent)
- **Counterparty** (name + phone)
- **Wallet** (which business number captured it)
- **Captured By** (who received it on their phone)
- **Received Date/Time** (from SMS content, not server time)
- **Status** (for received: unpaid / paid; sent is always "paid")
- **Who Marked It Paid** (name + exact time)
- **Full History** (all status changes with timestamps)
- **Notes** (unlimited; anyone can add/edit/delete)
- **SMS Deep Link** (Android only; open original SMS)

---

## **Tech Stack** (for context)

- **Frontend:** Flutter (iOS + Android)
- **Backend:** Firebase Firestore (real-time sync, offline persistence)
- **Auth:** Google Sign-In + Email/Password via Firebase Auth
- **SMS Reading:** `another_telephony` (Android only)
- **State Management:** Riverpod
- **Localization:** ARB files (Arabic-first, English switchable)
- **Theme:** System default (Light/Dark override available)

---

## **Why This Matters**

1. **Zero Manual Entry** — SMS arrives on any device → appears on everyone's screens automatically
2. **Permanent Audit Trail** — Dad doesn't remember who paid him? Check the app. See the exact SMS, who marked it settled, when.
3. **No Lost Context** — Everyone can add notes ("delivered to customer", "pending", etc.) so no miscommunication
4. **Non-Technical** — Dad and Mom don't need WhatsApp or spreadsheets; just open app, see transactions, one-tap to mark settled
5. **Multi-Language** — Arabic-first comfort for business teams; option to switch to English for reference
6. **Scalable** — Works with 2 wallets or 10; adds new formats for new payment providers trivially

---

## **Success Metrics**

- ✅ All team members can verify "Did we get paid?" within 30 seconds
- ✅ No WhatsApp confusion about "who paid who when"
- ✅ Full audit trail of status changes (who marked, when)
- ✅ Works offline; syncs when internet returns
- ✅ Instant sync across all devices (< 1 second)
- ✅ Non-technical users (parents) can operate independently
