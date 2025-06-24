CREATE DATABASE if not exists resume_ranking_system;
USE resume_ranking_system;

CREATE TABLE if not exists candidates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    experience INT,
    location VARCHAR(50)
);

CREATE TABLE if not exists skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE
);

CREATE TABLE if not exists candidate_skills (
    candidate_id INT,
    skill_id INT,
    FOREIGN KEY (candidate_id) REFERENCES candidates(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id),
    PRIMARY KEY (candidate_id, skill_id)
);

CREATE TABLE if not exists job_requirements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    location VARCHAR(50),
    min_exp INT
);

CREATE TABLE if not exists job_skills (
    job_id INT,
    skill_id INT,
    FOREIGN KEY (job_id) REFERENCES job_requirements(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id),
    PRIMARY KEY (job_id, skill_id)
);

INSERT INTO candidates (id,name, email, experience, location) VALUES
(101,'Sireesha R', 'sireesha@example.com', 2, 'Hyderabad'),
(102,'Aarav Nair', 'aarav@example.com', 4, 'Bangalore'),
(103,'Megha Sharma', 'megha@example.com', 3, 'Hyderabad');

SET SQL_SAFE_UPDATES = 0;

DELETE FROM candidate_skills;
DELETE FROM job_skills;
DELETE FROM skills;

INSERT INTO skills (id, name) VALUES
(1, 'Python'), (2, 'SQL'), (3, 'Data Analysis'), (4, 'Machine Learning'), (5, 'Excel');


INSERT INTO candidate_skills (candidate_id, skill_id) VALUES
(101, 1), (101, 2), (101, 5),
(102, 1), (102, 2), (102, 3), (102, 4),
(103, 2), (103, 3), (103, 5);


INSERT INTO job_requirements (title, location, min_exp) VALUES
('Data Analyst', 'Hyderabad', 2);

INSERT INTO job_skills (job_id, skill_id) VALUES
(1, 1),  -- Python
(1, 2),  -- SQL
(1, 3);  -- Data Analysis

SELECT c.name, COUNT(*) AS matched_skills
FROM candidates c
JOIN candidate_skills cs ON c.id = cs.candidate_id
JOIN job_skills js ON cs.skill_id = js.skill_id
WHERE js.job_id = 1
GROUP BY c.id
ORDER BY matched_skills DESC;

SELECT c.name
FROM candidates c
JOIN candidate_skills cs ON c.id = cs.candidate_id
WHERE cs.skill_id IN (SELECT skill_id FROM job_skills WHERE job_id = 1)
GROUP BY c.id
HAVING COUNT(DISTINCT cs.skill_id) = (SELECT COUNT(*) FROM job_skills WHERE job_id = 1);

SELECT c.name, COUNT(*) AS matched_skills
FROM candidates c
JOIN candidate_skills cs ON c.id = cs.candidate_id
JOIN job_skills js ON cs.skill_id = js.skill_id
WHERE js.job_id = 1 AND c.location = 'Hyderabad'
GROUP BY c.id
ORDER BY matched_skills DESC;
