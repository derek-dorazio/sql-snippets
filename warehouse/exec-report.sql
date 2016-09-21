
-- USER CREATION QUERIES
-- todo: warehouse model is missing created_on date

-- number of new students created yesterday
select count(*) as num_added_yesterday from dim_student s
inner join dim_account a on a.id = s.account_id
where a.account_type not in (8,9,10,11)
and s.deleted = false
and s.created_on = DATEADD (day, -1, CURRENT_DATE);

-- number of new staff members created yesterday
select count(*) as num_added_yesterday from dim_staff_member s
inner join dim_account a on a.id = s.account_id
where a.account_type not in (8,9,10,11)
and s.deleted = false
and s.created_on = DATEADD (day, -1, CURRENT_DATE);



-- LOGIN ACTIVITY QUERIES
-- todo: warehouse model is missing last_login_time

-- number of students that have logged in since the start of the school year
select count(distinct(s.id)) as num_active_students from dim_student s
inner join dim_account o on a.id = u.account_id
where a.account_type not in (8,9,10,11)
and s.active = true
and s.last_login_time > '2015-08-15';

-- number of staff members that have logged in since the start of school year
select count(distinct(s.id)) as num_active_staffs from dim_staff_member s
inner join dim_account a on a.id = u.account_id
where a.account_type not in (8,9,10,11)
and s.active = true
and s.last_login_time > '2015-08-15';

-- total number of student logins
select count(*) as student_num_logins from dim_student s 
where date_trunc('day', s.last_login_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))

-- total number of staff member logins 
select count(*) as staff_num_logins from dim_staff_member s
where date_trunc('day', s.last_login_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))

-- number of student logins by account
select count(*) as student_num_logins, a.name
from dim_student s
inner join dim_account a on a.id = s.account_id and a.current_academic_year = s.academic_year
where date_trunc('day', s.last_login_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
group by a.name
order by student_num_logins desc;

-- number of staff logins by account
select count(*) as staff_num_logins, a.name
from dim_staff_member s
inner join dim_account a on a.id = s.account_id and a.current_academic_year = s.academic_year
where date_trunc('day', s.last_login_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
group by a.name
order by student_num_logins desc;


-- ENROLLMENT QUERIES

-- total students enrolled in classes for current academic year (not try-it)
select count(distinct(s.id)) as totalStudentsEnrolled
from dim_student s
inner join dim_account a on a.id = s.account_id and a.current_academic_year = s.academic_year
inner join fact_student_enrollment enr on enr.student_academic_year_id = s.id and enr.current_flag = true
inner join dim_student_group sg on enr.institution_id = sg.id and sg.academic_year = a.current_academic_year and sg.student_group_type = 'CLASS'
where a.account_type not in (8,9,10,11);

-- total staff members (teachers and admins) enrolled in classes for current academic year (not try-it)
select count(distinct(s.id)) as totalStaffEnrolled
from dim_staff_member s
inner join dim_account a on a.id = s.account_id
inner join fact_staff_member_enrollment enr on enr.staff_member_id = s.id and enr.academic_year = a.current_academic_year and enr.current_flag = true
inner join dim_student_group sg on enr.institution_id = sg.id and sg.academic_year = a.current_academic_year and sg.student_group_type = 'CLASS'
where a.account_type not in (8,9,10,11);



-- DIAGNOSTIC ACTIVITY QUERIES

-- diagnostic test starts - ela
select count(activity_id) as num_students
from fact_student_assessment_ela
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'DIAGNOSTIC';

-- diagnostic test completions - ela
select count(activity_id) as num_students
from fact_student_assessment_ela
where date_trunc('day', completion_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'DIAGNOSTIC';

-- diagnostic test starts by hour - ela
select count(activity_id) as num_students, to_char(last_start_time, 'HH24:00') as hour
from fact_student_assessment_ela
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'DIAGNOSTIC'
group by hour
order by num_students desc;

-- diagnostic test starts - math
select count(distinct student_id) as num_students
from fact_student_assessment_math
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'DIAGNOSTIC';

-- diagnostic test completions - math
select count(distinct student_id) as num_students
from fact_student_assessment_math
where date_trunc('day', completion_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'DIAGNOSTIC';

-- diagnostic test starts by hour - math
select count(distinct student_id) as num_students, to_char(last_start_time, 'HH24:00') as hour
from fact_student_assessment_math
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -25, CURRENT_DATE))
and assessment_type = 'DIAGNOSTIC'
group by 2
order by 1 desc;



-- GROWTH MONITORING ACTIVITY QUERIES

-- growth monitoring test starts - ela
select count(distinct student_id) as num_students
from fact_student_assessment_ela
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'PROGRESS_MONITORING';

-- growth monitoring test completions - ela
select count(distinct student_id) as num_students
from fact_student_assessment_ela
where date_trunc('day', completion_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'PROGRESS_MONITORING';

-- growth monitoring test starts by hour - ela
select count(distinct student_id) as num_students, to_char(last_start_time, 'HH24:00') as hour
from fact_student_assessment_ela
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'PROGRESS_MONITORING'
group by hour
order by num_students desc;

-- growth monitoring test starts - math
select count(distinct student_id) as num_students
from fact_student_assessment_math
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'PROGRESS_MONITORING';

-- growth monitoring test completions - math
select count(distinct student_id) as num_students
from fact_student_assessment_math
where date_trunc('day', completion_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'PROGRESS_MONITORING';

-- growth monitoring test starts by hour - math
select count(distinct student_id) as num_students, to_char(last_start_time, 'HH24:00') as hour
from fact_student_assessment_math
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and assessment_type = 'PROGRESS_MONITORING'
group by hour
order by num_students desc;

-- ISM ACTIVITY QUERIES

-- ism test starts - math
SELECT COUNT(DISTINCT assignment_id) AS ism_tests_started
FROM prod_skynet.fact_student_sba_assessment
WHERE start_date_id = DATEADD(DAY,-1,CURRENT_DATE)
and subject = 'math';

-- ism test starts - ela
SELECT COUNT(DISTINCT assignment_id) AS ism_tests_started
FROM prod_skynet.fact_student_sba_assessment
WHERE start_date_id = DATEADD(DAY,-1,CURRENT_DATE)
and subject = 'ela';

-- ism test completion - math
SELECT COUNT(assignment_id) AS ism_tests_completed
FROM fact_student_sba_assessment
WHERE score_type = 'OVERALL'
AND   status = 'COMPLETED'
AND   completion_date_id = DATEADD(DAY,-29,CURRENT_DATE)
and subject = 'math';


-- ism test completion - ela
SELECT COUNT(assignment_id) AS ism_tests_completed
FROM fact_student_sba_assessment
WHERE score_type = 'OVERALL'
AND   status = 'COMPLETED'
AND   completion_date_id = DATEADD(DAY,-1,CURRENT_DATE)
and subject = 'ela';


-- unique students that have taken an iSM since the beginning of the year
select f.subject, count(distinct f.student_id)
from fact_student_sba_assessment f
join dim_student s on s.id = f.student_academic_year_id
join dim_account a on a.id = s.account_id and a.current_academic_year = s.academic_year
where f.start_date_id between '2015-07-01' and DATEADD(DAY,-1,CURRENT_DATE)
and f.status <> 'NOT_STARTED'
and a.account_type not in (8,9,10,11)
group by f.subject
order by f.subject;

-- hour with most students starting an iSM
SELECT COUNT(DISTINCT student_academic_year_id) AS user_count,
       dim_time.hour_of_day AS busiest_hour
FROM fact_student_sba_assessment
  JOIN dim_time ON (dim_time.id = fact_student_sba_assessment.last_start_time_id)
WHERE last_start_date_id = DATEADD(DAY,-1,CURRENT_DATE)
GROUP BY dim_time.hour_of_day
ORDER BY num_students DESC;



-- LESSON ACTIVITY QUERIES


-- lesson starts ela
select count(distinct student_id) as num_students
from fact_student_instruction
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -726, CURRENT_DATE))
and subject='ela';

-- lesson completions ela
select count(distinct student_id) as num_students
from fact_student_instruction
where date_trunc('day', completion_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and subject='ela';

-- lesson starts math
select count(distinct student_id) as num_students
from fact_student_instruction
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and subject='math';

-- lesson completions math
select count(distinct student_id) as num_students
from fact_student_instruction
where date_trunc('day', completion_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and subject='math';

-- lesson starts by hour ela
select count(distinct student_id) as num_students, to_char(last_start_time, 'HH24:00') as hour
from fact_student_instruction
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and subject='ela'
group by hour
order by num_students desc;

-- lesson starts by hour math
select count(distinct student_id) as num_students, to_char(last_start_time, 'HH24:00') as hour
from fact_student_instruction
where date_trunc('day', last_start_time) = date_trunc('day', DATEADD (day, -19, CURRENT_DATE))
and subject='math'
group by hour
order by num_students desc;


