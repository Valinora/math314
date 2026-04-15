# MATH 314 Midterm Study Guide

## Part I: Conceptual / Multiple Choice Topics

### 1. Skewness and Central Tendency

- **Right-skewed**: mean > median (tail pulls mean right)
- **Left-skewed**: mean < median (tail pulls mean left)
- **Symmetric**: mean ≈ median

### 2. Variable Types

| Type | Description | Example |
|------|-------------|---------|
| **Nominal** | Categories, no order | Blood type, eye color |
| **Ordinal** | Categories with order | Letter grades, Likert scale |
| **Discrete numerical** | Countable values | Number of siblings |
| **Continuous** | Measurable on a scale | Height, weight, temperature |

Watch for tricky pairings:
- "Defective or working" → categorical (not numerical)
- "Student ID" → nominal (not continuous, even though it's a number)
- "Test scores 0-100" → ordinal (debatable, but the exam treats ranked scores as ordinal)

### 3. Z-Scores

$$z = \frac{x - \mu}{\sigma}$$

Note: σ is the **standard deviation**, not the variance. If given σ² = 9, then σ = 3.

Example: X ~ N(μ = 9, σ² = 9). Z-score of x = 6:
$$z = \frac{6 - 9}{3} = -1$$

### 4. Independence

Two events A and B are **independent** if any one of these equivalent statements holds:
- P(A ∩ B) = P(A) × P(B)
- P(A | B) = P(A)
- P(B | A) = P(B)

Key traps:
- Independent ≠ disjoint. Disjoint events (P(A ∩ B) = 0) with nonzero probabilities are **never** independent.
- P(A ∪ B) = P(A) + P(B) - P(A ∩ B). For independent events this becomes P(A) + P(B) - P(A)P(B), which is NOT simply P(A) + P(B) (unless they're disjoint).

### 5. R Commands for Distributions

| Prefix | Meaning | Returns |
|--------|---------|---------|
| `d` | density/mass | P(X = x) — the PMF or PDF value |
| `p` | probability | P(X ≤ x) — the CDF |
| `q` | quantile | x such that P(X ≤ x) = p — inverse CDF |
| `r` | random | simulated random values |

**Normal**: `dnorm(x, mean, sd)`, `pnorm(x, mean, sd)`, `qnorm(p, mean, sd)`
**Poisson**: `dpois(x, lambda)`, `ppois(x, lambda)`
**Binomial**: `dbinom(x, size, prob)`, `pbinom(x, size, prob)`
**Exponential**: `dexp(x, rate)`, `pexp(x, rate)`, `qexp(p, rate)`

Critical: `pnorm` and friends take **sd**, not variance. If given σ² = 9, pass `sd = 3`.

### 6. Variance Formulas

**Discrete** (given a PMF table):
$$\text{Var}(X) = \sum (x - \mu)^2 \cdot P(X = x)$$

Shortcut:
$$\text{Var}(X) = E(X^2) - [E(X)]^2 = \sum x^2 P(X=x) - \mu^2$$

**Continuous** (given a PDF f(x)):
$$\text{Var}(X) = \int_{-\infty}^{\infty} (x - \mu)^2 f(x)\,dx$$

Know the difference — the practice exam asks you to pick the right formula.

### 7. Identifying Distributions

| Situation | Distribution |
|-----------|-------------|
| Fixed n trials, same p each, count successes | **Binomial(n, p)** |
| Count of events in a fixed interval, events occur at constant average rate | **Poisson(λ)** |
| Continuous measurement, bell-shaped | **Normal(μ, σ)** |
| Time between events in a Poisson process | **Exponential(λ)** |

Key distinguisher: Binomial has a **fixed number of trials** and a **fixed probability**. If either of those isn't met, it's not binomial.

---

## Part II: Problem-Solving Topics

### 1. Discrete Random Variables (PMF Tables)

Given a PMF table with a missing probability:
- All probabilities must sum to 1: P(X=0) = 1 - P(X=1) - P(X=2) - ...

Then compute:
- **E(X)** = Σ x · P(X = x)
- **Var(X)** = Σ x² · P(X = x) - [E(X)]²

```r
x <- c(0, 1, 2)
p <- c(0.4, 0.2, 0.4)

ex <- sum(x * p)          # E(X)
varx <- sum(x^2 * p) - ex^2  # Var(X)
```

### 2. Poisson Distribution

Given a rate λ (events per unit time):

| Question | R Code |
|----------|--------|
| P(X = k) | `dpois(k, lambda)` |
| P(X ≤ k) | `ppois(k, lambda)` |
| P(X ≥ k) | `1 - ppois(k - 1, lambda)` |

**Scaling λ**: If rate is 5/day and you want a 5-day period, use λ = 25.

Practice exam examples:
- P(X ≥ 6) with λ = 5: `1 - ppois(5, 5)`
- P(X ≤ 3) with λ = 5: `ppois(3, 5)`
- P(Y ≥ 25) over 5 days at rate 5/day: `1 - ppois(24, 25)`

### 3. Normal Distribution

| Question | R Code |
|----------|--------|
| P(X ≤ a) | `pnorm(a, mean, sd)` |
| P(X ≥ a) | `1 - pnorm(a, mean, sd)` or `pnorm(a, mean, sd, lower.tail=FALSE)` |
| P(a ≤ X ≤ b) | `pnorm(b, mean, sd) - pnorm(a, mean, sd)` |
| Find x for bottom p% | `qnorm(p, mean, sd)` |
| Find x for top p% | `qnorm(p, mean, sd, lower.tail=FALSE)` or `qnorm(1-p, mean, sd)` |

Practice exam example (CD player life, μ = 4.1, σ = 1.3):
- P(breaks during 3-year guarantee): `pnorm(3, 4.1, 1.3)`
- P(lasts between 3 and 7 years): `pnorm(7, 4.1, 1.3) - pnorm(3, 4.1, 1.3)`
- 95th percentile of lifespan: `qnorm(0.95, 4.1, 1.3)`

### 4. System Reliability

**Sequential (series) system** — fails if ANY component fails:
```r
p.A <- 0.015; p.B <- 0.04; p.C <- 0.01

p.success <- (1 - p.A) * (1 - p.B) * (1 - p.C)
p.failure <- 1 - p.success
```

**Parallel system** — fails only if ALL components fail:
```r
p.all.fail <- (1 - p.D) * (1 - p.E) * (1 - p.F)
p.works <- 1 - p.all.fail
```

The logic:
- Series: P(works) = P(A works) × P(B works) × P(C works), then P(fails) = 1 - P(works)
- Parallel: P(fails) = P(A fails) × P(B fails) × P(C fails), then P(works) = 1 - P(fails)

### 5. MLE for Poisson (Derivation)

Given x₁, ..., xₙ iid ~ Poisson(λ):

**Step 1**: Write the log-likelihood:
$$\ell(\lambda | x) = \sum_{i=1}^{n} \left[ x_i \ln\lambda - \lambda - \ln(x_i!) \right] = \left(\sum x_i\right) \ln\lambda - n\lambda - \sum \ln(x_i!)$$

**Step 2**: Take the derivative:
$$\ell'(\lambda | x) = \frac{\sum x_i}{\lambda} - n$$

**Step 3**: Set to 0 and solve:
$$\frac{\sum x_i}{\lambda} - n = 0 \implies \hat{\lambda} = \frac{\sum x_i}{n} = \bar{x}$$

The MLE for the Poisson rate parameter is the sample mean.

---

## Other Topics From Homework (Fair Game for Exam)

### Conditional Probability & Bayes' Theorem

$$P(A|B) = \frac{P(A \cap B)}{P(B)}$$

$$P(A|B) = \frac{P(B|A) \cdot P(A)}{P(B)}$$

**Law of Total Probability** (to find P(B)):
$$P(B) = \sum_i P(B|A_i) \cdot P(A_i)$$

Strategy: Build a table of categories, their priors P(Aᵢ), and likelihoods P(B|Aᵢ). Compute P(B) via total probability, then apply Bayes.

### Exponential Distribution

- Rate λ = average events per unit time
- Mean = 1/λ, Variance = 1/λ²
- Median: `qexp(0.5, rate)` = ln(2)/λ
- **Memoryless property**: P(T > s + t | T > s) = P(T > t)

```r
# P(wait > 45 min) with rate 2/hour
pexp(0.75, rate = 2, lower.tail = FALSE)
```

### Binomial Distribution

- n = number of trials, p = probability of success
- Mean = np, Variance = np(1-p)
- **Assumptions**: (1) fixed n, (2) constant p, (3) independent trials, (4) two outcomes

Special case: Bernoulli is Binomial with n = 1. E(X) = p, Var(X) = p(1-p).

### Contingency Tables

Given a joint probability table:
- **Marginal** probability: sum across a row or column
- **Conditional** probability: P(A|B) = P(A ∩ B) / P(B)
- **Independence check**: P(A ∩ B) = P(A) × P(B)?
