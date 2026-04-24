SELECT 
    COUNT(job_postings_fact.job_title_short),
  
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM   
    job_postings_fact
WHERE 
    job_title_short = 'Data Scientist'
GROUP BY 
    location_category
;
-- EXERCISES FROM CASE STATEMENT
-- SOLUTION ONE:
SELECT 
    job_postings_fact.job_title_short,
    job_postings_fact.job_id,
    job_postings_fact.salary_year_avg,
    CASE 
        WHEN salary_year_avg >= 100000 THEN 'High Salary'
        WHEN salary_year_avg >= 60000 THEN 'Standard Salary'
        WHEN salary_year_avg < 60000 THEN 'Low Salary'
    END AS salary_category
FROM job_postings_fact
WHERE
    salary_year_avg IS NOT NULL AND 
    job_title_short = 'Data Scientist'
ORDER BY 
    salary_year_avg DESC;

--PROBLEM TWO SOLUTION 
SELECT 


     COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
     COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM 
    job_postings_fact;

-- PROBLEM SOLUTION THREE

SELECT
    job_id, 
    salary_year_avg,
    CASE
        WHEN job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN job_title ILIKE '%Manager%' OR ILIKE '%Lead%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR ILIKE '%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home THEN 'Yes'
        ELSE 'No'
    END AS remote_option
FROM 
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY
    job_id;











