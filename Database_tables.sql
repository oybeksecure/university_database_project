create database UNI_database;

create table classroom(
    building varchar(15) not null,
    room_number varchar(7) not null,
    capacity smallint check (capacity>=0),
    primary key (building,room_number)
);
select * from classroom

create table department(
    dept_name varchar(20) not null,
    building varchar(15),
    budget decimal(12,2) check (budget>0)
    primary key(dept_name)
);
select * from department

create table course(
    course_id varchar(8) not null,
    title varchar(50) not null,
    dept_name varchar(20),
    credits smallint check (credits>0)
    primary key(course_id),
    foreign key(dept_name)references department(dept_name)
    on delete set null on update cascade
);
select * from course

create table instructor(
    instructor_id varchar(5) not null,
    name varchar(20) not null,
    dept_name varchar(20),
    salary decimal(8,2) check (salary>3000),
    primary key (instructor_id),
    foreign key(dept_name)references department(dept_name)
    on delete set null on update cascade
);
select * from instructor

create table time_slot(
    time_slot_id varchar(4) not null,
    day char(1) check(day in ('M','T','W','R','F','S','U')),
    start_time time not null,
    end_time time not null,
    primary key(time_slot_id),
    check(start_time<end_time),
    unique(day,start_time)
);
select *from time_slot

create table section(
    course_id varchar(8) not null,
    sec_id varchar(8) not null,
    semester char(6) not null check (semester in('FALL','WINTER','SPRING','SUMMER')),
    year smallint not null check(year>1800 and year<2100),
    building varchar(15),
    room_number varchar(7),
    time_slot_id varchar(4),
    primary key(course_id,sec_id,semester,year),
    foreign key(course_id)references course(course_id)
    on delete cascade on update cascade,
    foreign key(building,room_number)references classroom(building,room_number)
    on delete set null,
    foreign key(time_slot_id)references time_slot(time_slot_id)
    on delete set null
);
select *from section;


create table teaches(
    instructor_id varchar(5) not null,
    course_id varchar(8) not null,
    sec_id varchar(8) not null,
    semester char(6) not null,
    year smallint not null,
    primary key(instructor_id,course_id,sec_id,semester,year),
    foreign key(course_id,sec_id,semester,year)
                                    references section(course_id,sec_id,semester,year) on delete cascade on update cascade,
    foreign key(instructor_id)references instructor(instructor_id) on delete cascade
);
select *from teaches

create table student(
    student_id varchar(5) not null,
    name varchar(20) not null,
    dept_name varchar(20) ,
    tot_credit smallint default 0 check (tot_credit>0),
    primary key (student_id),
    foreign key(dept_name)references department(dept_name) on delete set null on update cascade
);
select *from student

create table takes(
    student_id varchar(5),
    course_id varchar(8) not null,
    sec_id varchar(8) not null,
    semester char(6) not null,
    year smallint not null,
    grade varchar(2) check (grade in('A+','A','B+','B','C+','C','D+','D','F',null)),
    primary key(student_id,course_id,sec_id,semester,year),
    foreign key(course_id,sec_id,semester,year)
                                    references section(course_id,sec_id,semester,year) on delete cascade on update cascade,
    foreign key (student_id) references student(student_id) on delete cascade                               
);
select *from takes 

create table advisor (
    student_id varchar(5),
    instructor_id varchar(5) ,
    primary key(student_id),
    foreign key(instructor_id)references instructor( instructor_id) on delete set null,
    foreign key(student_id)references student(student_id) on delete cascade
);
select *from advisor

create table prereq(
    course_id varchar(8) not null,
    prereq_id varchar(8) not null,
    primary key(course_id ,prereq_id ),
    foreign key( course_id)references course(course_id) on delete cascade on update cascade
);
select *from prereq

