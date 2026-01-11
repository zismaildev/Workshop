# Reciprocal Rank Fusion (RRF): The Impact of `k_penalty`

This document explains how the `k_penalty` (or simply `k`) constant in the Reciprocal Rank Fusion (RRF) algorithm influences search rankings. We will demonstrate this using the project's dataset: `@onemdb/mobile_reviews.json`.

## What is `k` in RRF?

Reciprocal Rank Fusion (RRF) is a method for combining results from multiple search strategies (e.g., **Vector Search** for meaning vs. **Keyword Search** for exact matches) into a single, unified ranking.

The formula for calculating a document's score is:

$$ Score = \sum_{i} \frac{1}{k + rank_i} $$

Where:
*   **$rank_i$**: The position of the document in the $i$-th result set (1, 2, 3...).
*   **$k$ (penalty)**: A constant added to the rank to dampen the impact of high rankings.

### The Role of `k`
*   **Low `k` (e.g., 0 or 1)**: Emphasizes "Specialists". It heavily rewards documents that achieve the top spot (Rank 1) in *any* individual list, even if they perform poorly in others.
*   **High `k` (e.g., 60)**: Emphasizes "Generalists". It flattens the scoring curve, reducing the dominance of the #1 spot. This prefers documents that rank consistently well across multiple lists over those that are #1 in one but absent in others.

---

## Demo Scenario

**User Query:** *"reliable work phone with good camera"*

We have two hypothetical search systems ranking the data from `mobile_reviews.json`:
1.  **Vector Search (Semantic)**: Captures concepts like "reliable" and "work".
2.  **Keyword Search (Text)**: Matches exact terms like "camera", "reliable".

**Relevant Products:**
*   **`rev_008` (WorkHorse)**: *"Built for work. The battery is reliable but the camera photos are quite grainy."*
    *   *Profile:* Excellent for "work/reliable", poor for "camera".
*   **`rev_003` (Balanced G1)**: *"A great camera and a long-lasting battery. It balances camera quality and battery endurance perfectly."*
    *   *Profile:* Good at everything, consistent, but maybe not the *most* specialized "work" phone.

### Hypothetical Rankings

| Document | Vector Rank (Semantic focus) | Keyword Rank (Text match) | Profile |
| :--- | :--- | :--- | :--- |
| **WorkHorse (`rev_008`)** | **Rank 1** (Perfect semantic match for "work") | **Rank 10** (Matches "reliable", misses "good camera") | **The Specialist** (Aces one, fails other) |
| **Balanced G1 (`rev_003`)** | **Rank 4** (Good match) | **Rank 4** (Matches "camera", misses "work") | **The Generalist** (Consistent in both) |

---

## Calculation: The Effect of `k`

Let's calculate the RRF Score: $\frac{1}{k + r_{vector}} + \frac{1}{k + r_{keyword}}$

### 1. Low Penalty (`k = 1`)
*The curve drops off sharply. Being #1 is paramount.*

*   **WorkHorse (`rev_008`)**:
    $$ \frac{1}{1 + 1} + \frac{1}{1 + 10} = 0.500 + 0.090 = \mathbf{0.590} $$
*   **Balanced G1 (`rev_003`)**:
    $$ \frac{1}{1 + 4} + \frac{1}{1 + 4} = 0.200 + 0.200 = \mathbf{0.400} $$

**Winner:** **WorkHorse**.
**Analysis:** With a low `k`, the massive score from achieving Rank 1 (0.5) overpowered the consistent but lower rankings of the Balanced G1. The system prioritized the strong "work" signal despite the poor "camera" match.

### 2. High Penalty (`k = 60`)
*The curve is flattened. Being #1 provides a smaller advantage over being #4.*

*   **WorkHorse (`rev_008`)**:
    $$ \frac{1}{60 + 1} + \frac{1}{60 + 10} = 0.0164 + 0.0143 = \mathbf{0.0307} $$
*   **Balanced G1 (`rev_003`)**:
    $$ \frac{1}{60 + 4} + \frac{1}{60 + 4} = 0.0156 + 0.0156 = \mathbf{0.0312} $$

**Winner:** **Balanced G1**.
**Analysis:** The high `k` diluted the benefit of the top spot. The difference between Rank 1 and Rank 4 was negligible ($\approx 0.0008$). Because Balanced G1 didn't "fail" the keyword search (Rank 4 vs Rank 10), its consistency allowed it to win.

---

## Summary

| Strategy | `k` Value | Outcome | Best For... |
| :--- | :--- | :--- | :--- |
| **"I feel lucky"** | Low (1) | **WorkHorse** wins. | Users who want a perfect match on *at least one* criteria (e.g., extremely specific technical queries). |
| **"Best overall"** | High (60) | **Balanced G1** wins. | Users who want results that satisfy *all* aspects of their query reasonably well (standard search engines, e-commerce). |
