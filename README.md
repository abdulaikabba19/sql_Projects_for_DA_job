## 🌟 Introduction
This project is a deep exploration of the Data Science job landscape, with a focus on Data Scientist roles. Using SQL, I analyzed salary trends, in‑demand skills, and the intersection between high compensation and high demand. The goal was to uncover which roles pay the most, what skills employers prioritize, and which technical capabilities offer the strongest career advantage.

SQL queries? Check them out here:[project_sql folder](/project_sql/) 

## 🔎 Background
Motivated by my ambition to become a Data Scientist in the nearest future, and to better understand the job market, I created this project to identify the most valuable and best‑paid skills in the field.
The dataset—sourced from an SQL course, and it includes job titles, salaries, locations, and required skills. 

The link to the course can be found here: [SQL Course](https://lukebarousse.com/sql)

### ⁉️ The questions I wanted to answer through my SQL queries were: 
The key questions guiding my analysis were:

1. Which Data Scientist roles offer the highest salaries?

2. What skills do these top‑paying roles require?

3. Which skills are most frequently requested overall?

4. Which skills correlate with higher salaries?

5. What skills provide the strongest balance of demand and earning potential??

   
## ⚒️ Tools I used
For my deep dive into the Data Science job market, I harnessed the power of several key tools:
- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Code Studio:** My go to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
- 
## 📊 Project Analysis
Each query for this project is aimed at investigating specific aspects of Data Science job market. Here is how I approached each question: 

### 1. Highest‑Paying Data Scientist Roles

I filtered Data Scientist positions by average yearly salary and remote availability.
The results revealed:

- **Salary range: ~$300K to $550K**

- **Employer diversity**: Finance, tech, retail, cybersecurity, analytics, and more.

- **Role variety**:job roles vary from Data Scientist to Director‑level positions

This shows that high‑level data science roles exist across many industries—not just tech.

The query used to produce this result is shown below:

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

![top_paying_data_scientist_jobs](https://github.com/abdulaikabba19/sql_Projects_for_DA_job/blob/main/assets/top_paying_data_scientist_jobs.png?raw=true)
*Bar Graph visualising the salary for the top 10 salaries for data scientists; COPILOT generated this graph from my SQL query results*

### 2. Skills Required for Top‑Paying Roles

By joining job postings with skill data, I identified the skills most common among the top 10 highest‑paying roles.

**Key findings**:

- **Python and SQL** appeared most frequently

- **Java and AWS** also ranked highly

- Big‑data tools like **Spark, Cassandra, and Hadoop** were consistently present

These skills form the technical backbone of high‑earning Data Scientist positions.

The query used to produce this result is shown below:

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

![top_10_skills_chart](https://github.com/abdulaikabba19/sql_Projects_for_DA_job/blob/main/assets/top_10_skills_chart.png?raw=true)
*Bar chart visualising the count of skills for the top 10 paying jobs for Data Scientists; COPILOT generated this graph from my SQL query results*

### 3. Most In‑Demand Skills for Data Scientists

To understand employer demand, I counted how often each skill appeared in remote Data Scientist job postings.

Top skills:

- **Python, R, SQL** are the core programming and data manipulation tools that are needed

- **Tableau**  is essential for visualization and communication

These results highlight the importance of both technical and storytelling skills.

The query used to produce this result is shown below:

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
 
![demand_counts](https://github.com/abdulaikabba19/sql_Projects_for_DA_job/blob/main/assets/demand_counts.png?raw=true)


*Table of the demand for the top 5 skills in Data Science job postings; chart powered by COPILOT from my SQL query results*

### 4. Skills Associated With Higher Salaries

I calculated the average salary associated with each skill to identify which ones command premium pay.

Insights:

- Salary range: **$148K–$215K**

- Highest‑paying skills included **Asana, Airtable, Solidity, Hugging Face, Neo4j**

- These tools are specialized and less common, which increases their market value

- Traditional tools **(Python, SQL, R)** are essential but not the highest‑paid due to their widespread adoption

The query used to produce this result is shown below:


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



![salary_based_skills](https://github.com/abdulaikabba19/sql_Projects_for_DA_job/blob/main/assets/top_paying_skills_table.png?raw=true)
*Table of the average salary for the top 10 paying skills for Data Scientists*

### 5. Most Optimal Skills to Learn
By combining demand and salary data, I identified skills that offer the best balance of high pay and strong demand.

Key takeaways:

- **C, Go, Qlik, Looker, Airflow, BigQuery** ranked among the highest‑paying

- Demand does not always equal salary — scarcity drives compensation

- **Cloud and ML frameworks (GCP, Snowflake, PyTorch, TensorFlow, Spark, AWS)** dominate the mid‑high salary range

- **Python** remains the most demanded skill overall, though not the highest‑paid.

The query used to produce this result is shown below:

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

![optimal_skills](https://github.com/abdulaikabba19/sql_Projects_for_DA_job/blob/main/assets/optimal_skills.png?raw=true)
*Table of the most optimal skills for Data scientist sorted by salary; table generated by COPILOT using my query result*

# What I Learned
During this course, I have cofidently increased by knowledge about the use and application of SQL tools. The following are the key important things I have learnt:
- 🌟**COMPLEX SQL QUERIES**: During this course, I have mastered the art of using complex queries like CTEs and SUBQUERY making query a bit easier for me.
- 
- 📊**DATA AGGREGATION**: I have been able to have a firm grip on aggregate functions like AVG(),COUNT(), and GROUP BY
- 
- 📑**COMPLEX ANALYSIS**: working with this real-world data and questions, have broaden my horizon into being able to turn questions into insightful solutions.
- 
## 🔄️ Conclusions

**🎯Insights**
Based on the analysis made, the following has been concluded:
1. **TOP PAYING DATA SCIENTIST JOBS**: the jobs that pay the highest in data science roles that allows remote work ranges between $300K to $550K with the latter being the highest.
2. **SKILLS FOR TOP-PAYING JOBS**: To get a high-paying job in data science, a proficiency in **PYTHON and SQL** is critical, as they serve as a key point of earning top salary.
3. **MOST IN-DEMAND SKILLS**: PYTHON is the most demanded skill required in the data science market, thus making it essential for job seekers. 
4. **SKILLS WITH HIGHER SALARIES**: specialised skills like **Asana** and **Airtable** are directly associated with the highest salaries, indicating a premium on niche expertise. 
5. **OPTIMAL SKILLS FOR JOB MARKET VALUE**: Highest salaries for data science jobs are tied to tools like **C**, **Go**, **Qlik** positioning themselves as one of the optimal skills a data scientist could learn to increase their market value. 

**💭 Closing Thoughts**

This project significantly improved my SQL proficiency and deepened my understanding of the Data Science job market. The insights gained here serve as a roadmap for career planning and skill development. 
