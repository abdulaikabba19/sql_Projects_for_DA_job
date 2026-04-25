/*QUESTION: What are the most in-demand skills for Data Scientist?
- Join job postings to inner join table as we did in Query_2
- Identify the top 5 in demand skills for a Data Scientist
-Focus on all job postings
-WHY? To retrieve the top five skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers
*/
-- METHOD 1 FROM ADVANCED PRACTICE PROBLEM 7:

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

--METHOD TWO:
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Scientist' AND 
    job_postings_fact.job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    demand_count DESC
LIMIT 5;