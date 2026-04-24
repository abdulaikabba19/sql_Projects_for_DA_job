-- THIS IS SUBQUERY
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;

--THIS IS CTE:
WITH february_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
    )
SELECT *
FROM february_jobs;

--MORE EXAMPLES ON SUBQUERY

SELECT
        company_id,
         name AS company_name
FROM
         company_dim
WHERE 
        company_id IN

(SELECT 
        company_id
        
FROM
        job_postings_fact
WHERE
        job_no_degree_mention = true
ORDER BY company_id);
--COMPLEX CTE EXAMPLE

/* FIND THE COMPANIES THAT HAVE THE MOST JOB OPENINGS
- GET THE TOTAL NUMBER OF JOB POSTINGS PER COMPANY ID(JOB_POSTINGS_FACT)
- RETURN THE TOTAL NUMBER OF JOBS WITH THE COMPANY NAME(COMPANY_DIM)*/

WITH company_job_count AS (

SELECT
        company_id,
        COUNT(*) AS total_jobs
FROM 
        job_postings_fact
GROUP BY
        company_id)

SELECT
     company_dim.name AS company_name,
     company_job_count.total_jobs

FROM company_dim
LEFT JOIN company_job_count ON company_dim.company_id = company_job_count.company_id
ORDER BY 
    total_jobs DESC;

--PRACTICE PROBLEM 7 CTE:
/* Find the count of the number of remote job postings per skill
- Display the top five skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill*/

WITH remote_job_skills AS (
    SELECT

        skill_id,
        COUNT(*) AS skill_count
    
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
    WHERE
        job_postings.job_work_from_home = true    AND 
        job_postings.job_title_short = 'Data Scientist'
    GROUP BY 
        skill_id)
    SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
    FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
    skill_count DESC
LIMIT 5;

--PROBLEM ONE(SUNQUERY)

SELECT 
    skills_dim.skills,
    top_skills.skill_count --I added this to see the counts
FROM skills_dim
INNER JOIN  (SELECT 
    skill_id,
    COUNT(job_id) AS skill_count
FROM
    skills_job_dim
GROUP BY
    skill_id
ORDER BY
    COUNT(job_id) DESC
LIMIT 5) AS top_skills ON skills_dim.skill_id = top_skills.skill_id

ORDER BY top_skills.skill_count

--SUBQUERY PROBLEM TWO:
SELECT
    company_id,
    name,
    company_job_count.job_counts,--I introduced this to see the counts on my results
CASE 
        WHEN job_counts < 10 THEN 'Small'
        WHEN job_counts BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
END AS company_size
FROM

(SELECT
    company_dim.company_id,
    company_dim.name,
    COUNT(job_postings_fact.job_id) AS job_counts
FROM
    company_dim
INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
GROUP BY 
    company_dim.company_id,
    company_dim.name) AS company_job_count;




