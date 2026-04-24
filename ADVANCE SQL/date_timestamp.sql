SELECT 
    job_postings_fact.job_title_short AS title,
    job_postings_fact.job_location AS location,
    job_postings_fact.job_posted_date::DATE AS date  
FROM 
    job_postings_fact;

SELECT 
    job_postings_fact.job_title_short AS title,
    job_postings_fact.job_location AS location,
    job_postings_fact.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time  
FROM 
    job_postings_fact
LIMIT 5;

SELECT 
    job_postings_fact.job_title_short AS title,
    job_postings_fact.job_location AS location,
    job_postings_fact.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS date_month,
     EXTRACT(YEAR FROM job_postings_fact.job_posted_date) AS date_year
FROM 
    job_postings_fact
LIMIT 5;

SELECT 
    COUNT(job_postings_fact.job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS month 
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
month
ORDER BY 
job_posted_count DESC;

-- EXERCISES OR PRACTICE PROBLEMS ON DATE/TIME
--EXERCISE 1 SOLUTION:
SELECT
    job_postings_fact.job_schedule_type,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2),
    ROUND(AVG(job_postings_fact.salary_hour_avg), 2)
FROM 
    job_postings_fact
WHERE
    job_postings_fact.job_posted_date > '2023-06-01'
GROUP BY 
    job_schedule_type
ORDER BY 
job_schedule_type;

-- EXERCISE 2 SOLUTION 
SELECT 
   
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
     
    COUNT(*) AS postings_count
FROM 
    job_postings_fact
GROUP BY 
    month
ORDER BY 
    month DESC;
    
-- EXERCISE 3 SOLUTION 
SELECT 
    COUNT(job_postings_fact.job_id) AS job_postings_count,  
    company_dim.name 
FROM job_postings_fact
LEFT JOIN company_dim ON  job_postings_fact.company_id = company_dim.company_id
WHERE job_postings_fact.job_health_insurance = TRUE AND
EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 2
GROUP BY company_dim.name 
HAVING  COUNT(job_postings_fact.job_id) > 0
ORDER BY job_postings_count DESC;

