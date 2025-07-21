Welcome to my new dbt project - Maven Toys Store!

This project has helped me demonstrate a complete data pipeline : extracting data from source files, loading it into Snowflake, transforming and modeling the data with dbt Cloud (connected to GitHub), and extracting actionable insights from each table.

### **Snowflake**
I first started with loading my dirty dataset to Snowflake, I created a database called "MAVENDB", it had the folllowing tables:
1. calendar   - contains Dates
2. dictionary - contains 3 columns c1(tables), c2(Fields) and c3(description)
3. inventory  - contains store_id, product_id and stock_on_hand
4. products   - contains id, name, category, cost and price.
5. sales      - contains dates,product_id, sale_id and store_id along with the number of units sold
6. stores     - contains id, name, city, location and opened dates

### **dbt**
I then connected my dbt account "Project_2" to Snowflake and started exploring the dataset according to the Medallion Architecture.
I created the following folders:
1. **Bronze** : Injected the raw unprocessed data.
2. **Silver** : cleaned and conformed the data to remove duplicates and added certain transormations like, 
                1)Extracting the month names
                2)Changing the Column names to increase the readablity
                3)Calculating useful parameters like product_profit
3. **Gold**   :Has the data that is ready for consumption. The tables are finally transformed as follows:
                1)inventory-now calculates total stock in stores, total stock per product in store.
                2)products- comprises additional columnsthat calculates profit, tolal units sold and total sales revenue.
                3)stores- shows the stores age in years, months and category(legacy-if the store is more than 25 years old & standard- if it is less than 25 years)
4. **Snapshots** : to track the data changes like stock in hand and product prices over time.

### **Orchestration**
The next step was to schedule and manage the execution of the project.
Created a Production environment in dbt Cloud. Chose the correct deployment type for scheduled jobs.
Linked the environment to our Snowflake data warehouse and main code branch. Named the job "Production Daily Run".
Added command: dbt run.
Scheduled the job to run every 2 hours, every day.
Enabled notifications for job failures.


                 



