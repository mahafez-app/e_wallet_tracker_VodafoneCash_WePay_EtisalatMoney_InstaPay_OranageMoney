# Mahafez — Wallet Manager App — Product Definition
English Name: Mahafez
Arabic Name: محافظ

## 1. App Overview

This app helps business teams manage mobile wallets that receive and send money through SMS-based wallets such as Vodafone Cash and InstaPay.

The app is built for Egypt only.

The main idea is simple:
- A user signs in.
- The user adds wallets from the current phone.
- The app reads new SMS messages from that phone.
- The app creates transactions from those SMS messages.
- A business workspace lets multiple members view the same wallets and transactions.

The app is not a personal expense tracker.
It is a business wallet manager for shared use.

---

## 2. Product Goals

- Track wallet transactions from SMS.
- Show wallet balances and wallet stats.
- Let a business team share access to the same wallets.
- Keep the UI simple for non-technical users.
- Support multiple wallets per user.
- Support multiple wallets per workspace.
- Keep the model scalable for Firebase.

---

## 3. What the App Is Not

- It is not a bank app.
- It is not a personal spending app.
- It is not a push-notification-first app.
- It does not import old SMS messages in MVP.
- It does not try to guess wallet types from the phone number alone.

---

## 4. Core Product Rules

### 4.1 Wallet ownership

A wallet is not the same as a user.
A wallet is not the same as a workspace.

A wallet is the combination of:
- phone number
- provider

Example:
- `010xxxxxxxx + Vodafone Cash`
- `010xxxxxxxx + InstaPay`

The same phone number can have more than one wallet provider.

### 4.2 Device rule

The app depends on SMS reading from the current device.
When the user adds a wallet, the app must make it clear that:
- the wallet must exist on the current device
- the app reads SMS from this device only
- the app will not scan old messages in MVP

### 4.3 Provider detection

The app can use the phone number prefix to help the user preselect a SIM provider.
This is only a default choice.

The app must still let the user choose wallet providers that are valid for the current number.

For MVP:
- 010 can default to Vodafone SIM
- 011 can default to Etisalat / e& SIM
- 012 can default to Orange SIM
- InstaPay can be selectable separately

The app must not depend on the prefix as the only source of truth.

### 4.4 SMS import rule

The app reads only new SMS messages after the user gives permission.
It does not import the old inbox in MVP.

### 4.5 Duplicate rule

The same SMS must not create duplicate transactions.
Each SMS must have a unique external reference.

---

## 5. Main Entities

### 5.1 User

A user is the login account.

User data:
- name
- email
- createdAt

### 5.2 Wallet

A wallet represents one provider on one phone number.

Wallet data:
- phoneNumber
- provider
- deviceId
- ownerUid
- createdAt
- currentBalance
- lastBalanceAt

### 5.3 Workspace

A workspace is a business space.

Workspace data:
- name
- ownerUid
- createdAt

### 5.4 Workspace member

A workspace member is a joined user.

Members should not be stored as a plain list in the workspace document.
Use a subcollection for scalability.

Member data:
- joinedAt

### 5.5 Invite

An invite is used to add a user to a workspace.

Invite data:
- workspaceId
- email
- status
- createdBy
- createdAt
- respondedAt

Invite statuses:
- pending
- accepted
- rejected

### 5.6 Transaction

A transaction comes from an SMS message.

Transaction data:
- type: send or receive
- amount
- message
- isPaid
- externalId
- createdAt

### 5.7 Transaction note

A note is a hint added by users.

Note data:
- text
- createdBy
- updatedBy
- createdAt
- updatedAt

### 5.8 Transaction history

History keeps track of state changes such as paid and unpaid.

History data:
- action
- changedBy
- createdAt

---

## 6. Firebase Data Model

### 6.1 Collections

- `users/{uid}`
- `wallets/{walletId}`
- `wallets/{walletId}/transactions/{txId}`
- `wallets/{walletId}/transactions/{txId}/notes/{noteId}`
- `wallets/{walletId}/transactions/{txId}/history/{eventId}`
- `workspaces/{workspaceId}`
- `workspaces/{workspaceId}/members/{uid}`
- `workspaces/{workspaceId}/wallets/{walletId}`
- `invites/{inviteId}`

### 6.2 Why this structure

This structure is used because:
- it is easy to scale
- it avoids large list fields in a single document
- it keeps wallets and workspaces separate
- it supports many users, many wallets, and many businesses

---

## 7. Relationship Rules

### 7.1 User to wallet

A user can own multiple wallets.

### 7.2 Workspace to user

A workspace can have multiple members.

### 7.3 Workspace to wallet

A workspace can contain multiple wallets.

A wallet can belong to more than one workspace.

### 7.4 Member access

Any workspace member can view:
- wallets
- transactions
- wallet stats
- user stats inside that workspace

### 7.5 Workspace access

Only the workspace owner can invite users in the MVP.

Later versions can add more permissions if needed.

---

## 8. Invite Flow

### 8.1 Add invite

The owner enters an email address.
The app creates an invite with status `pending`.

### 8.2 User checks invites

The user sees pending invites on the Invitations screen.

### 8.3 User accepts or rejects

The user can:
- accept the invite
- reject the invite

### 8.4 Duplicate invite rule

The app should not create a second invite if:
- the user is already a member
- or there is already a pending invite for the same email and workspace

---

## 9. Wallet Add Flow

### 9.1 Add wallet from home

The user opens the Home screen and taps Add Wallet.

### 9.2 Enter phone number

The user enters the phone number.

### 9.3 Choose provider

The app shows wallet provider options.
The app can preselect a provider based on the phone number prefix.

### 9.4 Explain device limit

The app must tell the user:
- the wallet must be available on the current device
- the app reads SMS from this device
- the wallet is linked to the messages on this phone

### 9.5 Ask for SMS permission

The app asks for SMS permission only when the user adds the wallet.

### 9.6 Start reading only new SMS

The app starts reading new messages after permission is granted.

It does not import old messages in MVP.

---

## 10. Wallet and SMS Logic

### 10.1 SMS to transaction

Every supported SMS becomes a transaction.

The full SMS text should be stored in the transaction message field.
This helps with:
- debugging
- auditing
- later parsing changes

### 10.2 Balance extraction

The wallet card should show the current balance.
The balance is taken from the latest useful SMS message.

This is better than showing the balance only inside transaction details.

### 10.3 Transaction duplication

Each SMS should have a unique external ID.
This prevents the same SMS from being saved twice.

---

## 11. Home Screen

The Home screen is the main entry point after sign in.

It should show:
- the user’s workspaces
- the user’s wallets
- wallet cards with current balance
- wallet stats
- invitations
- a clear action to add a wallet
- a clear action to create a workspace

### 11.1 Do not use global quick stats on home

Global quick stats are not useful for this app layout.

Instead:
- each wallet card shows its own stats
- each workspace shows its own stats

### 11.2 Wallet card content

Each wallet card should show:
- provider
- phone number
- current balance
- total received
- total sent

### 11.3 Workspace card content

Each workspace card should show:
- workspace name
- number of wallets
- total received
- total sent
- latest activity

---

## 12. Workspace Screen

The workspace screen is the main business view.

It should show:
- workspace summary stats
- wallet list
- latest transactions preview
- a View All Transactions action

### 12.1 Workspace stats

Show:
- total received
- total sent
- wallet count
- member count

### 12.2 Wallet list inside workspace

Each wallet in the workspace should show:
- current balance
- total received
- total sent
- provider
- phone number

### 12.3 Transactions preview

Show a short list of recent transactions in the workspace.
Then allow the user to open the full transaction screen.

This is better than forcing all transactions onto one crowded page.

---

## 13. Transactions Screen

The transaction screen is the main list view.

### 13.1 Default display

The list should be grouped by date in the UI.
This is a display choice, not a data model choice.

### 13.2 Filters

The user can filter by:
- all
- send
- receive

The user can also filter by date:
- today
- yesterday
- last week
- last month
- custom range

### 13.3 Pagination

The transaction list must support pagination.
It must not load everything at once.

---

## 14. Transaction Details Screen

The transaction details screen should show:
- amount
- type
- provider
- wallet phone number
- full SMS text
- date and time
- paid or unpaid state
- notes
- history of paid and unpaid changes

### 14.1 Current balance in transaction details

Current balance is not needed inside transaction details.
It should be shown in the wallet card and wallet screen.

### 14.2 Actions

The user can:
- mark as paid
- mark as unpaid
- add a note
- edit a note
- delete a note
- see the paid/unpaid history

---

## 15. Notes and Hints

Notes are the main hint system for transactions.

Users can use notes to add context such as:
- order number
- customer name
- internal reference
- delivery note

Notes should be editable by workspace members.

The app should keep track of who created and edited the note.

---

## 16. Paid and Unpaid History

The app must keep transaction history when the user changes the paid state.

Example changes:
- unpaid → paid
- paid → unpaid
- unpaid → paid again

This history should be visible in the transaction details screen.

---

## 17. Stats

### 17.1 Wallet stats

Each wallet should have its own stats.

Show:
- total received
- total sent
- current balance

### 17.2 Workspace stats

Workspace stats are the sum of the workspace wallets.

Show:
- total received
- total sent
- wallet count
- member count

### 17.3 User stats

The app should also show user stats.

These stats are not limited to the workspace view.
They help the user understand all wallets they own.

Show:
- total received across all user wallets
- total sent across all user wallets
- wallet count

---

## 18. App Flow

### 18.1 Authentication

This phase is already complete.

### 18.2 After sign in

The user goes to Home.

### 18.3 Home actions

From Home, the user can:
- view workspaces
- view wallets
- add a wallet
- create a workspace
- see invitations

### 18.4 Add wallet flow

- enter phone number
- choose provider
- allow SMS permission
- start reading new messages
- show the wallet card with current balance

### 18.5 Workspace flow

- create workspace
- invite user by email
- user accepts or rejects
- workspace loads all linked wallets
- members view wallets and transactions

### 18.6 Transaction flow

- SMS arrives
- app creates transaction
- transaction appears in the wallet and workspace
- user can mark it paid or unpaid (for received transactions only)
- user can add notes
- history is saved

---

## 19. User Experience Rules

- Keep the UI simple.
- Use clear Arabic and English-friendly wording where needed.
- Do not show technical terms to normal users.
- Use business words like wallet, workspace, invite, paid, unpaid, notes, balance.
- Show the current balance on the wallet card.
- Show workspaces on the Home screen.
- Show wallet stats per wallet.
- Keep transaction lists fast and paged.

---

## 20. MVP Scope

### Included in MVP

- sign in
- add wallet
- SMS permission
- read new SMS only
- create transactions
- wallet current balance
- wallet stats
- workspaces
- invites by email
- workspace members
- workspace wallets
- transaction filters
- transaction grouping by date in UI
- transaction details
- paid / unpaid changes
- notes
- history

### Not included in MVP

- push notifications
- importing old SMS messages
- advanced permissions
- wallet auto-detection from SMS text only
- complex admin roles
- analytics dashboards

---

## 21. Suggested Build Phases

### Phase 1
- Authentication
- Home screen shell
- Add wallet UI
- Wallet model

### Phase 2
- SMS permission
- SMS reading
- transaction creation
- duplicate prevention

### Phase 3
- wallet screen
- transaction list screen
- filters
- date filtering
- grouping by date
- pagination

### Phase 4
- workspace creation
- invites
- workspace members
- workspace wallet sharing

### Phase 5
- notes
- paid/unpaid history
- wallet stats
- user stats
- workspace stats

### Phase 6
- performance improvements
- caching
- more provider support
- push notifications later

---

## 22. Important Decisions Already Made

- Egypt only.
- The app depends on SMS messages.
- Do not import old SMS in MVP.
- Do not guess wallet type from the number alone.
- Use separate wallets, workspaces, invites, and transactions.
- Show current balance on the wallet card.
- Show workspaces on the Home screen.
- Use pagination for transactions.
- Keep notes and paid/unpaid history.
- Keep wallet stats per wallet.
- Keep workspace stats inside the workspace screen.

---

## 23. Final Product Summary

The app is a Firebase-based business wallet manager for Egypt.
It helps a team track wallet SMS transactions, balances, notes, and paid/unpaid status.

A user signs in, adds wallets from the current device, allows SMS access, and starts seeing transactions.
A workspace lets multiple members share the same wallets and view the same transaction data.

The first release focuses on a simple and stable flow.
The system is designed so the data model can grow later without redesigning the whole app.

