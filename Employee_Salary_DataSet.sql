SELECT * FROM employee_salary_dataset;	

#1.Retrieve all employee names and their monthly salaries.
SELECT Name, Monthly_salary from employee_salary_dataset;

#2. Find the names of all employees who work in the 'IT' department.
select Name, Department from employee_salary_dataset where Department like 'IT';

#3. List the unique cities where the employees are located.
select distinct(city) as Unique_cities from employee_salary_dataset;

#4. Display the details (all columns) of the employee with the highest 'Experience_Years'.
Select * from employee_salary_dataset where Experience_Years = (select Max(Experience_Years) from employee_salary_dataset);

#5. Get the names and ages of employees who are over 30 and have a 'Bachelor's' degree, sorted by their age in descending order.
select name, age from employee_salary_dataset where age >30 and Education_Level like 'Bachelor%' order by age desc;

#6. Calculate the total number of employees in the dataset
select count(*) as Total_Employees from employee_salary_dataset;

#7. Find the average 'Month_Salary' for all employees.
Select avg(Monthly_Salary) as Month_Salary from employee_salary_dataset;

#8. Determine the average 'Experience_Years' for employees in each 'Department'.
select Department, avg(Experience_Years) as Avg_Experience_Years from employee_salary_dataset group by Department having avg(Experience_Years);

#9. Identify the 'Department' that has the highest average salary.
Select Department, Avg(Monthly_Salary) as Highest_Avg_Salary from employee_salary_dataset group by Department having avg(Monthly_Salary)
order by Highest_Avg_Salary desc limit 1;

#10. List the 'Education_Level' and the count of employees for each level, but only for levels that have more than 5 employees.
select Education_Level, count(Name) as Count_of_Employees from employee_salary_dataset group by Education_Level Having Count_of_Employees >5;

#11. Find the difference between the maximum and minimum salary in the entire company.
Select Max(Monthly_Salary)-min(Monthly_Salary) as Difference_Salary from employee_salary_dataset;

#12. Give a 5% salary increase to all employees in the 'Sales' department.
SET SQL_SAFE_UPDATES = 0; #Use this statement before using UPDATE & SET Fuction
Update employee_salary_dataset SET Monthly_Salary = Monthly_Salary*1.05 where department like 'Sales';

SET SQL_SAFE_UPDATES =1; #Use this statement after using UPDATE & SET Function

#13. Add a new column called 'Annual_Salary' to the table.
Alter Table employee_salary_dataset
Add column Annual_Salary int;

#Addition
Update employee_salary_dataset
SET Annual_Salary = Monthly_Salary*12
Where Annual_Salary is null and 0;

Update employee_salary_dataset
SET Annual_Salary = Monthly_Salary*12
where Annual_Salary = 0;

#14. Insert a new employee record.
Insert into employee_salary_dataset
values
(51,"Employee_51","IT",5,"Master",30,"Male","Delhi",50000,0);

#15. Delete all records of employees who have less than 1 year of experience and work in the 'HR' department
Delete from employee_salary_dataset
where Experience_Years < 1;

#16. Change the 'Education_Level' from 'Masters' to 'Master's Degree' for consistency.
Update employee_salary_dataset
SET Education_Level = 'Master"s Degree'
Where Education_Level = 'Masters';

#17. Create a new column called 'Salary_Tier' based on the following conditions:
#If 'Month_Salary' > 80000, label it 'High Salary'.
#If 'Month_Salary' is between 40000 and 79999, label it 'Medium Salary'.
# Otherwise, label it 'Low Salary'.

Select *,
Case
When Monthly_salary >= 80000 then 'High Salary'
When Monthly_salary between 40000 and 79999 then 'Medium Salary'
Else 'Low Salary' END As Salary_Tier
from employee_salary_dataset;

#18. Calculate the number of employees for each 'Gender', and for any gender other than 'Male' or 'Female', categorize them as 'Other'.
Select
Case
When Gender in ('Male','Female') then Gender
Else 'Others'
End As Gender_Category,
Count(*) as Number_of_Gender
from employee_salary_dataset
group by Gender_Category
order by Number_of_Gender;

##. V. Advanced Scenarios (Subqueries and Window Functions - if your MySQL version supports them)
#19. Find the names and salaries of employees whose salary is greater than the average salary of their respective 'Department'.
Select Name, Monthly_Salary from
(Select Name, Monthly_Salary, Avg(Monthly_Salary) over (partition by Department) as avg_Department_Salary from Employee_Salary_Dataset) as T
where Monthly_salary > avg_Department_Salary;

#20. Write a query using a window function (like RANK or DENSE_RANK) to partition the employees by Department and find the top 3 highest-paid employees
#within each department.
Select Name, Department, Monthly_Salary from
(Select Name, Department, Monthly_Salary,
dense_rank() Over	(partition by Department Order by Monthly_Salary Desc ) as Dep_Salary_Rank from employee_salary_dataset) As RankenkEmployee
Where Dep_Salary_Rank <=3 order by Department, Dep_Salary_Rank;

#21. How would you update the Monthly_Salary for all employees in the 'Sales' Department who have more than 5 Experience_Years, giving them a 10% 
#raise? (Provide the UPDATE statement).
SET SQL_SAFE_UPDATES = 0;
UPDATE employee_salary_dataset SET Monthly_Salary = Monthly_Salary*1.1 where Department like 'Sales' AND Experience_Years>5;

#22. Write a query to calculate the difference between the maximum Annual_Salary and the minimum Annual_Salary for employees who have an 
#Education_Level of 'Master's Degree' (or a similar specific level).
SELECT
    -- Calculate the difference between the maximum and minimum annual salary 
    -- from the filtered subset of data.
    MAX(Annual_Salary) - MIN(Annual_Salary) AS MaxMin_Salary_Difference,
    MAX(Annual_Salary) AS Max_Annual_Salary,
    MIN(Annual_Salary) AS Min_Annual_Salary
FROM
    employee_salary_dataset
-- The WHERE clause filters the dataset BEFORE the aggregate functions run.
WHERE
    Education_Level = 'Master';

#23. How would you create a stored procedure or a view to display the Name, Department, and Monthly_Salary of employees whose Age is above 30, and 
#why would you choose one over the other in a professional context?
create View View1 as
Select Name, Department, Monthly_Salary from employee_salary_dataset where Age >30;
Select * from View1;