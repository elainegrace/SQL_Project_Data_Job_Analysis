-- What skills are skills are the most in-demand skills for data analysts?

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

