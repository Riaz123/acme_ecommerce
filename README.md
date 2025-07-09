# ae-programming-assignment
A starter project and instructions for the Accelerant Analytic Engineering programming assignment.

## Connecting to Snowflake
The file `snowflake_login_details.txt` contains the information you'll need to connect to the Accelerant Snowflake tenant.

When you first log on, you will be prompted to select a multi-factor authentication option. Currently, only Duo works with dbt.

## Setup
This project uses [dbt-core](https://docs.getdbt.com/docs/about-setup) and requires a local Python environment. It's highly recommended to use a Python virtual environment manager like [Miniconda](https://docs.conda.io/en/latest/miniconda.html) or [venv](https://docs.python.org/3/library/venv.html).

Steps:
1. Create your virtual environment, ensure you're running Python 3.10 or higher.
2. Ensure [pip](https://pip.pypa.io/en/stable/installation/) is installed
3. Install all requirements:
   ```pip install -r requirements.txt```
4. Install dbt dependent packages
   ```dbt deps```
5. Set the following environment variables using the values from the `snowflake_login_details.txt` file: 
   - `SNOWFLAKE_USER`
   - `SNOWFLAKE_PASSWORD`
   - `SNOWFLAKE_ROLE`
6. Verify that you can deploy and test the example models:
   ```dbt build```
    
    _NOTE:_ if using Duo for multi-factor authentication, you will need to approve it for every dbt command issued

## Assignment Details
You have been provided:

   - RAW data for a fictitious eCommerce site in a Snowflake instance
   - An empty database for you to transform and store your data models in
   - A set of business requirements in the form of User Stories which you will aim to fulfil 
      - User Story 1 is the focus of the test
      - User Story 2 is a stretch goal which you may optionally complete if you have the time to do so in amongst our busy schedules.

Estimated time to spend on this assignment: 4-6 hours.

It will be your responsibility to build a dbt project which will deliver the data models to meet the business requirements.

Your project will be scored on both your ability to meet the business requirements and how well you have adhered to dbt/Analytics Engineering best practices such as testing your code and keeping your code DRY etc.

You should aim to follow the structure laid out by dbt in their “how we structure our projects” guide: 

https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview

### User Story 1
As a Sales Manager

I would like a data model which I can query in order to report on the sales from our eCommerce platform. 

The two key measures that I need to report on are Order Quantity & Order Value.

I need to be able to drill down into the detail of each sale and therefore I will need to be able to view the sales data by:

   - Transaction Date

   - Transaction Month

   - Transaction Quarter

   - Transaction Year

   - Shipped Date

   - Shipped Month

   - Shipped Quarter

   - Shipped Year

   - Product Name

   - Product Category

   - Customer Name

   - Customer Email Address

   - Customer Country

   - Customer Region

   - Customer Sales Band

The Customer Sales Band will be derived from the total value of each Customer’s sales. The bands I would like to report on are:

   - $0-1000
   - $1001-5000
   - $5000+

I will be using this dataset to drive an electronic marketing campaign so please ensure that:

   - Any invalid email addresses have been removed
   - Any orders with a missing or invalid customer reference are excluded

### User Story 2 (Stretch Goal)
As a Finance Director

I would like a dataset which I can query in order to report on actual sales vs forecast sales and actual profit vs forecast profit generated from our eCommerce platform. I should be able to report on these values by product name, product category, month, quarter & year. Both the Sales Manager and myself will be presenting our figures to the board during a monthly meeting so it is important that the numbers which we present do reconcile.

## Solution

## Detailed Step-by-Step Logic of Data Transformations in the Star Schema dbt Project

1. Project Structure and Business Context
   
This dbt project is designed to deliver analytics-ready, trustworthy sales data for an eCommerce platform, fulfilling the Sales Manager’s requirements for reporting, drilldowns, and campaign targeting. The transformation pipeline is organized into three main layers:
	•	Staging: Cleans and standardizes raw source data.
	•	Intermediate: Enriches, aggregates, and derives business metrics.
	•	Mart (Star Schema): Presents denormalized, business-friendly fact tables for reporting.

2. Step-by-Step SQL Transformation Logic

   A. Staging Layer

    1. `stg_countries.sql`
   	•	Logic: Selects only active countries and renames columns for consistency.
   	•	Purpose: Ensures downstream models only work with valid, active country data.
   	•	Key Transformations:
   	•	`"alpha_3_country_code"` → `"iso_country_code"`
   	•	Filters where `"active_flag" = 'Y'`
   2. `stg_customers.sql`
   	•	Logic: Standardizes customer fields and filters to only valid email addresses.
   	•	Purpose: Ensures only customers with valid emails are included, supporting campaign quality.
   	•	Key Transformations:
   	•	Renames columns to snake_case and more descriptive names.
   	•	Uses the `validate_email` macro to filter out invalid emails.
   	•	Output: Clean, deduplicated customer records with valid emails.
   3. `stg_inventory.sql`
   	•	Logic: Standardizes product inventory fields.
   	•	Purpose: Ensures consistent product identifiers and cost data for margin calculations.
   	•	Key Transformations:
   	•	`"prodid"` → `"product_id"`
   	•	Selects `"purchase_price"`
   4. `stg_orders.sql`
   	•	Logic: Unifies quarterly order tables, standardizes columns, and filters out invalid orders.
   	•	Purpose: Provides a single, clean source of order data for all downstream models.
   	•	Key Transformations:
   	•	`UNION ALL` to combine all quarterly order tables.
   	•	Filters out orders with missing or blank `"customer_id"`.
   5. `stg_products.sql`
   	•	Logic: Standardizes product fields.
   	•	Purpose: Provides consistent product reference data for joins and reporting.
   	•	Key Transformations:
   	•	`"prodid"` → `"product_id"`
   	•	`"prodname"` → `"product_name"`
   	•	`"prodcat"` → `"product_category"`
   6. `stg_sales_forecast.sql` (inferred)
   	•	Logic: Standardizes forecast fields for joining with products.
   	•	Purpose: Prepares forecast data for actual vs. forecast analysis.
B. Intermediate Layer
1. `int_orders_enriched.sql`
   	•	Logic: Enriches order data with customer, product, and country details; calculates order value.
   	•	Purpose: Provides a single enriched record per order for reporting and further aggregation.
   	•	Key Transformations:
   	•	Joins orders to customers, products, and countries.
   	•	Filters out orders with missing customers.
   	•	Calculates `"order_value"` as `"quantity" * "unit_price"`.
2. `int_customer_sales_band.sql`
   	•	Logic: Aggregates total sales per customer and assigns each to a sales band.
   	•	Purpose: Enables segmentation of customers for reporting and campaigns.
   	•	Key Transformations:
   	•	Groups by `"customer_id"` and sums `"order_value"` to get `"total_sales"`.
   	•	Assigns `"sales_band"` based on `"total_sales"` using a `CASE` statement:
   	•	`$0-1000`, `$1001-5000`, `$5000+`
3. `int_actuals_by_product_month.sql`
   	•	Logic: Aggregates actual sales, revenue, cost, and profit by product and month.
   	•	Purpose: Supports time-based and product-based sales analysis.
   	•	Key Transformations:
   	•	Joins orders, products, and inventory.
   	•	Groups by `"product_id"`, `"product_name"`, `"product_category"`, and `"month"`.
   	•	Calculates:
   	•	`"actual_sales"` (sum of quantities)
   	•	`"actual_revenue"` (sum of quantity × unit price)
   	•	`"actual_cost"` (sum of quantity × purchase price)
   	•	`"actual_profit"` (revenue minus cost)
   	•	Extracts `"month"` from transaction timestamp.
4. `int_forecast_by_product_month.sql`
   	•	Logic: Joins forecast data with products for each month, casting numeric fields.
   	•	Purpose: Prepares forecast data for comparison with actuals.
   	•	Key Transformations:
   	•	Joins forecasts to products on `"product_name"`.
   	•	Casts `"forecast_sales"` and `"forecast_profit"` to numeric types.
   	•	Ensures `"month"` is consistently formatted.
C. Mart/Star Schema Layer
1. `fct_sales.sql`
   	•	Logic: Combines enriched order data with customer sales bands and derives all reporting drilldowns.
   	•	Purpose: Delivers a single, denormalized fact table for all sales reporting and campaign targeting.
   	•	Key Transformations:
   	•	Joins `int_orders_enriched` with `int_customer_sales_band` on `"customer_id"`.
   	•	Derives:
   	•	Transaction and shipped date fields at day, month, quarter, year levels.
   	•	Product and customer attributes for drilldowns.
   	•	`"customer_sales_band"` for segmentation.
	   •	`"order_quantity"` and `"order_value"` as the key measures.
2. `fct_actual_vs_forecast.sql` (from schema.yml)
   	•	Logic: (Not shown in SQL above, but inferred) Joins actuals and forecasts by product and month for variance analysis.
   	•	Purpose: Enables performance tracking against targets.
   	•	Key Transformations:
   	•	Joins `int_actuals_by_product_month` and `int_forecast_by_product_month` on `"product_id"` and `"month"`.
   	•	Coalesces actual and forecast fields for complete reporting.
   	•	Derives `"quarter"` and `"year"` from `"month"`.
3. DRY (Don’t Repeat Yourself) Implementation
   	•	Macros: The `validate_email` macro encapsulates email validation logic, ensuring it’s used consistently across models.
   	•	Modular Models: Each transformation (cleaning, enriching, aggregating) is in a separate model, so logic is written once and reused via `ref()`.
   	•	Centralized Business Logic: Sales banding and calculations are defined in one place, not duplicated.
4. Testing and Data Quality
   	•	Schema Tests in YAML:
   	•	`not_null` and `unique` for primary keys (e.g., `transaction_id`).
   	•	`not_null` for critical fields (e.g., `customer_email_address`).
   	•	`accepted_values` for sales bands (`$0-1000`, `$1001-5000`, `$5000+`).
   	•	Referential Integrity: (Recommended) Add `relationships` tests to ensure foreign keys (e.g., `customer_id`, `product_id`) always reference valid dimension records.
   	•	Data Quality in SQL: Filters for valid emails and non-null customers in staging and intermediate layers.
   	•	Documentation: YAML files describe each model and column for transparency and governance.
5. Best Practices Incorporated

   ![image](https://github.com/user-attachments/assets/4d4a4416-d154-4b7a-bdf9-05c982921037)

6. Transformation Flow Summary Table

   ![image](https://github.com/user-attachments/assets/ac3a25da-8bf8-4fda-8115-7756a5ff170a)

7. Business Use Case Alignment
	•	Order Quantity & Value: Calculated and exposed in `fct_sales`.
	•	Drilldowns: All requested fields (dates, product, customer, geography, sales band) are derived and exposed.
	•	Data Quality: Invalid emails and orders with missing customer references are excluded early.
	•	Campaign Readiness: Only valid, enriched, and segmented customer data is available for marketing.
In summary:
This dbt star schema project is modular, DRY, and testable. Each SQL transformation is purpose-built for data quality, business reporting, and analytics, with clear separation of concerns and robust testing/documentation throughout the pipeline.

