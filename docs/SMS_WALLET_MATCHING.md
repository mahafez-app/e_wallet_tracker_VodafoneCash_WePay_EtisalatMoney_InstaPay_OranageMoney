# SMS Wallet Matching Logic

This document simplifies how we decide which wallet an SMS belongs to. Because users can have multiple wallets on one device (e.g., two Vodafone Cash numbers), we need a bulletproof way to assign incoming messages, and a different way to import old messages.

---

## 1. Incoming SMS (Real-Time Matching)

When a new SMS arrives, we run it through a strict **Process of Elimination**. 

If a step succeeds, we assign the wallet immediately. If it fails, we move to the next step.

### The 5-Step Pipeline:

1. **The 100% Guard:** Does the SMS mention exactly two numbers, and one is the sender/receiver you are interacting with? 
   ➔ *The other number MUST be your wallet. If it's your known wallet, match it. If we don't recognize it, silently drop the message.*

2. **The Easy Win:** Do you only use one tracked wallet for this provider? 
   ➔ *Match immediately.*
   
3. **Explicit Mention:** Did they explicitly mention your wallet number anywhere in the SMS text? 
   ➔ *Match immediately.*

4. **Nearest Balance Math:** (The most common fallback)
   If no numbers are mentioned, we use simple math. We check what the SMS says your new balance is, and we see which wallet's sequence makes sense.
   
   *Example: You send 500 EGP. The SMS says your new balance is 1500 EGP.*
   * **Wallet A (Current Balance 2000):** 2000 - 500 = 1500. *(Difference: 0)* ➔ **WINNER!**
   * **Wallet B (Current Balance 800):** 800 - 500 = 300. *(Difference: 1200)*
   
5. **Last Resort (LRU):** Very rarely, if both wallets perfectly tie because they have the exact same balance, we assign the transaction to the wallet you used longest ago.

---

## 2. Reading Inbox History (Initial Import)

When you link a new wallet and want to import past transactions, we have to sift through thousands of unordered messages. Instead of matching one fully known transaction, we build a **"Mathematical Chain."**

### How Chaining Works:

1. **Find The Anchors:** 
   We scan your inbox. Any message that explicitly mentions the phone number of the wallet you are adding is tagged as an absolute **Target**. 
   *All other messages for that provider are tagged "Ambiguous".*

2. **Crawl Next Door:**
   We look at the ambiguous message sitting chronologically **right next** to a known Target.

3. **Check The Math:**
   We see if the ambiguous message links to the Target perfectly.
   
   *Example Timeline:*
   * `Yesterday 2:00 PM` [Ambiguous]: *You sent 1000 EGP. New Balance: 3000 EGP.*
   * `Yesterday 5:00 PM` [Target]: *You received 500 EGP. New Balance: 3500. Your Wallet is 010...*
   
   Because `3000 + 500` equals the proven `3500` target, they mathematically click together! We now officially adopt the 2:00 PM message as a new **Target**.

4. **The Snowball:** 
   We repeat this step, crawling outward from every Target and absorbing adjacent messages until the math stops adding up.
