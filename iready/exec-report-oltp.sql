-- total number of user logins
select count(*) as num_logins
from irp_user_usage_data
where date(last_login_time) = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d');

-- total number of student logins
select count(*) as student_num_logins from irp_user_usage_data uud
inner join irp_user u on u.id = uud.user_id
inner join irp_student s on u.id = s.id
where date(last_login_time) = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d');

-- total number of staff members (teachers and admins) logins
select count(*) as staff_num_logins from irp_user_usage_data uud
inner join irp_user u on u.id = uud.user_id
inner join irp_staff_member s on u.id = s.id
where date(last_login_time) = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d');


-- number of students active during busiest hour
select count(distinct student_id) as num_students, date_format(last_start_time,'%H:00') as busiest_hour
from irp_activity
where date_format(last_start_time,'%y-%m-%d') = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')
group by date_format(last_start_time,'%H:00')
order by num_students desc limit 1;

-- busiest test hour with student count (PM and Diag)
select count(distinct student_id) as num_di_students, date_format(last_start_time,'%H:00') as busiest_test_hour
from irp_activity
where
date_format(last_start_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')
and activity_type regexp 'test'
group by date_format(last_start_time,'%H:00') order by count(distinct student_id) desc limit 1;

-- busiest lesson hour with student count
select count(distinct student_id) as num_di_students, date_format(last_start_time,'%H:00') as busiest_lesson_hour from
irp_activity where
date_format(last_start_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')
and activity_type NOT regexp 'test'
group by date_format(last_start_time,'%H:00') order by count(distinct student_id) desc limit 1;

-- num tests started
select count(*) as num_tests_started from
irp_activity where date_format(start_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')  and activity_type regexp 'test' and activity_type NOT REGEXP 'PM';

-- num tests completed
select count(*) as num_tests_completed from
irp_activity where date_format(completion_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')  and activity_type regexp 'test' and activity_type NOT REGEXP 'PM';

-- num progress monitoring assessments started
select count(*) as num_progress_monitor_started from
irp_activity where date_format(start_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')  and  activity_type REGEXP 'PM';

-- num progress monitoring assessments completed
select count(*) as num_progress_monitor_completed from
irp_activity where date_format(completion_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')  and activity_type REGEXP 'PM';

-- num lessons completed
select count(*) as num_lessons_completed from
irp_activity where date_format(completion_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')  and activity_type NOT regexp 'test';

-- num lessons started
select count(*) as num_lessons_started from
irp_activity where date_format(start_time,'%y-%m-%d')  = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')  and activity_type NOT regexp 'test';

-- number of users (not try-it) that have logged in since 8-15-2014
-- select count(*) as num_active_users from irp_user u
-- inner join irp_user_usage_data uud on u.id = uud.user_id
-- inner join ca_onboard o on o.onboard_id = u.current_onboard_id
-- where o.account_type != 11 and last_login_time > '2015-08-15';

-- number of students (not try-it)that have logged in since 8-15-2014
select count(distinct(s.id)) as num_active_students from irp_student s
inner join irp_user u on u.id = s.id
inner join irp_user_usage_data uud on u.id = uud.user_id
inner join ca_onboard o on o.onboard_id = u.current_onboard_id
where o.account_type != 11 and last_login_time > '2015-08-15' ;

-- number of non-tryit staff members (teachers and admins) that have logged in since 8-15-2014
select count(distinct(s.id)) as num_active_staffs from irp_staff_member s
inner join irp_user u on u.id = s.id
inner join irp_user_usage_data uud on u.id = uud.user_id
inner join ca_onboard o on o.onboard_id = u.current_onboard_id
where o.account_type != 11 and last_login_time > '2015-08-15';

-- number of new users (not try-it) created yesterday
select count(*) as num_added_yesterday from irp_user u
inner join ca_onboard o on o.onboard_id = u.current_onboard_id
where o.account_type != 11 and date_format(created_on,'%y-%m-%d') = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d');

-- total students enrolled in classes for current academic year (not try-it)
select count(distinct(s.id)) as totalStudentsEnrolled
from irp_student s
inner join irp_user u on u.id = s.id
inner join ca_onboard ob on ob.onboard_id = u.current_onboard_id
inner join irp_student_group_student_enrollment enr on enr.student_id = s.id
inner join irp_student_group sg on enr.student_group_id = sg.id
inner join irp_academic_year_for_onboard ay on ay.onboard_academic_year_id = sg.onboard_academic_year_id
where ob.account_type != 11 and sg.type = 'CLASS' and ay.is_current = 1;

-- total staff members (teachers and admins) enrolled in classes for current academic year (not try-it)
select count(distinct(sm.id)) as totalStaffEnrolled
from irp_staff_member sm
inner join irp_user u on u.id = sm.id
inner join ca_onboard ob on ob.onboard_id = u.current_onboard_id
inner join irp_student_group_staff_member_enrollment enr on enr.staff_member_id = sm.id
inner join irp_student_group sg on enr.student_group_id = sg.id
inner join irp_academic_year_for_onboard ay on ay.onboard_academic_year_id = sg.onboard_academic_year_id
where ob.account_type != 11 and sg.type = 'CLASS' and ay.is_current = 1;

-- number of user logins yesterday for 5 busiest districts
select count(*) as number_logins, concat(a.learning_agency_name, ', ' , a.state_province_code) as five_busiest_district_and_state
from irp_user u
inner join irp_user_usage_data uud on u.id = uud.user_id
inner join lyc_learning_agency a on a.learning_agency_id = u.district_id
where
date(uud.last_login_time) = date_format(date_add(now(), INTERVAL -1 DAY),'%y-%m-%d')
group by district_id order by count(*) desc limit 20;