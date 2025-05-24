Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


## Getting Started

Follow these steps to set up and run the project locally with your own Databricks environment:

### 1. Clone the Repository

```bash
git clone https://github.com/ignaciomedinar/meetup_assignment.git
cd meetup_assignment/dwh

2. Upload Raw JSON Files to Databricks
Upload the raw JSON files from the data folder (or your own copies) into your Databricks environment.
I recommend creating a schema/database named staging and a folder named source inside it to keep your raw files organized, for example:


staging.source.events.json
staging.source.users.json
staging.source.groups.json

Important:
The staging .sql files in the models/staging directory reference the JSON files using a file path variable in the source CTEs.
You must update the file path in those files to match your actual file location in Databricks.

For example, in your models/staging/stg_events.sql file, you might see something like:

select * from json.`/Volumes/staging/source/source/events.json`

Change the path /Volumes/staging/source/source/events.json to the path where your JSON files are stored in your Databricks environment, e.g.:

select * from json.`/mnt/databricks/data/source/events.json`
Make sure each staging model points to the correct location for its respective JSON file.

3. Configure Your dbt Profile
Make sure your ~/.dbt/profiles.yml is configured to connect to your Databricks workspace with the correct credentials, schema, and database.

4. Run dbt Commands
Use dbt to build your models in order from staging to gold:

dbt deps          # Install dependencies if any
dbt seed          # Load seed data if applicable
dbt run --models staging  # Build staging views on your JSON files
dbt run --models bronze   # Build bronze tables with load timestamps
dbt run --models silver   # Build dimensions and fact tables
dbt run --models gold     # Build final data marts
dbt test          # Run tests on your models
dbt docs generate # Generate documentation site
dbt docs serve    # Serve documentation locally for browsing

5. Explore and Query
Once the models are built, you can query your tables in Databricks or explore the generated dbt docs site to understand the data lineage and model descriptions.
