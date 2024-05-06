/*
What are the top skills based on salary?
- Look at average salary associated with each skill for Data Analyst positions
- Focus on roles with specified salaries, regardless of location
*/

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




