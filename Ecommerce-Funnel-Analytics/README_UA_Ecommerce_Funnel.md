# 🛍️ Ecommerce Funnel Dashboard

**Автор:** Oleh Ustimov  
**Проєкт:** Ecommerce Funnel Dashboard
**Посилання на дашборд:**  
🔗 [Ecommerce Funnel Dashboard — Looker Studio](https://lookerstudio.google.com/u/0/reporting/61c9e420-9c4a-400f-a24d-ac8b500f0ad4/page/tEnnC)

---

## 🎯 Мета проєкту
Мета — побудувати аналітичний дашборд, який показує шлях користувача від першої сесії до покупки.  
Цей дашборд допомагає маркетинговій команді визначити:
- На якому етапі воронки користувачі найчастіше "випадають";
- Які канали приносять найбільше покупок;
- Як змінюється конверсія в часі та залежно від джерела трафіку.

---

## 🧠 Джерело даних
- **Дані:** публічний датасет `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`  
- **Інструменти:**  
  - 🧩 **BigQuery** — SQL, CTE, JOIN, REGEXP_EXTRACT  
  - 📊 **Looker Studio** — інтерактивні візуалізації  
  - 📈 **Google Analytics 4 (GA4)**  

---

## 🧮 Основний SQL-запит

Основний запит об’єднує дані з подій GA4 на рівні сесій і формує датасет із кроками воронки продажів:

```sql
WITH
  first_cte AS (
    SELECT
      REGEXP_EXTRACT(
        (SELECT value.string_value FROM UNNEST(event_params)
         WHERE key = 'page_location'),
        r'(?:\w+:\/\/)?[^\/]+\/([^\?#]*)'
      ) AS landing_page_location,
      user_pseudo_id
        || CAST((SELECT value.int_value FROM UNNEST(event_params)
                 WHERE key = 'ga_session_id') AS STRING) AS user_session_id,
      event_name,
      event_date,
      traffic_source.source AS traffic_source,
      traffic_source.medium AS medium,
      traffic_source.name AS campaign,
      device.category AS device_category,
      device.operating_system AS device_system,
      device.language AS device_language,
      geo.country AS country
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'session_start'
  ),
  second_cte AS (
    SELECT
      user_pseudo_id
        || CAST((SELECT value.int_value FROM UNNEST(event_params)
                 WHERE key = 'ga_session_id') AS STRING) AS user_session_id,
      event_name,
      TIMESTAMP_MICROS(event_timestamp) AS event_timestamp
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name IN (
      'session_start', 'view_item', 'add_to_cart', 'begin_checkout',
      'add_shipping_info', 'add_payment_info', 'purchase'
    )
  )
SELECT
  f.event_date,
  f.traffic_source, f.medium, f.campaign,
  f.device_category, f.device_system, f.device_language, f.country,
  f.landing_page_location,
  s.event_name,
  s.event_timestamp,
  f.user_session_id
FROM first_cte f
LEFT JOIN second_cte s
  USING (user_session_id)
WHERE f.user_session_id IS NOT NULL;
```

---

## 📊 Основні результати
- 867 735 рядків у фінальному наборі даних  
- 354 857 унікальних сесій  
- 4 745 покупок  
- **Conversion Rate:** 1.34 %

---

## 📈 Візуалізації


1. **Conversion Funnel** — 7 кроків від Session Start до Purchase  
2. **Traffic by Campaign** — розподіл за каналами трафіку  
3. **Conversion Trend by Date** — зміна конверсії в часі  
4. **Purchase Conversion by Landing Page** — ефективність цільових сторінок  
5. **Traffic Sources Table** — порівняння джерел та кампаній

---

## ⚙️ Інтерактивні фільтри
Користувач може фільтрувати дані за:
- Датою початку сесії  
- Джерелом трафіку / кампанією  
- Країною  
- Мовою пристрою  
- Категорією пристрою  
- Операційною системою

---

## 💡 Висновки
- **Побудована чітка аналітична воронка** показує шлях користувача від першої сесії до покупки. Це дає змогу бачити втрати на кожному етапі та визначати найслабші точки у процесі конверсії.  
- **Найвищу ефективність демонструють organic і direct канали,** що підтверджує важливість SEO та прямого трафіку в утриманні користувачів.  
- **Desktop-пристрої мають найвищий коефіцієнт конверсії,** тоді як mobile має значно більший обсяг трафіку, але нижчу ефективність. Це відкриває напрям для UX-оптимізації мобільних сторінок.  
- **Пікові значення продажів припадають на грудень,** що може свідчити про сезонність попиту (святкові покупки).  
- **SQL-запит було оптимізовано для роботи з великим обсягом даних (867 735 рядків)**, що забезпечило точність результатів і стабільність роботи в BigQuery.  
- **Дашборд у Looker Studio став готовим бізнес-інструментом,** який дозволяє менеджерам швидко досліджувати дані, фільтрувати за країною, каналом або пристроєм та приймати рішення на основі фактів.  

---

## 👨‍💻 Автор
**Oleh Ustimov**  
📍 Чехія  
📧 [LinkedIn](https://www.linkedin.com/in/oleh-ustimov-1b5b99159) | [GitHub](https://github.com/olehbiceps)

© 2025 Oleh Ustimov
