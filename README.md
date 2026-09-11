# Supply Chain Analytics & Operational Diagnostics — DataCo Global

**Financial performance, delivery risk and operational diagnostics using PostgreSQL, SQL, Power BI and DAX.**

![Power BI](https://img.shields.io/badge/Power%20BI-Data%20Analytics-F2C811?logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-SQL-4169E1?logo=postgresql&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-Business%20Logic-5E5E5E)

![Supply Chain Diagnostics](images/page2_diagnostics.png)

---

## Project Overview

This project analyzes the financial and operational performance of the **DataCo Global supply chain dataset** using PostgreSQL and Power BI.

Rather than building a traditional sales dashboard, the project combines financial performance with logistics diagnostics to investigate delivery risk and quantify the financial exposure associated with delayed shipments.

The final report is structured into three pages:

1. **Financial Performance** — Revenue, profitability and loss overview.
2. **Supply Chain Diagnostics** — Shipment performance, delivery risk and financial exposure.
3. **Conclusions & Recommendations** — Key findings, interpretation and proposed actions.

---

## Business Questions

The analysis was designed around the following business questions:

- How is the business performing financially?
- Which regions and product categories contribute most to revenue and profitability?
- How significant is the late-delivery problem?
- Which shipping modes present the highest delivery risk?
- Where is revenue exposure from delayed shipments concentrated?
- Which operational areas should be prioritized for further investigation?

---

## Dataset

The project uses the public **DataCo Smart Supply Chain for Big Data Analysis** dataset.

**Source:** [DataCo Smart Supply Chain — Kaggle](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)

The dataset contains approximately **180,000 records** covering orders, order items, customers, products, sales and shipping information.

Relevant fields include:

- `order_id`
- `order_item_id`
- `net_sales`
- `shipping_mode`
- `real_shipping_days`
- `scheduled_shipping_days`
- `delivery_status`
- `late_risk`
- `order_region`
- `order_country`
- `category_name`

---

## Tools & Technologies

- **PostgreSQL** — Data preparation, transformation and relational modeling.
- **SQL** — Data extraction, filtering, aggregation and joins.
- **Power BI Desktop** — Data modeling, interactive reporting and visualization.
- **DAX** — Business measures, KPI calculations and analytical logic.
- **Figma** — Supporting visual assets for report design.

---

## Analytical Process

The project followed an end-to-end analytics workflow:

```text
Raw Dataset
     ↓
Data Exploration & Validation
     ↓
PostgreSQL Transformation
     ↓
Relational / Star-Schema Model
     ↓
Power BI Data Model
     ↓
DAX Measures & KPI Definitions
     ↓
Dashboard Design
     ↓
Validation & Business Insights
     ↓
Recommendations
```
---

## Methodology

The project followed a structured analytical workflow:

### 1. Data Exploration

The data was profiled to understand:

- Table structure and relationships.
- Data types and missing values.
- Order and order-item granularity.
- Shipping and delivery fields.
- Potential sources of duplicate counting.

### 2. Data Modeling

The analytical model was structured around a central `fact_orders` table and supporting dimensions.

### 3. KPI Definition

Operational and financial KPIs were defined according to the grain of the data and the business question being analyzed.

### 4. Validation

Measures were checked against the underlying data to ensure that operational metrics were not inflated by the presence of multiple order items within the same order.

### 5. Visualization & Storytelling

The report was structured to move from:

**Financial Performance** → **Operational Diagnostics** → **Findings & Recommendations**

---
## Data Model & Granularity

The project uses a star-schema-oriented model with a central `fact_orders` table and supporting dimensions.

### Data Model

![Data Model](images/data_model.png)

The `fact_orders` table is stored at **order-item level**. This means that a single `order_id` can contain multiple `order_item_id` records.

For example:

```text
Order 1001
├── Order Item A
├── Order Item B
└── Order Item C
```

This distinction was important when defining the analytical measures:

- **Operational order/shipment metrics** use `DISTINCTCOUNT(order_id)` when the analysis is performed at order level.
- **Financial metrics** aggregate `net_sales` at the order-item level.
- **Logistics attributes** are connected through `order_item_id`.

Understanding the grain of the fact table helped prevent double-counting when calculating operational KPIs.

---

## Data Preparation

The original dataset was loaded into PostgreSQL and transformed into a relational analytical structure before being imported into Power BI.

### SQL Transformation Script

![SQL Transform](images/postgres_transform_script1.png),![SQL Transform](images/postgres_transform_script2.png)


### PostgreSQL Schema

![PostgreSQL Schema](images/postgres_schema.png)

The SQL transformation scripts used for the project are available in:

/sql/transform.sql

---

## Analytical Decisions

Several decisions were made to ensure that the KPIs reflected the business questions and the structure of the data.

### Operational KPIs

- Canceled shipments are excluded from operational delivery metrics because they do not represent completed delivery outcomes.
- Order-level operational metrics use distinct `order_id` counts to avoid counting multiple order items as separate orders.

### Financial Metrics

- Financial metrics aggregate `net_sales` at the order-item level because each order can contain multiple products.

### Revenue Exposure

- Revenue Exposure represents net sales associated with shipments flagged as late-risk, excluding canceled shipments.
- It is used as a proxy for financial exposure and should not be interpreted as confirmed lost revenue.

---

## Dashboard

### Page 1 — Financial Performance

The first page provides an executive overview of financial performance.

**Main KPIs**

| KPI | Value |
| :--- | :--- |
| Total Sales | $33.05M |
| Total Profit | $3.97M |
| Profit Margin | 12.00% |
| Average Order Value | $502.67 |

The page combines:

- Sales and profit trends over time.
- Regional profitability.
- Top product categories by sales.
- Sales vs. margin analysis.

![Page 1](images/page1_financial_performance.png)

---

### Page 2 — Supply Chain Diagnostics

The second page focuses on operational delivery performance and financial exposure.

**Main KPIs**

| KPI | Value |
| :--- | :--- |
| Total Shipments | 62,897 |
| Late Delivery Rate | 57.31% |
| Average Delay | 0.57 days |
| Revenue Exposure | $18.08M |

The page provides analysis by:

- Shipping Mode
- Region
- Country
- Product Category

A decomposition tree is used as an interactive driver exploration tool to investigate how late-delivery performance varies across different dimensions. It is not intended to establish causal relationships.

![Page 2](images/page2_diagnostics.png)

---

### Page 3 — Conclusions & Recommendations

The final page translates the analytical findings into business-oriented conclusions and potential actions.

![Page 3](images/page3_conclusions.png)

**Key Findings**

1. **First Class shows the highest delivery risk**
   First Class recorded a 100% late-delivery rate in the analyzed data, making it the highest-risk shipping mode and a priority for further investigation.

2. **Western Europe combines strong financial performance with significant exposure**
   Western Europe generated approximately $5.29M in sales with an 11.81% profit margin, while also showing approximately $1.8M in revenue exposure associated with delayed shipments.

3. **Standard Class shows the lowest late-delivery rate**
   Standard Class handled the largest shipment volume and recorded a 39.85% late-delivery rate, the lowest among the shipping modes analyzed.

**Recommendations**

The report proposes actions focused on:

- Investigating First Class routes, providers and delivery commitments.
- Prioritizing high-exposure regions for operational review.
- Examining whether practices associated with better-performing shipping modes could be replicated.
- Implementing earlier monitoring of shipments with elevated delivery risk.
- Reviewing cancellation patterns to understand potential operational losses.

---

## Key DAX Measures

The project includes DAX measures for financial performance, profitability and supply chain operations.

### Total Sales

```dax
Total Sales =
SUM(fact_orders[net_sales])
```
### Total Shipments
```dax
Total Shipments =
CALCULATE(
    DISTINCTCOUNT(fact_orders[order_id]),
    dim_shipments[delivery_status] <> "Shipping canceled")
```
### Late Deliveries
```dax
Late Deliveries =
CALCULATE(
    DISTINCTCOUNT(fact_orders[order_id]),
    dim_shipments[late_risk] = 1,
    dim_shipments[delivery_status] <> "Shipping canceled")
```
### Late Delivery Rate
```dax
Late Delivery Rate % =
DIVIDE(
    [Late Deliveries],
    [Total Shipments],
    0)
```
### Revenue Exposure
```dax
Revenue Exposure =
CALCULATE(
    SUM(fact_orders[net_sales]),
    dim_shipments[late_risk] = 1,
    dim_shipments[delivery_status] <> "Shipping canceled")
```
The full set of DAX measures is available in:

scripts/measures.dax

---

## Validation & Analytical Considerations

During development, the model and measures were validated against the underlying data structure.

An important finding was that the fact table contains multiple records for the same `order_id` because a single order can contain multiple order items.

Therefore:

- **Order-level operational metrics** → `DISTINCTCOUNT(order_id)`
- **Financial metrics** → `SUM(net_sales)`

This distinction reduces the risk of inflating operational KPIs by treating every order-item row as a separate order.

Operational delivery KPIs also exclude canceled shipments.

---

## Repository Structure

```text
supply-chain-dashboard/
│
├── README.md
│
├── dashboard/
│   └── Supply_Chain_Dashboard.pbix
│
├── scripts/
│   ├── transform.sql
│   └── measures.dax
│
└── images/
    ├── data_model.png
    ├── postgres_schema.png
    ├── postgres_transform_script1.png
    ├── postgres_transform_script2.png
    ├── page1_financial_performance.png
    ├── page2_diagnostics.png
    └── page3_conclusions.png
```

---

## How to Explore the Project

### Power BI

The `.pbix` file is included for inspection:

/dashboard/Supply_Chain_Dashboard.pbix

Open the file using Power BI Desktop.

Depending on the local environment, the PostgreSQL data-source connection may need to be updated before refreshing the model.

### SQL

The PostgreSQL transformation logic is available in:

/script/transform.sql


### DAX

The main DAX measures are documented in:

/script/measures.dax


---

## Limitations

This project uses a public dataset and does not represent a real company's internal operational data.

The analysis identifies patterns and areas for investigation, but the results should not be interpreted as proof of causal relationships.

Revenue Exposure represents net sales associated with delayed shipments and should not be interpreted as confirmed lost revenue.

Any operational targets shown in the dashboard should be interpreted as project benchmarks unless they are explicitly provided by the original dataset or source organization.

---

## Skills Demonstrated

- SQL querying and data transformation
- PostgreSQL relational modeling
- Star-schema concepts and data grain
- Power BI data modeling
- DAX measure development
- KPI definition and validation
- Data profiling
- Operational and financial analysis
- Business-oriented dashboard design
- Analytical storytelling
- Business recommendations

---

## About the Project

This project was developed as part of my transition into Data Analytics / BI, with a focus on practical SQL, Power BI, DAX, data modeling and business-oriented analysis.

The objective was to build an end-to-end analytical workflow rather than only create visualizations: from understanding the raw data and its grain, through transformation and modeling, to KPI definition, validation, visualization and business recommendations.

---

## Contact

**Oscar Davila**

- LinkedIn: [Your LinkedIn](https://www.linkedin.com/in/your-profile)
- GitHub: [Your GitHub](https://github.com/oscardavila-data/)
- Email: [your-professional-email@example.com](oscar.davilaenriquez@gmail.com)

---

## Dataset Attribution

**DataCo Smart Supply Chain for Big Data Analysis**

- [Kaggle Dataset](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
