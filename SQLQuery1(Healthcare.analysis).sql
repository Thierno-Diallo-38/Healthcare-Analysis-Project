CREATE DATABASE HealthcareAnalysis;
GO
USE HealthcareAnalysis;

CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Age INT,
    Gender NVARCHAR(10),
    Region NVARCHAR(50),
    Join_Date DATE
);


CREATE TABLE Visits (
    Visit_ID NVARCHAR(50) PRIMARY KEY,
    Patient_ID INT,
    Visit_Date DATE,
    Diagnosis NVARCHAR(50),
    Duration_Days INT,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);


CREATE TABLE HealthMetrics (
    Patient_ID INT PRIMARY KEY,
    BMI DECIMAL(4, 1),
    Blood_Pressure NVARCHAR(10),
    Last_Checkup DATE,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);


SELECT TOP 10 * 
FROM Patients_Info;

SELECT TOP 10 * 
FROM Visits_Info;

SELECT TOP 10 * 
FROM Health_metrics_info;

SELECT COUNT(*) AS Total_Patients FROM Patients_Info;

SELECT COUNT(*) AS Total_Visits FROM Visits_Info;

SELECT COUNT(*) AS Total_HealthMetrics FROM Health_metrics_info;


ALTER TABLE Visits_Info
ADD CONSTRAINT FK_Visits_Patients
FOREIGN KEY (Patient_ID) REFERENCES Patients_Info(Patient_ID);

ALTER TABLE Health_metrics_info
ADD CONSTRAINT FK_HealthMetrics_Patients
FOREIGN KEY (Patient_ID) REFERENCES Patients_Info(Patient_ID);


SELECT p.Patient_ID, p.Name, p.Age, v.Visit_Date, v.Diagnosis, v.Duration_Days
FROM Patients_Info p
JOIN Visits_Info v ON p.Patient_ID = v.Patient_ID
ORDER BY p.Patient_ID;


SELECT p.Patient_ID, p.Name, p.Age, h.BMI, h.Blood_Pressure, h.Last_Checkup
FROM Patients_Info p
JOIN Health_metrics_info h ON p.Patient_ID = h.Patient_ID;


SELECT p.Patient_ID, p.Name, COUNT(v.Visit_ID) AS Total_Visits,
       RANK() OVER (ORDER BY COUNT(v.Visit_ID) DESC) AS Visit_Rank
FROM Patients_Info p
JOIN Visits_Info v ON p.Patient_ID = v.Patient_ID
GROUP BY p.Patient_ID, p.Name;


SELECT Patient_ID, BMI, 
       AVG(BMI) OVER (ORDER BY Last_Checkup) AS Running_Avg_BMI
FROM Health_metrics_info;


WITH Visit_Count AS (
    SELECT Patient_ID, COUNT(*) AS Total_Visits
    FROM Visits_Info
    GROUP BY Patient_ID
)
SELECT p.Patient_ID, p.Name, v.Total_Visits
FROM Patients_Info p
JOIN Visit_Count v ON p.Patient_ID = v.Patient_ID
WHERE v.Total_Visits > 3;


SELECT 
    CASE 
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '51+'
    END AS Age_Group,
    AVG(h.BMI) AS Avg_BMI,
    COUNT(h.Patient_ID) AS Total_Patients
FROM Patients_Info p
JOIN Health_metrics_info h ON p.Patient_ID = h.Patient_ID
GROUP BY 
    CASE 
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '51+'
    END;



	SELECT p.Patient_ID, p.Name
FROM Patients_Info p
LEFT JOIN Visits_Info v ON p.Patient_ID = v.Patient_ID
WHERE v.Patient_ID IS NULL;

SELECT Diagnosis, AVG(Duration_Days) AS Avg_Visit_Duration
FROM Visits_Info
GROUP BY Diagnosis
ORDER BY Avg_Visit_Duration DESC;


SELECT 
    CASE 
        WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal Weight'
        WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS BMI_Category,
    COUNT(*) AS Total_Patients
FROM Health_metrics_info
GROUP BY 
    CASE 
        WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal Weight'
        WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END;




	SELECT 
    p.Patient_ID, 
    p.Name, 
    p.Age, 
    COUNT(v.Visit_ID) AS Total_Visits,
    AVG(v.Duration_Days) AS Avg_Visit_Duration,
    h.BMI, 
    h.Blood_Pressure, 
    h.Last_Checkup
FROM Patients_Info p
LEFT JOIN Visits_Info v ON p.Patient_ID = v.Patient_ID
LEFT JOIN Health_metrics_info h ON p.Patient_ID = h.Patient_ID
GROUP BY 
    p.Patient_ID, p.Name, p.Age, 
    h.BMI, h.Blood_Pressure, h.Last_Checkup
ORDER BY p.Patient_ID;



SELECT TOP 10 Patient_ID, Last_Checkup
FROM Health_metrics_info
ORDER BY Last_Checkup DESC;
