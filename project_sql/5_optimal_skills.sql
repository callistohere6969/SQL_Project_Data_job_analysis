WITH skills_demand AS(
    SELECT skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS skill_demand
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
    WHERE job_title_short='Data Analyst' AND job_work_from_home=TRUE AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
    
), salary_avg AS(
SELECT skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL AND job_work_from_home=TRUE
GROUP BY skills_job_dim.skill_id

)

SELECT
skills_demand.skill_id,
skills_demand.skills,
skill_demand,
avg_salary
FROM skills_demand
INNER JOIN salary_avg ON skills_demand.skill_id=salary_avg.skill_id
WHERE skill_demand >10
ORDER BY 
        avg_salary DESC,skill_demand DESC
LIMIT 25;
--another variation
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id)AS demand_count,
    ROUND(AVG(salary_year_avg)) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
WHERE job_title_short='Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location='Anywhere'
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim) > 10
ORDER BY avg_salary DESC,
demand_count DESC
LIMIT 25;
    
