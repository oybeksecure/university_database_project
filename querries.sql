--Arithmetic Operators

select *from course

select course_id,credits,credits+1 as increased_creadits
from course

select dept_name,budget,budget-5000 as reduced_budget
from department

select instructor_id,name,salary, salary*1.05 as new_salary
from instructor

select dept_name, budget, budget/12 as monthly_budget
from department

select student_id, tot_credit, tot_credit%10 as reminder_credit
from student


--Comparison operators
select *
from course
where dept_name='History'

select *
from student
where tot_credit>50


--Logical Operators
select * 
from section
where not semester='Spring' 

--bitwise operators

select student_id,tot_credit,tot_credit & 1 as is_odd
from student

--string operators

select course_id, CONCAT(title,'-',dept_name) as course_inf 
from course

select *
from instructor
where name not like 'A%'

select * 
from course 
where title like '_a%'

select dept_name
from department
where dept_name like '%\./%' escape '\'

select * 
from course
where title like 'Intro%'

--set operators

select dept_name
from department
EXCEPT
  (select dept_name 
  from student
  )

  select * 
  from takes
  where grade not in ('A','A+')

select *
from instructor
where salary between 60000.00 and 70000.00 

select * 
from course
where dept_name is not null

select *
from instructor i
where exists
     ( select *
     from teaches t
     where t.instructor_id=i.instructor_id
     )
  

select *
from INFORMATION_SCHEMA.TABLES  


select concat(building,'_','Room','_',room_number) as classroom_name,capacity
from classroom

select building, room_number,capacity
from classroom
where (capacity >30 and building='Alumni Hall')

select course_id,title
from course
where dept_name='Computer Science'

select building, room_number,capacity
from classroom
order by capacity desc,building asc



--Inner Join

select course.course_id,course.title, department.dept_name,department.building
from course
inner join department on course.dept_name=department.dept_name



select * from section
select * from classroom

select section.course_id,section.sec_id,section.semester,section.year,
          classroom.building,classroom.room_number,classroom.capacity
from section
inner join  classroom on section.building=classroom.building  and section.room_number=classroom.room_number        


--left join

select course.course_id,course.title, department.dept_name,department.budget
from course
left join  department on  course.dept_name=department.dept_name


insert into instructor (instructor_id,name,dept_name,salary)
values('I1004','Brown',NULL,70000)

select instructor.instructor_id,instructor.name,department.dept_name
from instructor
left join department on instructor.dept_name=department.dept_name


--right join
select department.dept_name,department.building,course.course_id,course.title
from course
right join department on course.dept_name=department.dept_name


select department.dept_name,department.building,instructor.instructor_id,instructor.name
from instructor
right join department on instructor.dept_name=department.dept_name


select * from department



--full join

select course.course_id,course.title,department.dept_name,department.building
from course
full join department on course.dept_name=department.dept_name

select instructor.instructor_id,instructor.name, department.dept_name
from instructor
full join department on instructor.dept_name=department.dept_name



-- self join 

select  c1.course_id as course,c1.title as course_title,
         c2.course_id as prerequisite, c2.title as prereq_title         
from course c1
left join prereq on c1.course_id=prereq.course_id
left join course as c2 on prereq.prereq_id=c2.course_id


select a1.student_id as student1, s1.name as name1,
       a2.student_id as student2, s2.name as name2,
       a1.instructor_id
from advisor as a1
join advisor as a2 on a1.instructor_id=a2.instructor_id and a1.student_id < a2.student_id
join student as s1 on a1.student_id=s1.student_id
join student as s2 on a2.student_id=s2.student_id



--joining multiple tables

select  student.student_id, student.name, course.course_id,course.title,instructor.name as instructor_name
from student
join takes on student.student_id=takes.student_id
join section on takes.course_id=section.course_id
             and takes.sec_id=section.sec_id
             and takes.semester=section.semester
             and takes.year=section.year
join course on section.course_id=course.course_id
join teaches on section.course_id=teaches.course_id
             and section.sec_id=teaches.sec_id
             and section.semester=teaches.semester
             and section.year=teaches.year                
join instructor on teaches.instructor_id=instructor.instructor_id



select course.course_id,course.title, section.semester, section.year, classroom.building,classroom.room_number,
       time_slot.day,time_slot.start_time,time_slot.end_time
from course
join section on course.course_id=section.course_id
left join classroom on section.building=classroom.building
                and section.room_number=classroom.room_number
left join time_slot on section.time_slot_id=time_slot.time_slot_id




-- single row subquery

select title,
     (
      select max(salary) from instructor
     ) as max_university_salary
from course     


select dept_name,
    (
        select count(*) from course
    ) as total_cousres
from department    


select d.dept_name, d.budget
from department d
where d.budget > (
    select avg(budget) from department
)


select instructor_id,name,salary
from instructor
where salary >(
    select min(salary) 
    from instructor
    where dept_name='Physics'
    )


--multi-row subquerries

select name
from instructor
where instructor_id in (
    select instructor_id 
    from teaches
    where course_id in (
        select course_id
        from course
        where dept_name='Computer Science'
    )
)


select name 
from student
where student_id in (
    select student_id
    from takes
    where course_id in(
        select course_id
        from course
        where credits >3
    )
)


select name
from instructor
where salary > all (
    select salary 
    from instructor
    where dept_name='History'
)


select avg(capacity) as avg_classroom_capacity
from (
    select distinct classroom.capacity
    from section
    join classroom on section.building=classroom.building and section.room_number=classroom.room_number
    where section.course_id in (
        select course_id 
        from course
        where dept_name = 'Physics'
    )
    and section.semester='Fall'
    and section.year=2023
) as physics_classroom



--correlated subqueries

select student_id,name
from student s
where exists(
    select 1
    from takes as t
    join course c on t.course_id=c.course_id
    where t.student_id=s.student_id and c.dept_name=s.dept_name
)

select * from classroom
select * from teaches

select instructor_id,name
from instructor i
where exists
(
    select capacity
    from classroom
    where capacity>50
    
)

select name 
from instructor i 
where exists(
    select 1
    from teaches t 
    join section s on t.course_id=s.course_id and t.sec_id=s.sec_id and t.semester=s.semester and t.year=s.year 
    join classroom c on s.building=c.building and s.room_number=c.room_number
    where t.instructor_id=i.instructor_id and capacity >50
)




--Conditional logic

--case statement

select course_id,title,credits,
    case credits
          when 1 then 'low'
          when 2 then 'low'
          when 3 then 'standard'
          when 4 then 'high'
          else 'special'
    end as creedit_catagory      
from course
where dept_name='Computer Science'

select *from takes 

select top 5 
   student_id,course_id,grade,
    case 
        when grade in ('A' , 'A+') then 'Excellent'
        when grade in ('B' ,'B-' , 'B+') then 'Good'
        when grade in ('C' , 'C-' ,'C+') then 'Satisfactory'
        when grade in ('D' , 'D+') then 'Needs improvement'
        when grade = 'F' then 'Fail'
        else 'not graded'
    end as grade_description    
from takes
where semester='Fall' and year=2023




select name , salary,
   case 
      when salary >100000 then 1
      when salary between 70000 and 100000 then 2
      else 3
   end as salary_rank   
from instructor
-- where dept_name='Computer Science'
order by salary_rank,salary desc

select *from instructor

select instructor_id,name,
   coalesce(dept_name,'NO Department') as department
from instructor

insert into course (course_id,title,dept_name,credits)
values('CYB-101','Cyber Security', 'Computer Science',1)

select course_id,title,
  nullif(credits,1) as adjusted_credits
from course

select * from course



--Data and Time

--DATE: YYYY-MM-DD 2025-05-10
--TIME: HH:MM:SS:TTT 14:30:00:123
--DATETIME: 2025-05-10 14:30:00:123
--DATETIME2: 2025-05-10 14:30:00:1234567
--SMALLDATETIME: 2025-05-10 14:30:00
--DATETIMEOFFSET: 2025-05-10 14:30:00 +05:30

select getdate() as current_datetime,sysdatetime() as current_datetime2


select CURRENT_TIMESTAMP as [current_timestamp]

select dateadd(day,7,'2025-05-10') as one_week_later

select dateadd(month,-2,'2025-05-10') as two_month_earlier

select datediff(year,'2023-01-23', '2025-05-10') as year_diff

select datepart(year,'2025-05-10 14:30:00') as year,
       datepart(month,'2025-05-10 14:30:00') as month,
       datepart(day,'2025-05-10 14:30:00') as day;

select year('2025-05-10') as year,
       month('2025-05-10') as month,
       day('2025-05-10') as day


select format(cast('2025-05-10 14:30:00'as datetime), 'MMMM dd, yyyy hh:mm tt') as formatted_date

select eomonth('2025-05-10') as last_day_of_month

select datefromparts(2025,05,10) as constructed_date

select datename(month ,'2025-05-10') as month_name,
       datename(weekday, '2025-05-10') as weekday_name



create table employee(
    id int primary key,
    name varchar(50),
    hire_date date,
    last_login datetime2
)


select * 
from employee

insert into employee( id, name, hire_date,last_login)
values
 (1,'Neo', '2023-01-15', '2025-05-10 08:45:00'),
 (2,'Jack', '2024-04-23', '2025-05-10 15:33:00'),
 (3,'Khabib', '2021-07-05', '2025-05-10 12:23:00')

 select name, hire_date
 from employee
 where hire_date between '2023-01-01' and '2024-12-31'

select name, datediff(year,hire_date,'2025-05-10') as years_employed
from employee

select name, dateadd(month,6, hire_date) as six_month_later
from employee


select name , format(last_login, 'MMMM dd, yyyy hh:mm tt') as formatted_login
from employee

select name,hire_date 
from employee
where month(hire_date)=4



--Index

--Clustered Index

select *
from student



create table student1(
    student_id varchar(10) primary key,
    name varchar(50),
    dept_name varchar(50),
    tot_credit int
)

select *
from student1


begin transaction;
begin try
      with Numbers as (
        select top 50000 ROW_NUMBER() over(order by(select null)) as n 
        from sys.objects a
        cross join sys.objects b 
        cross join sys.objects c 
      )
    insert into student1(student_id,name,dept_name,tot_credit)
    select 
         'S' + right('00000'+ cast(n as varchar(5)),6),
         'Student_' + cast(n as varchar(10)),
         case 
            when n%10 = 0 then 'Computer Science'
            when n%10 = 1 then 'Biology'
            when n%10 = 2 then 'Electrical Engineering'
            when n%10 = 3 then 'Mechanical Engineering'
            when n%10 = 4 then 'Physics'
            when n%10 = 5 then 'Chemistry'
            when n%10 = 6 then 'Mathematics'
            when n%10 = 7 then 'History'
            when n%10 = 8 then 'Economics'
            else 'English'
         end,
              (n%121)+30
    from Numbers

    commit transaction;
    print 'Succesfully inserted 50,000 records into student1 table'
end try

begin catch
   rollback transaction
   print 'error inserting record'+Error_Message();
end catch
Go   


select count(*) from student1


declare @StartTime datetime, @EndTime datetime,@duration int

print 'Running query without index...'

set @StartTime = getdate()

select * 
from student1
where dept_name='Physics'

set @EndTime = getdate()
set @duration = datediff(millisecond ,@StartTime,@EndTime)
print 'Query without index completed in '+ cast (@duration as varchar(10))+'ms'
go


dbcc freeproccache;
dbcc dropcleanbuffers
GO
--Non-Clustered Index

create index ix_student_dept_name4 on student1(dept_name)

declare @starttime datetime, @endtime datetime, @duration int

print 'running without index...'
set @starttime=getdate()

select * 
from student1


set @endtime=getdate()

set @duration=datediff(millisecond,@starttime,@endtime)
print 'Query with index completed in '+ cast (@duration as varchar(10))+'ms'
go

--Unique Index

if exists (select name from sys.indexes where name='idx_course_dept_name' and object_id=object_id('course'))
      drop index idx_course_dept_name on course;
create index idx_course_dept_name on course(dept_name)      


select * 
from course 
where dept_name='Computer Science'


if exists (select name from sys.indexes where name='idx_department_dept_name' and object_id=object_id('department'))
      drop index idx_department_dept_name on department;
create index idx_department_dept_name on department(dept_name)


--Composite Index


if exists (select name from sys.indexes where name='idx_section_course_semester' and object_id=object_id('section'))
      drop index idx_section_course_semester on section;
create index idx_section_course_semester on section(course_id,semester)


select *
from section
where course_id='CS101' and semester='Fall'


drop index idx_section_course_semester on section




--SQL VIEWS
go

create view  CourseDetails
as
select
      c.course_id,
      c.title,
      c.dept_name,
      c.credits
from course c 
where c.credits >= 2 
go

select * from CourseDetails
where dept_name='Computer Science'
go
create view InstructorAssignments1
as 
select 
     i.instructor_id,
     i.name as instructor_name,
     i.dept_name,
     t.course_id,
     t.sec_id,
     t.semester,
     t.year
from instructor i 
join teaches t on i.instructor_id=t.instructor_id
join section s on t.course_id=s.course_id and t.sec_id=s.sec_id and t.semester=s.semester and t.year=s.year
go
select * from instructor
select * from teaches
select * from section

select * from  InstructorAssignments


GO
alter view CourseDetails
as 
select 
   c.course_id,c.title,c.credits,c.dept_name,d.budget as dept_budget
from course c 
join department d on c.dept_name=d.dept_name
where c.credits >= 2
GO
select * from course
select * from department

select * from CourseDetails



select course_id,title,dept_budget
from CourseDetails
where credits > 3

-- drop a view

drop view if exists CourseDetails



--Indexed View
go
create view DepartmentCourseCount1
with schemabinding 
as 
select 
    d.dept_name,
    count_big(*) as course_count
from dbo.department d 
join dbo.course c on d.dept_name=c.dept_name
group by d.dept_name
go


create unique clustered index idx_DepartmentCourseCount
on DepartmentCourseCount(dept_name)

select * from DepartmentCourseCount


-- Check with option Views
go
create view HighCreditCourse1
as 
select
   course_id,title,dept_name,credits
from course 
where credits >=3
with check option
go
insert into  HighCreditCourse(course_id,title,dept_name,credits)
values ('CS9999', 'Test Course','Computer Science',2)

update HighCreditCourse
set credits=4
where course_id='CS101'


--Security and Permissions with Views
go
create view StudentGrade
as 
select 
    s.student_id,s.name,t.course_id,t.grade
from student s 
join takes t on s.student_id=t.student_id
where t.semester='FALL' and year=2023
go

select * from student
select * from takes


select * from  StudentGrade

grant select on StudentGrade to public


--Performance Consideration

go
create view ClassromUse 
as 
select
    s.building,s.room_number,s.time_slot_id,c.capacity
from section s 
join classroom c on s.building=c.building and s.room_number=c.room_number
where s.semester='FALL' and s.year=2023
go
select * from ClassromUse





-- SQL Window  Functions

-- Partition By 
-- Order By

select i.dept_name,i.salary,
       row_number()over(partition by dept_name order by salary desc) as row_num,
       rank() over(partition by dept_name order by salary desc) as rank, 
       dense_rank()over(partition by dept_name order by salary desc) as dense_rank
from instructor i
order by dept_name,salary desc



select c.title,c.dept_name,c.credits,
    row_number()over(partition by dept_name order by credits desc) as row_num,
    rank() over(partition by dept_name order by credits desc) as rank, 
    dense_rank()over(partition by dept_name order by credits desc) as dense_rank
from course c 
where dept_name is not null 
order by dept_name,credits desc



select s.name,s.tot_credit,
    row_number()over(order by tot_credit desc) as row_num,
    rank() over(order by tot_credit desc) as rank, 
    dense_rank()over(order by tot_credit desc) as dense_rank
from student s 
order by tot_credit desc;


select course_id,sec_id,semester,year,
    row_number()over(partition by course_id,semester,year order by sec_id) as section_number
from section  
order by course_id,semester,year,sec_id;



select instructor_id,name,dept_name,salary,
    dense_rank() over(partition by dept_name order by salary desc) as salary_rank
from instructor
where dept_name is not null
order by dept_name,salary desc;


select c.dept_name,c.title,c.credits,
    count(*) over (partition by dept_name) as course_count,
    rank() over(partition by dept_name order by credits desc) as credit_rank
from course c
where dept_name is not null
order by dept_name,credits desc;


select dept_name,budget,
   sum(budget) over (order by budget desc rows between unbounded preceding and current row) as running_total
from department
order by budget desc


select s.name,s.dept_name,s.tot_credit,
      sum(tot_credit) over (partition by dept_name order by tot_credit desc rows between unbounded preceding and current row) as running_total
from student s
where dept_name is not null
order by dept_name,tot_credit desc;


select c.dept_name,c.title,c.credits,
    sum(c.credits) over (partition by dept_name order by credits desc rows between unbounded preceding and current row) as running_credits
from course c
where dept_name is not null
order by dept_name,credits desc;


select name,dept_name,salary,
      cast(round(avg(cast(salary as decimal(10,2))) over(partition by dept_name order by salary desc rows between 1 preceding and 1 following
      ),2) as decimal(10,2)) as moving_average
from instructor
where dept_name is not null
order by dept_name,salary desc



-- CTE 


with HighCapacityClassroom as (
    select building,room_number, capacity
    from classroom
    where capacity  > 50
)

select hcc.building,hcc.room_number,hcc.capacity,d.dept_name
from HighCapacityClassroom hcc
left join department d on hcc.building=d.building
order by hcc.capacity desc



with InstructorCourses as (
    select  i.instructor_id,i.name as instructor_name,   
    c.course_id,c.title as course_title,c.dept_name,t.semester,t.year
    from instructor i
    join teaches t on i.instructor_id=t.instructor_id
    join course c on t.course_id=c.course_id
) 

select *
from InstructorCourses 
where semester='FALL' and year=2023 and dept_name='Computer Science'
order by instructor_name ,course_id


with HighCreditCourse as (
    select course_id
    from course
    where credits > 3
),
StudentCourses as(
    select t.student_id,t.course_id
    from takes t 
    join HighCreditCourse hcc on t.course_id=hcc.course_id
)

select s.student_id,s.name as student_name, i.name as advisor_name
from StudentCourses sc 
join student s on sc.student_id=s.student_id
left join advisor a on s.student_id= a.student_id
left join instructor i on a.instructor_id=i.instructor_id
order by s.student_id



with CoursePrereqs(course_id,prereq_id,level) as(
      select course_id,prereq_id , 1 as level
      from prereq
      where course_id = 'BIO-301'

      union all  

      select p.course_id,p.prereq_id,cp.level +1
      from prereq p
      join CoursePrereqs cp on p.course_id=cp.prereq_id     
)

select  c.course_id,c.title as course_title,cp.prereq_id,pc.title as prereq_title, cp.level
from CoursePrereqs cp 
join course c on cp.course_id=c.course_id
join course pc on cp.prereq_id=pc.course_id
order by cp.level,cp.prereq_id


select * from prereq




-- Stored Procedures
go
create procedure GetClassroomDetails
as
begin

    select building,room_number,capacity
    from classroom
    order by building,room_number
end
 
exec  GetClassroomDetails



select * from classroom
order by building,room_number


GO
create procedure CountCoursesDepartment
as 
begin
    select dept_name, count(*) as course_count
    from course
    where dept_name is not null
    group by dept_name
    order by dept_name
end 
go

exec CountCoursesDepartment

select * from course

go
create procedure GetCoursesDepartment
   @dept varchar(20)
as 
begin   
     select course_id,title,credits
     from course
     where dept_name=@dept
     order by course_id
end 
GO

exec GetCoursesDepartment @dept='Computer Science'


go
create procedure GetInstCountDept
          @dept varchar(20),
          @ins_count int output
as
begin
     select  @ins_count=count(*)
     from instructor
     where dept_name=@dept
end
go

declare @count int;
exec  GetInstCountDept @dept='Computer Science',@ins_count = @count output;
select @count as instructor_count


go 
create procedure AdjustDeptBudget
       @budget_value decimal(12,2) output,
       @adjustment_percentage decimal(5,2)
as
begin
     set @budget_value=@budget_value*(1+@adjustment_percentage/100)
end 
go

declare @budget decimal (12,2)=10000.00
exec AdjustDeptBudget @budget_value=@budget output, @adjustment_percentage=10.00;
select @budget as adjusted_budget


-- Error Handling in Stored Procedure
GO
create procedure AddNewInstructor
   @inst_id varchar(5),
   @inst_name varchar(20),
   @dept varchar(20),
   @inst_salary decimal(8,2),
   @error_message nvarchar(100) output
as  
begin
    set nocount on;
    set @error_message = ' ';

     begin try
        insert into instructor(instructor_id,name,dept_name,salary)
        values (@inst_id,@inst_name,@dept,@inst_salary);
        set @error_message = 'Instructor added successfully.';
     end try 
     begin catch
      set @error_message = 'Error: Failed to Insert Instructor.'+ERROR_MESSAGE();
     end catch
end 
GO


declare @error_msg nvarchar(100)
exec AddNewInstructor
   @inst_id = '9999999',
   @inst_name = 'Roy',
   @dept = 'Computer ',
   @inst_salary = 50000,
   @error_message = @error_msg output;
select @error_msg as result;


select * from instructor

GO
CREATE FUNCTION dbo.fn_CountInstructorsByDept1
(
    @dept_name VARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM instructor
    WHERE dept_name = 'Computer Science';

    RETURN @count;
END;
GO

GO
CREATE FUNCTION dbo.fn_SalaryBracket1
(
    @salary DECIMAL(10,2)
)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @bracket VARCHAR(20);

    IF @salary < 50000
        SET @bracket = 'Low';
    ELSE IF @salary BETWEEN 50000 AND 100000
        SET @bracket = 'Medium';
    ELSE
        SET @bracket = 'High';

    RETURN @bracket;
END;
GO




--Triggers

select *from student

alter table student
ADD
   DoB date null,
   age SMALLINT null
GO
create trigger trg_update_age,
on student
after insert ,update
as 
begin  
      set nocount on;
      update s
      set age = datediff(year, i.DoB,getdate())
      from student s
      inner join inserted i on s.student_id=i.student_id
      where i.DoB is not null
end       
GO
select *from student

update student
set DoB = case student_id
        when 1 then '1998-05-15'
        when 2 then '1998-05-15'
        when 3 then '1998-05-15'
        when 4 then '1998-05-15'
        when 5 then '1998-05-15'
        when 6 then '1998-05-15'
        when 7 then '1998-05-15'
        when 8 then '1998-05-15'
        when 9 then '1998-05-15'
        when 10 then '1998-05-15'
        when 11 then '1998-05-15'
        when 12 then '1998-05-15'
        when 13 then '1998-05-15'
        when 14 then '1998-05-15'
        when 15 then '1998-05-15'
        when 16 then '1998-05-15'
        when 17 then '1998-05-15'
        when 18 then '1998-05-15'
        when 19 then '1998-05-15'
        when 20 then '1998-05-15'
        when 21 then '1998-05-15'
        when 22 then '1998-05-15'
        when 23 then '1998-05-15'
        when 24 then '1998-05-15'
        when 25 then '1998-05-15'
        when 26 then '1998-05-15'
        when 27 then '1998-05-15'
        when 28 then '1998-05-15'
        when 29 then '1998-05-15'
        when 30 then '1998-05-15'
        when 31 then '1998-05-15'
        when 32 then '1998-05-15'
        when 33 then '1998-05-15'
        when 34 then '1998-05-15'
        when 35 then '1998-05-15'
        when 36 then '1998-05-15'
        when 37 then '1998-05-15'
        when 38 then '1998-05-15'
        when 39 then '1998-05-15'
        when 40 then '1998-05-15'
        when 41 then '1998-05-15'
        when 42 then '1998-05-15'
        when 43 then '1998-05-15'
        when 44 then '1998-05-15'
        when 45 then '1998-05-15'
        when 46 then '1998-05-15'
        when 47 then '1998-05-15'
        when 48 then '1998-05-15'
        when 49 then '1998-05-15'
        else '1998-05-15'
end        
where student_id in(
'S0001',
'S0002',
'S0003',
'S0004',
'S0005',
'S0006',
'S0007',
'S0008',
'S0009',
'S0010',
'S0011',
'S0012',
'S0013',
'S0014',
'S0015',
'S0016',
'S0017',
'S0018',
'S0019',
'S0020',
'S0021',
'S0022',
'S0023',
'S0024',
'S0025',
'S0026',
'S0027',
'S0028',
'S0029',
'S0030',
'S0031',
'S0032',
'S0033',
'S0034',
'S0035',
'S0036',
'S0037',
'S0038',
'S0039',
'S0040',
'S0041',
'S0042',
'S0043',
'S0044',
'S0045',
'S0046',
'S0047',
'S0048',
'S0049',
'S0050'
)
GO
CREATE TRIGGER trg_uppercase_course_title1
on course 
after insert, update
as 
begin
   set nocount on;
   update c
   set title= upper(title)
   from course c
end

GO
CREATE TRIGGER trg_default_budget
on department
instead of INSERT
as 
BEGIN
insert into department(dept_name,building,budget)
SELECT
     dept_name,
     building,
     isnull(budget,100000)
from inserted;     
END;
GO

insert into department(dept_name,building,budget)
values('New AI1','Taylor Hall',NULL);

select * from department

