/*
Find the count of the number of remote job postings per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill
*/

WITH skills_to_jobs AS
    (SELECT *
    FROM skills_job_dim
)

SELECT 
    COUNT(skills_to_jobs) AS posted_jobs,
    skills
FROM skills_to_jobs
INNER JOIN 
    job_postings_fact ON
    job_postings_fact.job_id = skills_to_jobs.job_id
INNER JOIN
    skills_dim ON
    skills_dim.skill_id = skills_to_jobs.skill_id
WHERE
    job_work_from_home = true AND
    job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY posted_jobs DESC
LIMIT 5;

