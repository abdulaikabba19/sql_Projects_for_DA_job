#  Introduction
📊 Dived into the data job market!Focusing on data scientist roles. This project explores 💰top-paying jobs, 🔥in-demand skills, and📈 where high demand meets high salary in data science

🔍SQL queries? Check them out here:[project_sql folder](/project_sql/) 
# Background
Driven by the quest of wanting to become a Data Scientist, and also wanting to navigate the data science job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining other works to find optimal jobs. 

Data hails from [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations and essential skills.

### The questions I wanted to answer through my SQL queries were: 
1. What are the top-paying Data Scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Scientists?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I used
For my deep dive into the Data Science job market, I harnessed the power of several key tools:
- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Code Studio:** My go to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking. 
# The Analysis
Each query for this project is aimed at investigating specific aspects of Data Science job market. Here is how I approached each question: 

### 1.Top Paying Data Scientist Jobs
To identify the highest paying data science roles, I filtered Data Scientist positions by average yearly salary and lcoation, focusing on remote jobs. This query highlights the high paying opportunities in the field. 

```sql
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
```
Here's the breakdown of the top data science jobs in 2023

- **Wide Salary Range**
The salaries span from $300K to $550K which shows a significant salary potential in the Data Science field.


- **Diverse Employers**
My dataset shows employers from multiple industries, showing that high‑end data science is not limited to tech but also include:

Quant & finance recruiters (Selby Jennings, Algo Capital Group)

Tech & social platforms (Reddit)

Enterprise & retail (Walmart)

Specialized sectors (Battery science, cybersecurity, product analytics)

This diversity signals that data science leadership roles are now embedded across nearly every sector, not just Silicon Valley.

- **Strong Job Title Variety**
There is high diversity in job titles ranging from Data Scientist to Directors & Heads of Data Science, indicating that there are different specialties within the Data Science field.

![top_paying_data_scientist_jobs](assets\top_paying_data_scientist_jobs.png)
*Bar Graph visualising the salary for the top 10 salaries for data scientists; COPILOT generated this graph from my SQL query results*

### 2. Skills for Top Paying Jobs
To clearly understand what skills are required to be get a high-paying job, I joined the job postings with the skill set data, which then provided insights into what employers are looking for to get these roles.
```sql
WITH top_paying_jobs AS(


    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
    LIMIT 10)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for the top 10 highest paying Data Science jobs in 2023:
- **PYTHON AND SQL** are leading with each having 4 counts
- **JAVA AND AWS** also appeared 3 times which indicates that they are top-tier skills. 
- **Spark**, **Cassandra**, and **Hadoop** appeared consistently. 
![top_10_skills_chart](assets\top_10_skills_chart.png)
*Bar chart visualising the count of skills for the top 10 paying jobs for Data Scientists; COPILOT generated this graph from my SQL query results*

### 3. In-Demand Skills for Data Scientists
This query helped identify the skills most frequently requested in job postings, directing focus on areas with high demands. 
```sql
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
```

Here's a breakdown of the most demanded skills for Data Scientists in 2023:
- **PYTHON, R, AND SQL** remain to be the backbone of modern data science as they can be used for programming and data cleaning. 
- **TABLEAU** highlight the importance of communication it is used for data storytelling and dashboarding. 
![demand_counts](assets\demand_counts.png)


*Table of the demand for the top 5 skills in Data Science job postings; chart powered by COPILOT from my SQL query results*

### 4. Skills Based on Salary
By performing this query, it gives an insight about average salaries associated with different skills, revealing which skills pay the highest. 

```sql
SELECT 
    skills,
   ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Scientist' AND 
    job_postings_fact.salary_year_avg IS NOT NULL
    --job_postings_fact.job_work_from_home = TRUE NOT considering a particular location for this
GROUP BY 
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top-paying skills for Data Scientists:
- **Salary Range and Market Signal**
The salaries span from $148K to $215K, showing that niche and enterprise‑grade technical skills command premium pay.
These are not mainstream data science tools — they’re specialized technologies used in enterprise, infrastructure, and emerging tech roles.

- **Top‑Paying Skills**
**Asana ($215K)** and **Airtable ($201K)** lead the list — both are workflow and collaboration platforms, signaling that data‑driven product management and technical program leadership are highly valued.

- **Emerging and Specialized Technologies**
Skills like **Solidity**, **Hugging Face**, and **Neo4j** (all above $160K) show that Web3, AI/ML frameworks, and graph databases are lucrative niches.
These roles often exist in startups, fintech, and advanced research labs.

- **Non‑Obvious Insight**
The highest salaries are not tied to traditional data science tools **(Python, SQL, R)** but to rare, cross‑disciplinary expertise — combining engineering, AI, and product systems.
Scarcity drives compensation


![salary_based_skills](assets\top_paying_skills_table.png)
*Table of the average salary for the top 10 paying skills for Data Scientists*

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are in high demand and have high salaries, which offers focus for skills development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
   
LIMIT 25;
```
Here's a breakdown of the most optimal skills for Data Scientists in 2023:


- **High‑paying skills** are deeply technical and infrastructure‑heavy
The highest salaries **(≈ $155K–$165K)** are tied to skills like **C, Go, Qlik, Looker, Airflow, and BigQuery**.
These are not beginner‑friendly tools and it signals that data science + systems programming skills command premium pay.

- **Demand does NOT always correlate with salary** 

   For example:

    **C** → low demand (48) but highest salary, 
    **Go** → moderate demand (57) but very high salary, 
    **Qlik** → very low demand (15) but top‑tier salary

    This shows that scarcity (few people know these tools) drives compensation more than popularity.

- **Cloud + ML frameworks** dominate the mid‑high salary band
Skills like: **GCP, 
Snowflake, PyTorch, TensorFlow, Spark, AWS**

    These appear frequently and sit in the $148K–$155K range.
    They represent the modern data stack — cloud, distributed compute, and ML frameworks.

- **Python** is the most demanded skill but not the highest paid
Demand: 763 (highest by far)  
Salary: $143,827 (lower than niche skills)
This reinforces a key market truth:
**Python** is essential, but not rare — and rarity drives salary.

- **BI tools still matter**
Tools like **Tableau, Looker, Qlik, and PowerPoint** appear with strong salaries.
This shows that communication + visualization remains valuable even in high‑paying roles.
![optimal_skills](assets\optimal_skills.png)
*Table of the most optimal skills for Data scientist sorted by salary; table generated by COPILOT using my query result*

# What I Learned
During this course, I have cofidently increased by knowledge about the use and application of SQL tools. The following are the key important things I have learnt:
- 🌟**COMPLEX QUERY**: During this course, I have mastered the art of using complex queries like CTEs and SUBQUERY making query a bit easier for me. 
- 📊**DATA AGGREGATION**: I have been able to have a firm grip on aggregate functions like AVG(),COUNT(), and GROUP BY
- 📑**COMPLEX ANALYSIS**: working with this real-world data and questions, have broaden my horizon into being able to turn questions into insightful solutions. 
# Conclusions

**Insights**
Based on the analysis made, the following has been concluded:
1. **TOP PAYING DATA SCIENTIST JOBS**: the jobs that pay the highest in data science roles that allows remote work ranges between $300K to $550K with the latter being the highest.
2. **SKILLS FOR TOP-PAYING JOBS**: To get a high-paying job in data science, a proficiency in **PYTHON and SQL** is critical, as they serve as a key point of earning top salary.
3. **MOST IN-DEMAND SKILLS**: PYTHON is the most demanded skill required in the data science market, thus making it essential for job seekers. 
4. **SKILLS WITH HIGHER SALARIES**: specialised skills like **Asana** and **Airtable** are directly associated with the highest salaries, indicating a premium on niche expertise. 
5. **OPTIMAL SKILLS FOR JOB MARKET VALUE**: Highest salaries for data science jobs are tied to tools like **C**, **Go**, **Qlik** positioning themselves as one of the optimal skills a data scientist could learn to increase their market value. 

**Closing Thoughts**

This project enhanced my SQL skills and valuable insights into the data science job market. The findings from the analysis serve as guide towards career development and job haunting. 
