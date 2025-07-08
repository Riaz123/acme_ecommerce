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