# Relative Score Fusion (RSF): Normalization & Weighting

This document explains **Relative Score Fusion (RSF)**, a method for combining search results by normalizing their raw scores and applying weights. Unlike Reciprocal Rank Fusion (RRF), which only cares about *position* (rank), RSF preserves the *strength* of the match (score).

We will demonstrate this using the project's dataset: `@onemdb/mobile_reviews.json`.

## The Problem: Apples vs. Oranges

When combining Vector Search and Keyword Search (Lucene), you get scores on vastly different scales:
1.  **Vector Search (Cosine Similarity)**: Scores are usually between **0.0 and 1.0**.
2.  **Keyword Search (BM25/Lucene)**: Scores can be **0.0 to ∞** (often 5.0, 15.0, etc., depending on term frequency).

You cannot simply add them ($0.9 + 12.5 = 13.4$) because the Keyword score would totally dominate the result.

## The Solution: Normalization (Min-Max)

RSF scales both sets of scores to a common range (usually 0.0 to 1.0) before combining them.

**Formula:**
$$ S' = \frac{S - Min}{Max - Min} $$

**Final Score:**
$$ Score_{final} = (w_{vector} \cdot S'_{vector}) + (w_{keyword} \cdot S'_{keyword}) $$

---

## Demo Scenario

**User Query:** *"night photography"*

We have three products from `mobile_reviews.json` with hypothetical raw scores from two systems:

*   **`rev_011` (NightOwl X)**: *"Captures stunning details in complete darkness..."*
    *   *Vector Score:* **0.95** (High semantic match for concept of night/darkness)
    *   *Keyword Score:* **1.0** (Low, doesn't actually say "night photography")
*   **`rev_012` (Keyword King)**: *"Good for night photography. Night photography mode included..."*
    *   *Vector Score:* **0.75** (Decent match)
    *   *Keyword Score:* **15.0** (High, repeats exact phrase multiple times)
*   **`rev_013` (Lumia Pro)**: *"Excellent for night photography, producing clear images..."*
    *   *Vector Score:* **0.85** (Good balance)
    *   *Keyword Score:* **8.0** (Medium keyword usage)

### Step 1: Raw Scores Table

| Product | Raw Vector Score ($S_v$) | Raw Keyword Score ($S_k$) |
| :--- | :--- | :--- |
| **NightOwl X** | 0.95 (Max) | 1.0 (Min) |
| **Keyword King** | 0.75 (Min) | 15.0 (Max) |
| **Lumia Pro** | 0.85 | 8.0 |

### Step 2: Normalization

We normalize each column so the highest score becomes 1.0 and the lowest becomes 0.0.

**Vector Normalization:**
*   $Max = 0.95$, $Min = 0.75$, $Diff = 0.20$
*   **NightOwl X**: $(0.95 - 0.75) / 0.20 = \mathbf{1.0}$
*   **Keyword King**: $(0.75 - 0.75) / 0.20 = \mathbf{0.0}$
*   **Lumia Pro**: $(0.85 - 0.75) / 0.20 = \mathbf{0.5}$

**Keyword Normalization:**
*   $Max = 15.0$, $Min = 1.0$, $Diff = 14.0$
*   **NightOwl X**: $(1.0 - 1.0) / 14.0 = \mathbf{0.0}$
*   **Keyword King**: $(15.0 - 1.0) / 14.0 = \mathbf{1.0}$
*   **Lumia Pro**: $(8.0 - 1.0) / 14.0 = 7.0 / 14.0 = \mathbf{0.5}$

### Step 3: Weighted Fusion

Now we combine them. We can assign weights ($w$) to prioritize one system over the other.

#### Scenario A: Balanced (Weights: $0.5$ Vector, $0.5$ Keyword)
*   **NightOwl X**: $(0.5 \cdot 1.0) + (0.5 \cdot 0.0) = \mathbf{0.50}$
*   **Keyword King**: $(0.5 \cdot 0.0) + (0.5 \cdot 1.0) = \mathbf{0.50}$
*   **Lumia Pro**: $(0.5 \cdot 0.5) + (0.5 \cdot 0.5) = \mathbf{0.50}$
*   *Result: A three-way tie! The "middle ground" product performs as well as the specialists.*

#### Scenario B: Semantic Priority (Weights: $0.8$ Vector, $0.2$ Keyword)
*We care more about the meaning (low light performance) than exact words.*

*   **NightOwl X**: $(0.8 \cdot 1.0) + (0.2 \cdot 0.0) = 0.8 + 0.0 = \mathbf{0.80}$  (Winner)
*   **Keyword King**: $(0.8 \cdot 0.0) + (0.2 \cdot 1.0) = 0.0 + 0.2 = \mathbf{0.20}$
*   **Lumia Pro**: $(0.8 \cdot 0.5) + (0.2 \cdot 0.5) = 0.4 + 0.1 = \mathbf{0.50}$

#### Scenario C: Exact Match Priority (Weights: $0.2$ Vector, $0.8$ Keyword)
*We trust the user's specific terminology.*

*   **NightOwl X**: $(0.2 \cdot 1.0) + (0.8 \cdot 0.0) = 0.2 + 0.0 = \mathbf{0.20}$
*   **Keyword King**: $(0.2 \cdot 0.0) + (0.8 \cdot 1.0) = 0.0 + 0.8 = \mathbf{0.80}$ (Winner)
*   **Lumia Pro**: $(0.2 \cdot 0.5) + (0.8 \cdot 0.5) = 0.1 + 0.4 = \mathbf{0.50}$

---

## Comparison: RSF vs RRF

| Feature | Reciprocal Rank Fusion (RRF) | Relative Score Fusion (RSF) |
| :--- | :--- | :--- |
| **Input** | Rank positions only (1st, 2nd, 3rd) | Actual scores (0.95, 15.0) |
| **Sensitivity** | Robust to outliers. Doesn't care *how much* better #1 is than #2. | Sensitive to score distribution. If #1 has a massive score, it dominates. |
| **Tuning** | `k` constant (usually 60). Simpler. | Weights ($w_v, w_k$). More control. |
| **Best For** | "Black box" search engines where scores are incomparable or unknown. | Systems where you know the score distribution and want fine-grained control. |
