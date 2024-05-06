# Introduction
Dive into the data job market! Focusing on Data Analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics. 

A capstone project from [SQL Course](https://www.youtube.com/watch?v=7mz73uXD9DA&t=13815s)

SQL Queries: [project_sql folder](/project_sql/)

*This project references a database of job market in 2023.*

# Background
### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn? 

# Tools I Used
- **SQL**
- **PostgreSQL**
- **VS Code**
- **Git & GitHub**

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. 

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field. 

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name

FROM job_postings_fact

LEFT JOIN company_dim ON
    company_dim.company_id = job_postings_fact.company_id

WHERE 
    job_location = 'Anywhere' AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL

ORDER BY salary_year_avg DESC

LIMIT 10
```
Here's the breakdown of the top data analyst jobs in 2023.

- **Wide Salary Range:** Top 10 paying data analyst roles span  from $184,000 to $650,000, indicating significant salary potential in the field
-**Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics

### 2. Skills for Top Paying Jobs
To understand what wkills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles. 

```sql
WITH top_paying_remote_jobs AS 
    (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name as company_name

    FROM job_postings_fact

    LEFT JOIN company_dim ON
        company_dim.company_id = job_postings_fact.company_id

    WHERE 
        job_location = 'Anywhere' AND
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL

    ORDER BY salary_year_avg DESC

    LIMIT 10
    )

SELECT 
    top_paying_remote_jobs.*,
    skills

FROM top_paying_remote_jobs

-- Inner join to remove any jobs from top_paying_remote_jobs that don't have skills listed
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = top_paying_remote_jobs.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id

ORDER BY salary_year_avg DESC
```
Here's the breakdown of the the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is also highly sought after with a count of 6. Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.


### 3. In-demand SKills for Data Analysts
This query helped identify the skills most frequently requested in job openings, directing focus to eares with high demand.

```sql

SELECT
    COUNT(job_postings_fact.job_id) AS job_count,
    skills
FROM job_postings_fact
INNER JOIN 
    skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN
    skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE

    job_title_short = 'Data Analyst' AND
    job_work_from_home = true
GROUP BY skills
ORDER BY job_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023.
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and  **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support

| Skills | Demand Count |
|--------|--------------|
| SQL    | 7291         |
| Excel  | 4611         |
| Python | 4330         |
| Tableau| 3745         |
| Power BI | 2690       |

*Table of the demand for the top 5 skills in Data Analyst job postings* 

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    ROUND(AVG(salary_year_avg),0) AS avg_salary,
    skills
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT null
GROUP BY skills
ORDER BY avg_salary DESC
```
Here's a breakdown of the results for top paying skills for Data Analysts.
- **High Demand for Big Data & ML Skills:** Top Salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (ElasticSearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics

| Skills | Average Salary ($) |
|--------|--------------------|
| pyspark    | 208,172        |
| bitbucket  | 189,155         |
| couchbase | 160,515         |
| watson| 155,486         |
| datarobot  | 154,500       |
| gitlab  | 153,750       |
| swift  | 152,277       |
| pandas  | 151,821       |
| elasticsearch  | 145,000       |
*Table of the average salary for the top 10 paying skills for Data Analysts*

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high deamand and have high salaries, offering a strategic focus for skills development.

```sql
SELECT 
    skills_dim.skill_id,
    skills,    
    COUNT(job_postings_fact.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),2) AS avg_salary

FROM job_postings_fact

INNER JOIN skills_job_dim ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id

WHERE
    job_work_from_home = true AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL

GROUP BY skills_dim.skill_id

HAVING COUNT(job_postings_fact.job_id) > 10

ORDER BY
    avg_salary DESC,
    demand_count DESC
```
| Skill ID | Skills | Demand Count  | Average Salary ($) |
|--|--|--|--|
| 8 | go | 27   | 115,320        |
| 234 | confluence | 11   | 114,210        |
| 97 | hadoop | 22   | 113,193        |
| 80 | snowflake | 37   | 112,948        |
| 74 | azure | 34   | 111,225       |
| 77 | bigquery | 13   | 109,654       |
| 76 | aws | 32   | 108,317       |
| 4 | java | 17   | 106,906       |
| 194 | ssis | 12   | 106,683       |
| 233 | jira | 20   | 104,918       |

*Table of the most optimal skills for Data Analyst in 2023*

Here's a breakdown of the most optimal skills for Data Analysts in 2023:
- **High Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued and also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** 
Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL, Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.


# What I Learned
Throughout this course, I've expanded my working SQL knowledge
- **Analytical Skills:** Sharpened my real-world puzzle-solving skills, turning raw data into sensible and actionable insights using SQL queries

- **Data Aggregation:** 
Became comfortable using GROUP BY and aggregate functions like COUNT() and AVG()

- **Working on bigger dataset:** 
My prior SQL experiences were mostly accessing databases using browser-based DB explorers. With this course, I've learned to setup databases (import csv files) and queries using PostgreSQL.


# Conclusions
### Insights
From the analysis, I've gathered several general insights:

1. **Top-Paying Data Analyst Jobs:** The highest paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest being $650,000

2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggestings it's a critical skills for earning a top salary.

3. **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.

4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on nice expertise.

5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salarym positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findingsd from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of Data Analytics. 
