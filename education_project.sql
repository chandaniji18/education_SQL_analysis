
create database education_project;
use education_project;

show tables;
-- Q1. Find total number of records in the dataset.

select count(*) as total_students
from clean_education_dataset;

-- *Answer - This datadet contains 16 reocords.
-- *obsevation - The datadet consists of 16 district-level records, indicating that the analysis is conducted on aggregated regional education data rather than individual student-level data.alter

-- Q2. What are the distinct categories/classes available?

select count(distinct district)
from clean_education_dataset;

-- *ANS- There are 16 distinct districts in the dataset.
-- *obsevation - All 16 records correspond to unique districts. This indicate that the dataset contains one record per district, with no duplicate district entries.alter


-- Q3. What is the overall average score/metric?

select AVG(x_pass_percent_before_2023_2024) as avg_pass_percent_x
from clean_education_dataset;

-- *ANS- Average pass percentage for class x is 94.91937499999999.

-- *OBSEVATION- The average class x pass percentage indicates the overall academic performance across districts. This helps in understanding the general success rate of students at the secondary level.alter


-- Q4 What are the maximum and minimum values recorded?

select
MAX(NO_of_students_Total) as max_students,
MIN(No_of_students_Total) as min_students
from clean_education_dataset;

-- ANS- The maximum number of students recorded in a district is 189406. While the minimum number of student recorded is 1295.alter

-- *OBSEVATION- The variation between maximum and minimum student counts highlights the difference in educational scale across districts. This indicates that some districts have significantly higher student enrollment compared to others, reflecting differences in population size or educational infrastructure.alter


-- Q5 How many records contain NULL or missing values?

select count(*) as null_records
from clean_education_dataset
where
No_of_Schools_otal is null
or No_of_Students_Total is null
or No_of_Students_Boys is null
or No_of_Students_Girls is null;

-- *ANS- The dataset contains 0 records with null.

-- *OBSERVATION- The presence of null values indicates the overall data quality. A dataset with minimal missing values ensures more reliable and accurate analysis.alter


-- #Q6 What is the average score grouped by gender/category?


SELECT
avg(No_of_Students_Boys) as avg_boys,
avg(No_of_Students_Girls) as avg_girls
from clean_education_dataset;

-- *ANS- The average number of boys per district is 49989.7500. While the average number of girls per district is 54192.7500.alter

-- *OBSERVATION- The comparison of average student counts by gender helps in understanding gender distribution across districts. A significant difference may indicate enrollment imbalance,while similar values suggest relatively balanced participation.alter



-- #Q7 . What is the average score per class/department?

select
avg(No_of_Students_primary) as avg_primary,
avg(No_of_Students_Middle) as avg_middle,
avg(No_of_Students_Secondary) as avg_secondary,
avg(No_of_Students_Sr_Secondary) as avg_sr_secondary
from clean_education_dataset;

-- *ANS- The average number of students in primary level is 8508.9375, middle is 43059.8750, secondary is 28237.3750 and senior secondary level is 22407.9375.

-- *OBSEVATION- The distribution of average students across educational levels helps identify enrollment trends. A higher concentration at a specific level may indicates stronger retention or higher dropout patterns at other stages. 


-- #Q8 Which class/segment has the highest average student enrollment?

SELECT 
'Primary' AS Level, AVG(No_of_Students_Primary) AS avg_students
FROM clean_education_dataset
UNION
SELECT 
'Middle', AVG(No_of_Students_Middle)
FROM clean_education_dataset
UNION
SELECT 
'Secondary', AVG(No_of_Students_Secondary)
FROM clean_education_dataset
UNION
SELECT 
'Senior Secondary', AVG(No_of_Students_Sr_Secondary)
FROM clean_education_dataset
ORDER BY avg_students DESC;

-- *ANS- The segment with the highest average student enrollment is 43059.8750. 

-- *Observation- The segment with the highest average enrollment represents the most concentrated educational level across districts. This may indicate stronger retention or higher student intake at that stage. 

-- #Q9 What percentage of records are above a defined benchmark (e.g., 75) ?

SELECT 
    (COUNT(CASE WHEN No_of_Students_primary > 75 THEN 1 END) * 100.0 / COUNT(*)) 
    AS Percentage_Above_75
FROM clean_education_dataset;

-- *ANS- The percentage of students scoring above 75 is 100.

-- *OBSERVATION- A significant proportion of students have scored above the benchmark of 75, indicating strong academic performance within the dataset. A higher percentage suggests overall good achievement levels, while a lower percentage would highlight the need for academic improvement strategies.


-- #Q10 . How many records fall into performance categories (Distinction, Pass, Fail) using CASE when?

SELECT 
    CASE 
        WHEN (No_of_Students_Primary +
              No_of_Students_Middle +
              No_of_Students_Secondary +
              No_of_Students_Sr_Secondary) >= 4000
        THEN 'High'
        ELSE 'Low'
    END AS Enrollment_Category,
    
    COUNT(*) AS Total_Count

FROM clean_education_dataset
GROUP BY 
    CASE 
        WHEN (No_of_Students_Primary +
              No_of_Students_Middle +
              No_of_Students_Secondary +
              No_of_Students_Sr_Secondary) >= 4000
        THEN 'High'
        ELSE 'Low'
    END;
    
    -- *ANS- There are 15 High enrollment districts and 1 Low enrollment districts in the dataset.

-- *OBSERVATION- The dataset indicates that the majority of districts fall under the HIGH category. This reflects the overall distribution of student enrollment and highlights regional differences in educational participation.


-- #Q11 Identify top 5 highest performers overall.

select
    district,
    (No_of_Students_primary+
    No_of_Students_Middle+
    No_of_Students_Secondary+
    No_of_Students_Sr_Secondary) as total_students
from clean_education_dataset
order by total_students desc
limit 5;

-- *ANS- The top 5 highest performing districts based on total student enrollment are:
-- 1. East - 185692
-- 2. North West A - 177835
-- 3. South East - 174354
-- 4. West B - 172354
-- 5. North East-II - 140432

-- *OBSERVATION- The above districts have the highest total student enrollment in the dataset. This indicates a strong educational presence and possinly higher population density in these regions. These districts contribute significantly to the overall educational statistics.

-- #Q12 Identify bottom 5 lowest performers overall.

select
    district,
    (No_of_Students_primary+
    No_of_Students_Middle+
    No_of_Students_Secondary+
    No_of_Students_Sr_Secondary) as total_students
from clean_education_dataset
order by total_students asc
limit 5;

-- *ANS- The bottom 5 lowest performing districts based on total student enrollment are:
-- 1. New Delhi - 1225
-- 2. Central - 26403
-- 3. South West B-II - 38399
-- 4. South West A - 45590
-- 5. North West B-II - 66097

-- *OBSERVATION- The above districts have the lowest total student enrollment in the dataset. This may indicate lower population density, limited educational infrastructure, or regional demographic differences. These districts contribute comparatively less to the overall student count.

-- #Q13 Identify top performer in each class using window functions.

SELECT District, No_of_Students_primary
FROM (SELECT District, No_of_Students_primary,
RANK() OVER (ORDER BY No_of_Students_primary DESC) AS rnk
FROM clean_education_dataset) AS ranked_data
WHERE rnk = 1;

SELECT District, No_of_Students_middle
FROM (SELECT District, No_of_Students_middle,
RANK() OVER (ORDER BY No_of_Students_middle DESC) AS rnk
FROM clean_education_dataset) AS ranked_data
WHERE rnk = 1;

SELECT District, No_of_Students_secondary
FROM (SELECT District, No_of_Students_secondary,
RANK() OVER (ORDER BY No_of_Students_secondary DESC) AS rnk
FROM clean_education_dataset) AS ranked_data
WHERE rnk = 1;

-- *ANS- PRIMARY level - 18017
       --   middle level - 82575
--          secondary level - 52855
-- *OBSERVATION- The districts ranked 1 in each level have the highest student enrollment.This indicates stronger student participation and better retention at that education level.

-- #Q14 Calculate performance gap between highest and lowest per group.

SELECT 
    MAX(Total_Students) - MIN(Total_Students) AS Performance_Gap
FROM (SELECT 
        (No_of_Students_primary +
         No_of_Students_middle +
         No_of_Students_secondary) AS Total_Students
    FROM clean_education_dataset) AS totals;

-- *ANS- Performance gap is 142518.
-- *OBSEVATION - A large gap indicates significant variation in student enrollment acreoss district.

-- #Q15 Create a summary table showing class-wise KPIs (count, avg, max, min).

SELECT 
    COUNT(*) AS Total_Districts,
    AVG(No_of_Students_primary +
        No_of_Students_middle +
        No_of_Students_secondary) AS Avg_Enrollment,
    MAX(No_of_Students_primary +
        No_of_Students_middle +
        No_of_Students_secondary) AS Max_Enrollment,
    MIN(No_of_Students_primary +
        No_of_Students_middle +
        No_of_Students_secondary) AS Min_Enrollment
FROM clean_education_dataset;

-- *ANS- This query generates overall KPIs including total count - 16, average - 79806.1875, maximum - 143471, and minimum - 953. enrollment.
-- *OBSERVATION- The KPI summary highlights variation in enrollment across district and helps identify performance differences.


-- #Q16 Find District with Highest Primary to Secondary Growth Ratio

SELECT District,
       (No_of_Students_secondary / No_of_Students_primary) AS Growth_Ratio
FROM clean_education_dataset
ORDER BY Growth_Ratio DESC
LIMIT 1;
-- *Answer -This query finds the district where the proportion of secondary students compared to primary students is highest.

-- *Observation- A higher ratio indicates better student retention from primary to secondary level.

-- #Q17. Rank Districts Based on Total Enrollment

SELECT District,
       (No_of_Students_primary +
        No_of_Students_middle +
        No_of_Students_secondary) AS Total_Enrollment,
       RANK() OVER (ORDER BY 
           (No_of_Students_primary +
            No_of_Students_middle +
            No_of_Students_secondary) DESC
       ) AS District_Rank
FROM clean_education_dataset;
-- *Answer- This query ranks all districts based on total student enrollment.

-- *Observation- Ranking helps identify top and low performing districts clearly.

-- #Q18. Calculate Enrollment Contribution Percentage per District

SELECT District,
       (No_of_Students_primary +
        No_of_Students_middle +
        No_of_Students_secondary) * 100.0 /
       SUM(No_of_Students_primary +
           No_of_Students_middle +
           No_of_Students_secondary) OVER () AS Contribution_Percentage
FROM clean_education_dataset;

-- *Answer- This query calculates the percentage contribution of each district to total enrollment.

-- *Observation- It shows how much each district contributes to the overall education system.

-- #Q19. Identify Districts Where Secondary Enrollment is Above Average

SELECT District, No_of_Students_secondary
FROM clean_education_dataset
WHERE No_of_Students_secondary >
      (SELECT AVG(No_of_Students_secondary)
       FROM clean_education_dataset);
       
-- *Answer-This query identifies districts where secondary enrollment is above the average.

-- *Observation- These districts show stronger student continuation at higher education levels.

-- #20 Provide final business insights summarizing key findings from analysis.
-- The analysis shows variation in student enrollment districts. Some districts have consistently high enrollment, indicating stronger educational participation and infrastructure. However, a few districts fall below the average, highlighting possible gaps in resources or access to education. Addressing these differences can help improve overall educational performance.



