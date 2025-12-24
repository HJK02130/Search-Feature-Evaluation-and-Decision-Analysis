# Understanding Search Functionality  
**SQL Case Study | Feature Evaluation & Search Experience Diagnosis**

This repository contains a structured SQL analysis that reproduces the key findings from  
**“Understanding Search Functionality: Answers” (ThoughtSpot SQL Analytics tutorial)**.  
It demonstrates a **hypothesis-driven analytical workflow** to evaluate whether an in-product search feature is performing well and worth prioritizing for improvement.

---

## 1. Problem Definition

The product team is considering investing engineering time to improve the site’s search functionality.  
Before committing resources, they want to understand:

- **Whether Yammer’s search experience is generally good or bad**
- **Whether users are deriving value from the search**
- **Where improvements could have the most impact**

The core question is not “Can we make search better?” but rather:  
> **Is it worth improving at all, and if so, in what ways?** :contentReference[oaicite:0]{index=0}

---

## 2. Hypotheses & Metrics

### 2.1 What Search Success Might Look Like

Before querying the data, we establish hypotheses about user search behavior:

1. Users *need* search — they use it frequently  
2. Successful search experiences are efficient — few refinements per session  
3. High engagement with search results implies relevance  
4. Poor ranking quality leads to clicks distributed across many result positions :contentReference[oaicite:1]{index=1}

---

### 2.2 Key Metrics

| Category | Insight |
|-----------|---------|
| Search Usage | Percentage of sessions with search |
| Autocomplete Usage | Percentage of sessions that use autocomplete |
| Search Runs per Session | How often users trigger full search |
| Clickthrough on Search Results | Distribution and frequency of clicks |
| Search Result Ranking Behavior | Whether clicks concentrate on top results |

All analyses here focus on interpreting **session-level user behavior** to assess search success. :contentReference[oaicite:2]{index=2}

---

## 3. Analysis (SQL-Driven)

The SQL queries in this repo are organized to measure the core hypotheses about search performance.

Each SQL file reproduces a key analytical step in understanding how users interact with search events.

---

### 3.1 Search & Autocomplete Usage

**Goal**  
Determine how commonly users invoke search and autocomplete relative to total sessions.

**Insight**  
- Autocomplete is used in roughly ~25% of sessions  
- Full search runs occur in ~8% of sessions :contentReference[oaicite:3]{index=3}

**Query**
- `01_search_autocomplete_usage.sql`

**Takeaway**  
Users *do* use search features, especially autocomplete — so search is relevant. :contentReference[oaicite:4]{index=4}

---

### 3.2 Search Frequency Within Sessions

**Goal**  
Analyze how many search runs occur per session and what it implies.

**Insight**  
- Users who run full search often run **multiple search queries per session** — a sign of frustration or iterative refinement :contentReference[oaicite:5]{index=5}

**Query**
- `02_search_runs_per_session.sql`

**Takeaway**  
Repeated full searches suggest search results may not be satisfying user intent. :contentReference[oaicite:6]{index=6}

---

### 3.3 Clickthrough Behavior

**Goal**  
Measure how often search results are clicked, and whether clicks concentrate on top ranks.

**Insight**  
- Sessions with search rarely produce clicks on search results  
- When clicks do occur, they are **evenly distributed across result positions** — not focused on top results :contentReference[oaicite:7]{index=7}

**Query**
- `03_search_click_distribution.sql`

**Takeaway**  
This behavior suggests poor result ranking — users don’t find the top results relevant. :contentReference[oaicite:8]{index=8}

---

## 4. Interpretations & Improvements

The data suggests a nuanced picture of search performance:

### 4.1 What’s Working

- **Autocomplete is frequently used**, indicating users seek quick, on-the-fly answers. :contentReference[oaicite:9]{index=9}  
- Users do engage with search, so the feature has real utility. :contentReference[oaicite:10]{index=10}

### 4.2 What’s Not Working

- **Full search runs are relatively rare** — potentially because users give up quickly. :contentReference[oaicite:11]{index=11}  
- Multiple full searches per session indicate possible dissatisfaction. :contentReference[oaicite:12]{index=12}  
- **Clickthrough patterns do not favor high-rank results**, implying ranking quality issues. :contentReference[oaicite:13]{index=13}

---

## 5. Recommendations

Based on the analysis, the opportunities for improvement include:

### 5.1 Improve Result Relevance & Ranking

- Reevaluate search ranking algorithms
- Tune relevance models so that top results better match user intent

### 5.2 Leverage Autocomplete Behavior

- Expand autocomplete features to surface richer results
- Integrate autocomplete suggestions dynamically into search outcomes

### 5.3 Track & Measure Post-Click Engagement

- Understand whether clicking a search result leads to deeper product engagement

These recommendations align with goals to improve efficiency and search success. :contentReference[oaicite:14]{index=14}

---

## Repository Structure

```text
.
├── README.md
├── sql/
│   ├── 01_search_autocomplete_usage.sql
│   ├── 02_search_runs_per_session.sql
│   ├── 03_search_click_distribution.sql
│   └── helpers.sql
└── output/
    ├── charts/
    └── results/
