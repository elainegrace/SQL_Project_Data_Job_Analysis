/*
What are the top-paying data analyst jobs?
    - Identify the top 10 highest-paying Data Analyst roles that are available remotely.
    - Focuses on job postings with specified salaries (remove nulls)
    - Include company names
*/

WITH top_paying_remote_jobs AS

    (SELECT
        job_id,
        company_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date::DATE

    FROM
        job_postings_fact

    WHERE 
        job_title_short LIKE '%Data%Analyst%' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL

    ORDER BY
        salary_year_avg DESC
    
    LIMIT 10)


SELECT 
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name
FROM top_paying_remote_jobs
LEFT JOIN company_dim ON
    company_dim.company_id = top_paying_remote_jobs.company_id

