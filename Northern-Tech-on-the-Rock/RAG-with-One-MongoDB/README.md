# Workshop: RAG to Basic with One MongoDB

This workshop module demonstrates how to build a Retrieval-Augmented Generation (RAG) capable system using **MongoDB Atlas** as a Vector Store. It specifically focuses on advanced hybrid search techniques to improve retrieval accuracy by combining Semantic Search (Vector) and Full-Text Search (Keyword).

## Project Overview

We use a dataset of mobile phone reviews to explore two powerful fusion algorithms:
1.  **Relative Score Fusion (RSF)**: Normalizes and weights raw scores from different algorithms.
2.  **Reciprocal Rank Fusion (RRF)**: Re-ranks results based on their position in multiple lists.

### Key Components

-   **Data Processing**:
    -   `mobile_reviews.json`: Raw dataset of reviews.
    -   `a.generate_embeddings.ipynb`: Python notebook to generate vector embeddings locally using **Ollama** (`qwen3-embedding` model).
    -   `mobile_reviews_with_embeddings.json`: Enriched dataset ready for MongoDB.

-   **Database Setup**:
    -   `b.mongodb_atlas_setup.ipynb`: Instructions and code to upload data to MongoDB Atlas and configure the **Vector Search Index**.

-   **Search Demos**:
    -   `c.rsf_demo.ipynb`: Implementation of **Relative Score Fusion**. Combines Vector and Keyword search with custom weights.
    -   `d.rrf_demo.ipynb`: Implementation of **Reciprocal Rank Fusion**. Combines results based purely on ranking position.

-   **Conceptual Documentation**:
    -   [`RSF.md`](./RSF.md): Deep dive into the math and logic behind Relative Score Fusion.
    -   [`RRF.md`](./RRF.md): Explanation of Reciprocal Rank Fusion and the impact of the `k` penalty constant.

## Prerequisites

1.  **MongoDB Atlas Account**: You need a cluster (M0 free tier works) to host the vector store.
2.  **Python 3.8+**: Recommended to use a virtual environment.
3.  **Ollama**: Installed locally for generating embeddings.
    -   Model: `ollama pull qwen3-embedding`

## Getting Started

1.  **Generate Embeddings**:
    Run `a.generate_embeddings.ipynb` to process the raw reviews and create vectors.

2.  **Setup MongoDB**:
    Run `b.mongodb_atlas_setup.ipynb` to push data to Atlas and create the required `vector_index`.

3.  **Explore Hybrid Search**:
    -   Open `c.rsf_demo.ipynb` to see how weighting semantic vs. keyword scores changes results (e.g., "Night photography").
    -   Open `d.rrf_demo.ipynb` to see how rank-based fusion provides a robust "out of the box" ranking without tuning weights.