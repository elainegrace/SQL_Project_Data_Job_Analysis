SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

WITH january_jobs AS (
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 1  
    )
        
 SELECT *
 FROM january_jobs;


/*
Find companies that offer jobs that don't have requirements 
for degree. Return the company name
*/

SELECT name AS company_name
FROM company_dim
WHERE company_id IN
    (SELECT
        company_id,
        job_no_degree_mention
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
    )


;


SELECT name
FROM company_dim
WHERE company_id IN
    (
    SELECT
        company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
    ORDER BY company_id
    );


SELECT
    job_postings_fact.company_id,
    job_postings_fact.job_no_degree_mention,
    company_dim.name
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id

WHERE job_no_degree_mention = true;

/*
Find the companies that have the most job openings
- Get the total number of job postings per company id (job_postings_fact)
- Return the total number of jobs with the company name (company_dim)

*/

WITH company_job_count AS
    (SELECT 
        company_id,
        COUNT(*) AS total_jobs_posted
    FROM job_postings_fact
    GROUP BY company_id
    )


SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs_posted
FROM company_dim
LEFT JOIN company_job_count ON
    company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs_posted DESC;

WITH company_job_count AS
    (SELECT 
        company_id,
        COUNT(*) AS total_jobs_posted
    FROM job_postings_fact
    GROUP BY company_id
    )


SELECT 
    name AS company_name,
    total_jobs_posted
FROM company_dim
LEFT JOIN company_job_count ON
    company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs_posted DESC;


/* identify top 5 skills most frequently mentioned in job postings.
find the skill IDs with the highest counts in the skills_job_dim and then
join this results with the skills_dim to get skill names

*/

SELECT 
    skills
FROM skills_dim
WHERE skill_id IN
    (
    SELECT
        COUNT(job_id)
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY count DESC
    )


SELECT
    COUNT(job_id),
    skills_dim.skills
FROM skills_job_dim
RIGHT JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY count DESC

/*

determine size category (small, medium, large) for each company by identifying
number of job postings they have. 

use subquery to calculate total job postings per company.

company small = less than job postings
medium = between 10 & 50
large = more than 50

implement subquery to aggregate job counts per company before classifying them based on size

*/


WITH company_jobs AS
    ( 
        SELECT
            COUNT(job_id) AS total_job_post,
            company_id
        FROM job_postings_fact
        GROUP BY company_id
    )

SELECT
    CASE
        WHEN total_job_post > 50 THEN 'Large'
        WHEN total_job_post BETWEEN 40 AND 50 THEN 'Medium'
        ELSE 'Small'
    END AS company_size
FROM company_jobs;


/*
Find the count of the number of remote job postings per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill
*/


WITH remote_job_skills AS
    (
        SELECT
            COUNT(skills_to_jobs.job_id) AS total_jobs,
            skill_id
        FROM skills_job_dim AS skills_to_jobs
        INNER JOIN job_postings_fact ON
            job_postings_fact.job_id = skills_to_jobs.job_id
        WHERE job_work_from_home = true
        GROUP BY skill_id
)

SELECT
    skills_dim.skill_id,
    skills,
    total_jobs
FROM remote_job_skills
INNER JOIN skills_dim ON
    skills_dim.skill_id = remote_job_skills.skill_id;

SELECT
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM march_jobs;



SELECT
    job_title_short,
    job_via,
    job_posted_date::DATE,
    salary_year_avg

FROM
    (
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
    ) AS quarter1_job_postings

WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'

ORDER BY salary_year_avg DESC