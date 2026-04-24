-- ADVANCE PRACTICE PROBLEM 6 timestamp:
CREATE TABLE january_jobs AS
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
;

SELECT * 
FROM january_jobs;

CREATE TABLE february_jobs AS
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT 
job_posted_date 
FROM 
march_jobs;

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












