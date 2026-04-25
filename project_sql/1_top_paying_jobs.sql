/* QUESTION: What are the top-paying Data Scientist jobs?
-- Identify the top 10 highest-paying Data Scientist roles that are remotely available
-- Focuses on job postings with salaries that are not NULL
--WHY? I want to highlight the top-paying opportunities for Data Scientist, offering insights into employment opportunities.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
