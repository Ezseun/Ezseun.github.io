HEALTHCARE PORTFOLIO PROJECT - Emergency Room Data Exploration.sql

SELECT *
FROM [Portfolio Data].dbo.['Emergency Room']

---Cleaning Data in SQL Queries
UPDATE [dbo].['Emergency Room']
SET [Patient Gender] = 'Female'
WHERE [Patient Gender] = 'F'

UPDATE [dbo].['Emergency Room']
SET [Patient Gender] = 'Male'
WHERE [Patient Gender] = 'M'

UPDATE [dbo].['Emergency Room']
SET [Patient Gender] = 'Non-Conforming'
WHERE [Patient Gender] = 'NC'

--Gender Distribution - COUNT of male vs. female patients

SELECT	[Patient Gender] AS Gender
		,COUNT([Patient Gender]) AS [Patient Count]
FROM [dbo].['Emergency Room']
GROUP BY [Patient Gender]
ORDER BY [Patient Count]

--Age Group Analysis: Distribution of patients across age ranges (0-18, 19-35, 36-60, 60+)

---USING CTE
WITH [Age Group] AS(
	SELECT 
		CASE
		WHEN [Patient Age] BETWEEN 0 AND 18 THEN '0-18'
		WHEN [Patient Age] BETWEEN 19 AND 25 THEN '19-25'
		WHEN [Patient Age] BETWEEN 26 AND 35 THEN '26-35'
		WHEN [Patient Age] BETWEEN 36 AND 45 THEN '36-45'
		WHEN [Patient Age] BETWEEN 46 AND 55 THEN '46-55'
		ELSE '56+'
		END AS Age_Group
FROM [dbo].['Emergency Room']
)
SELECT Age_Group
		,COUNT(*) AS Patient_Count
FROM [Age Group]
GROUP BY Age_Group
ORDER BY Age_Group

--Alternatively
SELECT 
		CASE
		WHEN [Patient Age] BETWEEN 0 AND 18 THEN '0-18'
		WHEN [Patient Age] BETWEEN 19 AND 25 THEN '19-25'
		WHEN [Patient Age] BETWEEN 26 AND 35 THEN '26-35'
		WHEN [Patient Age] BETWEEN 36 AND 45 THEN '36-45'
		WHEN [Patient Age] BETWEEN 46 AND 55 THEN '46-55'
		ELSE '56+'
		END AS Age_Group
		,COUNT(*) AS [Patient Count]
FROM [dbo].['Emergency Room']
GROUP BY 
		CASE
		WHEN [Patient Age] BETWEEN 0 AND 18 THEN '0-18'
		WHEN [Patient Age] BETWEEN 19 AND 25 THEN '19-25'
		WHEN [Patient Age] BETWEEN 26 AND 35 THEN '26-35'
		WHEN [Patient Age] BETWEEN 36 AND 45 THEN '36-45'
		WHEN [Patient Age] BETWEEN 46 AND 55 THEN '46-55'
		ELSE '56+'
		END
ORDER BY [Patient Count]

--Race Distribution: Count of patients by race
SELECT [Patient Race] AS RACE
		,COUNT(*) AS [Patient Count]
FROM [dbo].['Emergency Room']
GROUP BY [Patient Race]
ORDER BY [Patient Count]

--Gender and Age Group Distribution: Count of patients by gender within each age group

SELECT [Patient Gender],
		CASE
		WHEN [Patient Age] BETWEEN 0 AND 18 THEN '0-18'
		WHEN [Patient Age] BETWEEN 19 AND 25 THEN '19-25'
		WHEN [Patient Age] BETWEEN 26 AND 35 THEN '26-35'
		WHEN [Patient Age] BETWEEN 36 AND 45 THEN '36-45'
		WHEN [Patient Age] BETWEEN 46 AND 55 THEN '46-55'
		ELSE '56+'
		END AS Age_Group
		,COUNT(*) AS Patient_Count
FROM [dbo].['Emergency Room']
GROUP BY [Patient Gender],
		CASE
		WHEN [Patient Age] BETWEEN 0 AND 18 THEN '0-18'
		WHEN [Patient Age] BETWEEN 19 AND 25 THEN '19-25'
		WHEN [Patient Age] BETWEEN 26 AND 35 THEN '26-35'
		WHEN [Patient Age] BETWEEN 36 AND 45 THEN '36-45'
		WHEN [Patient Age] BETWEEN 46 AND 55 THEN '46-55'
		ELSE '56+'
		END
ORDER BY Age_Group, [Patient Gender]

---Race & Gender Distribution: This is a breakdown of count of patient by race and gender

SELECT [Patient Race] AS Race
	  ,[Patient Gender] AS Gender
	  ,COUNT(*) AS Patient_Count
FROM [dbo].['Emergency Room']
GROUP BY  [Patient Race]
		 ,[Patient Gender]
ORDER BY Race,
		,Gender

--Age and Race Distribution: Patient count across race within specific age groups

WITH [Patient Agegroup] AS(
	SELECT [Patient Race],
		CASE
		WHEN [Patient Age] BETWEEN 0 AND 18 THEN '0-18'
		WHEN [Patient Age] BETWEEN 19 AND 25 THEN '19-25'
		WHEN [Patient Age] BETWEEN 26 AND 35 THEN '26-35'
		WHEN [Patient Age] BETWEEN 36 AND 45 THEN '36-45'
		WHEN [Patient Age] BETWEEN 46 AND 55 THEN '46-55'
		ELSE '56+'
		END AS Age_Group
FROM [dbo].['Emergency Room']
)

SELECT Age_Group
		,[Patient Race]
		,COUNT(*)
FROM [Patient Agegroup]
GROUP BY Age_Group
		,[Patient Race]
ORDER BY Age_Group
		,[Patient Race]

--Age and Gender with Race: A detailed breakdown showing counts for gender and race within each age group.

WITH [Patient AgeGroup] AS(
	SELECT 
		CASE
		WHEN [Patient Age] BETWEEN 0 AND 18 THEN '0-18'
		WHEN [Patient Age] BETWEEN 19 AND 25 THEN '19-25'
		WHEN [Patient Age] BETWEEN 26 AND 35 THEN '26-35'
		WHEN [Patient Age] BETWEEN 36 AND 45 THEN '36-45'
		WHEN [Patient Age] BETWEEN 46 AND 55 THEN '46-55'
		ELSE '56+'
		END AS Age_Group
	   ,[Patient Gender]
FROM [dbo].['Emergency Room']
)

SELECT Age_Group
		,[Patient Gender]
		,COUNT(*) AS Patient_Count
FROM [Patient AgeGroup]
GROUP BY Age_Group
		,[Patient Gender]
ORDER BY Age_Group
		,[Patient Gender]

--PERFORMANCE METRICS
--1. Average Wait Time by Department: Identify which departments have the longest and shortest average wait times.

SELECT [Department Referral] AS Department
		,ROUND(AVG([Patient Waittime]),2) AS [Average Wait Time]
FROM [dbo].['Emergency Room']
GROUP BY [Department Referral]
ORDER BY [Average Wait Time] DESC

--2. Admission Rates by Department: Calculate the percentage of patients admitted within each department.

SELECT [Department Referral] AS Department
		,COUNT(*) AS [Total Patient]
		,SUM(CASE 
			WHEN [Patient Admission Flag] = 1 THEN 1
			ELSE 0
			END) AS [Admitted Patient]
		,ROUND((CAST(SUM(CASE 
			WHEN [Patient Admission Flag] = 1 THEN 1
			ELSE 0
			END) AS FLOAT)/COUNT(*))*100
			,2) AS [Admission Rate %]
FROM [dbo].['Emergency Room']
GROUP BY [Department Referral]
ORDER BY [Admission Rate %] DESC

--Correlation Between Wait Time and Satisfaction Scores: Analyze if longer wait times correspond to lower satisfaction scores.

SELECT [Patient Waittime] AS [Wait Time]
		,ROUND(AVG([Patient Satisfaction Score]),2) AS [Average Satisfaction Score]
FROM [dbo].['Emergency Room']
GROUP BY [Patient Waittime]
ORDER BY [Wait Time]

--Peak Admission Hours: Shows the busiest hours of the day for admissions.

SELECT DATEPART(HOUR,[Patient Admission Date]) AS [Hour of Admision]
		,COUNT(*) AS [Patient Count]
FROM [dbo].['Emergency Room']
GROUP BY DATEPART(HOUR,[Patient Admission Date])
ORDER BY [Patient Count]

--. Admission patterns: Monthly or seasonal trends in patient admissions.

SELECT	YEAR([Patient Admission Date]) AS Admission_Year
		,MONTH([Patient Admission Date]) AS Admission_Month
		,DATENAME(MONTH,[Patient Admission Date]) AS Month_Name
		,COUNT(*) AS Count_of_Admision
FROM [dbo].['Emergency Room']
GROUP BY YEAR([Patient Admission Date]) 
		,MONTH([Patient Admission Date])
		,DATENAME(MONTH,[Patient Admission Date]) 
ORDER BY Admission_Year
		,Admission_Month

--Correlation Between Wait Time and Satisfaction Scores: This query calculates the average satisfaction score for each unique wait time, allowing us to understand the relationship between the two variables.

SELECT [Patient Waittime] AS Wait_Time
		,ROUND(AVG([Patient Satisfaction Score]),2) AS Avg_Satisfaction_Score
FROM [dbo].['Emergency Room']
WHERE [Patient Satisfaction Score] IS NOT NULL
GROUP BY [Patient Waittime]
ORDER BY Wait_Time

-- DEPARTMENT TRENDS: Most commonly referred departments and their statistics.
/*This query provides insights into the most referred departments and their key performance metrics.
This query provides insights into the most referred departments and their key performance metrics.*/

SELECT [Department Referral] AS Department
		,COUNT(*) AS [Total Referrals]
		,ROUND(AVG([Patient Waittime]),2) AS Avg_Wait_Time
		,SUM(CASE 
			WHEN [Patient Admission Flag] = 1 THEN 1
			ELSE 0
			END) AS [Admitted Patients]
		,ROUND((CAST(SUM(CASE 
			WHEN [Patient Admission Flag] = 1 THEN 1
			ELSE 0
			END) AS FLOAT)/COUNT(*))*100,2) AS [Admission Rate %]
FROM [dbo].['Emergency Room']
GROUP BY [Department Referral]
ORDER BY [Total Referrals] DESC
