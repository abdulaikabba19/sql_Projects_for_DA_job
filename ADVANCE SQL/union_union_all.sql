SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs
UNION
SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs
UNION
SELECT 
    job_title_short,
    company_id,
    job_location
FROM march_jobs;

--PRACTICE PROBLEM EIGHT UNION/UNION ALL:
/* Find job postings from the first quarter that have a salary greater than $70K
- Combine job postings table from the first quarter of 2023(Jan-Mar)
- Get job postings with an average salary > $70K */

SELECT 
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::date,
    quarter1_job_postings.salary_year_avg
FROM(
SELECT *
FROM
    january_jobs
UNION ALL
SELECT *
FROM
    february_jobs
UNION ALL
SELECT *
FROM
    march_jobs) AS quarter1_job_postings

WHERE 
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Scientist'
ORDER BY 
    quarter1_job_postings.salary_year_avg DESC


--PROBLEM ONE:
(SELECT 
    job_id,
    job_title,
    'With Salary Info' AS salary_info
FROM 
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL)
UNION ALL
(SELECT 
    job_id,
    job_title,
    'Without Salary Info' AS salary_info
FROM 
    job_postings_fact
WHERE
    salary_year_avg IS NULL OR salary_hour_avg IS NULL)
ORDER BY 
    salary_info,
    job_id;


--PROBLEM TWO
SELECT
    job_postings_Q1.job_id,
    job_postings_Q1.job_title_short,
    job_postings_Q1.job_location,
    job_postings_Q1.job_via,
    job_postings_Q1.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM
    (SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs) AS job_postings_Q1

LEFT JOIN skills_job_dim ON job_postings_Q1.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_Q1.salary_year_avg > 70000 AND 
    job_postings_Q1.job_title_short = 'Data Scientist'--This was added by me because it's my interest
ORDER BY 
    job_postings_Q1.job_id;

--PROBLEM THREE:
 
-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
    SELECT job_id, job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
    SELECT
        skills_dim.skills,  
        EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
        EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
        COUNT(combined_job_postings.job_id) AS postings_count 
    FROM
        combined_job_postings
    INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
    GROUP BY
        skills_dim.skills, 
        year, 
        month
)
-- Main query to display the demand for each skill during the first quarter
SELECT
    skills,  
    year,  
    month,  
    postings_count 
FROM
    monthly_skill_demand
ORDER BY
    skills, 
    year,
    month;