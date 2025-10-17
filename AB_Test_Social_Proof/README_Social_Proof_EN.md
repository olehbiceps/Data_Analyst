
# 🧩 A/B Test: Social Proof on Paywall Screen

**Author:** Oleh Ustimov — Junior Data Analyst

---

## 📖 Description
This project analyzes an A/B test conducted in a mobile app.  
The goal was to determine whether adding **social proof elements** — for example, a ★4.8 rating and a message like “1,299 users upgraded to Premium” — on the paywall screen would increase purchase conversion compared to the control version.

---

## 🎯 Hypothesis
- **H1:** Users are more likely to buy when they see social proof.
- **H0:** There is no difference between the groups.

---

## 👥 Experiment Setup
- **Population:** new app installs that reached the paywall.
- **Split:** 50/50 (A — control, B — variant with social proof).
- **Daily traffic:** ~2,000 installs → ~680 paywall views/day.
- **Test duration:** July 3 – July 25 (23 days).

---

## 📊 Metrics & Statistical Test
- **Primary metric:** Conversion rate (install → payment).  
- **Method:** Two-sided **Z-test for proportions** (α = 0.05).  
- **Result:** Z = −7.52 | p < 0.00001 → difference is statistically significant.

| Group | Users | Conversion (%) | 95% CI |
|-------|--------|----------------|--------|
| A (Control) | 10,013 | 6.1 % | 5.6 – 6.6 % |
| B (Social Proof) | 9,985 | 8.9 % | 8.4 – 9.5 % |

**Absolute lift:** +2.8 pp  **Relative improvement:** ≈ 46 %

---

## 📈 Visuals
- Bar chart with 95 % confidence intervals.
- Conversion rate trend over time (A vs B).
- 1-page LinkedIn-style summary slide (16:9 PDF).

---

## ✅ Conclusions
- Variant B significantly increased conversion (p < 0.05).  
- Recommendation: roll out the Social Proof design to 100 % of users and monitor Refund/chargeback for 1–2 weeks.  
- Next hypothesis: test **value-based messaging** (e.g. “Get access to premium features that help you save time”).

---

## 🧠 Tools
`Python`, `Pandas`, `Matplotlib`, `StatsModels`, `Jupyter Notebook`

---

## 📁 Files
| File | Description |
|------|--------------|
| `AB_test_analysis_UA_GSheets.ipynb` | Full analysis notebook with Google Sheets integration |
| `ab_plan_amplitude_social_proof_samples.csv` | Sample size and duration calculations |

---

## 👨‍💻 Author
**Oleh Ustimov** — Junior Data Analyst  
[LinkedIn](https://www.linkedin.com/in/oleh-ustimov-1b5b99159/) · [GitHub](https://github.com/olehbiceps/Data_Analyst)

---

📅 October 17, 2025  
MIT License © Oleh Ustimov
