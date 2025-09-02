# DeathRoll Deluxe

DeathRoll Deluxe is a World of Warcraft addon that brings an interactive, high-stakes Death Roll gambling experience to your gameplay!

- Challenge friends
- Negotiate wager caps
- Set roll ranges
- Let the addon handle rolling, winner determination, and semi-automated gold trading
- Track your wins, losses, total profit, and view public stats for anyone you play with
- Enjoy a fully featured UI with action prompts—no chat commands required beyond the initial challenge

Whether you’re rolling for fun or fortune, DeathRoll Deluxe makes every coin count!

---

## Planned Features & User Story

### Gameplay Flow

- [x] **1. Challenge Initiation:**  
  - Player A (Challenger) targets Player B and types `/deathroll` or `/dr` to send a challenge.

- [ ] **2. Acceptance and Wager Cap:**  
  - Player B receives a prompt to accept (`/deathroll accept <max>`) or decline.  
  - Player B sets their max risk/wager.

- [ ] **3. Challenger Sets Final Wager:**  
  - Player A is notified of Player B's max.  
  - Player A sets the final wager (`/deathroll wager <amount>`), not exceeding B's limit.

- [ ] **4. Challenger Sets the Roll Max Number:**  
  - Player A is prompted to set the starting Death Roll max (`/deathroll max <number>`).

- [ ] **5. Who Rolls First:**  
  - Player B chooses who starts: `/deathroll start` (B rolls first) or `/deathroll pass` (A rolls first).

- [ ] **6. Gameplay:**  
  - Turns auto-rolled until someone rolls 1.  
  - Results announced in whispers/chat.

- [ ] **7. Trade and Payment Automation:**  
  - Addon announces winner/loser and wager amount.  
  - Loser is prompted to pay via trade window and "Pay Death Roll Wager" button.  
  - Button moves correct coin into trade window (manual confirmation required).

- [ ] **8. Stats Tracking & Public Lookup:**  
  - Tracks games played, wins, coin won/lost, total profit per player.  
  - Stats shown after each game.  
  - Anyone can type `/deathroll stats` (self) or `/deathroll stats <PlayerName>` (others) for public stats.

---

## Example UI Prompts

- Challenge, wager, roll max, and starter prompts are all handled by interactive windows/buttons.
- No chat commands required after the initial challenge.

---

## Stats

- [ ] Games played
- [ ] Total wins
- [ ] Total coin won
- [ ] Total coin lost
- [ ] Total profit
- [ ] Public stats lookup for all players
