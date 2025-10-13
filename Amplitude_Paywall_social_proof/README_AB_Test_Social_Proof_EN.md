# A/B Test Plan — Paywall Social Proof (Amplitude-style)

### 📖 Description
This project presents a full A/B test plan following **Amplitude’s experiment design framework**.

The goal of this experiment is to test whether adding **social proof elements** (e.g. rating ★4.8 and a message like “1,234 users upgraded to Premium”) on the paywall screen increases **conversion to purchase** compared to the control version.

---

### 🧠 Hypothesis
> **H1:** Adding social proof increases the paywall view→purchase conversion rate compared to Control.  
> **H0:** There is no difference between Variant and Control.

---

### 👥 Target Audience
- **Population:** new installs reaching the paywall (first exposure only)  
- **Randomization unit:** user (installer ID)  
- **Split:** 50/50 between Control and Variant  
- **Daily traffic:** ~2,000 installs/day → ~680 paywall views/day  
- **Baseline conversion:** 17%

---

### 🎯 Metrics
- **Primary:** Paywall CVR (view→purchase within 24h)  
- **Secondary:** CTR on Buy button, time-to-purchase  
- **Guardrails:** Refund/chargeback rate, Install→purchase, SRM check  

These metrics were chosen to measure real purchase impact and ensure the change doesn’t harm trust or retention.

---

### 📈 Sample Size & Duration
| Expected Lift | Variant p₂ | n per group | Estimated days |
|---------------|-------------|--------------|----------------|
| +1.5 pp (17%→18.5%) | 0.185 | 10,185 | ~30 |
| +2.0 pp (17%→19%)   | 0.19  | 5,792  | ~18 |
| +2.5 pp (17%→19.5%) | 0.195 | 3,747  | ~12 |
| +3.0 pp (17%→20%)   | 0.20  | 2,629  | ~8 |

➡️ For a +3 pp expected lift (from 17%→20%), the test needs **~2,629 users per group (~8 days)**.  
Smaller effects require longer duration.

---

### ⚙️ Execution Plan
- Launch both variants via feature flag (freeze UI during the test).  
- Validate tracking events: `view_paywall`, `paywall_social_proof_shown`, `click_buy`, `purchase_succeeded`, `refund`.  
- Run for a fixed duration to reach the required sample size (avoid peeking).  
- Monitor SRM and guardrail metrics during and after test.

---

### ✅ Success Criteria
- Variant’s Paywall CVR is significantly higher (**p < 0.05**)  
- No regressions in Refund/chargeback or Install→purchase  
- **If success:** roll out to 100% + monitor for 1–2 weeks  
- **If neutral:** extend or stop test  
- **If worse:** revert and re-evaluate copy/placement

---

### 🔁 Alternative Hypotheses
If social proof doesn’t yield improvement, next ideas:
- **Value-based copy:** “Get access to advanced features that help you save time”
- **Social credibility badges:** “Editors’ Choice”, “Top-rated”
- **Soft urgency cues:** “Limited-time offer” (no dark patterns)
- **Plan structure test:** trial → $4.99/week

---

### 🧮 Files
- `Amplitude_AB_Test_Social_Proof_ENG.docx` — full test plan  
- `ab_plan_amplitude_social_proof_samples.csv` — MDE & duration calculations  

---

### 👨‍💻 Author
**Oleh Ustimov** — Junior Data / Product Analyst  
[LinkedIn](https://www.linkedin.com/in/oleh-ustimov-1b5b99159/) · [GitHub](https://github.com/olehbiceps/Data_Analyst)

---

### 🧾 License
MIT License © 2025 Oleh Ustimov
