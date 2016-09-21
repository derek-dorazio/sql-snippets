SET search_path TO prod_skynet;

-- this is run each month to get the student list used by finance to determine billing for Learnosity
Select f.subject, f.student_id, count(distinct f.assignment_id) as count_of_tests
from fact_student_sba_assessment f
join dim_student s on s.id = f.student_academic_year_id
join dim_account a on a.id = s.account_id
where f.start_date_id between to_date('2015-07-01', 'YYYY-MM-DD') and to_date('2016-06-30', 'YYYY-MM-DD')
and f.status <> 'NOT_STARTED'
and a.account_type not in (8,9,10,11)
Group by f.student_id, f.subject
Order by f.student_id, f.subject;


-- this is run each month and used by finance to determine billing for Learnosity
select f.subject, count(distinct f.student_id)
from fact_student_sba_assessment f
join dim_student s on s.id = f.student_academic_year_id
join dim_account a on a.id = s.account_id
where f.start_date_id between to_date('2016-07-01', 'YYYY-MM-DD') and to_date('2016-07-26', 'YYYY-MM-DD')
and f.status <> 'NOT_STARTED'
and a.account_type not in (8,9,10,11)
group by f.subject
order by f.subject;



Select min(start_date_id)
From fact_student_sba_assessment f;


-- iSM Test Starts from yesterday 
Select count (f.id)
From fact_student_sba_assessment f
Where f.last_start_date_id = current_date - 1;

-- iSM Test Starts from yesterday 
Select count (f.id)
From fact_student_sba_assessment f
Where f.completion_date_id = current_date - 1
and status = 'COMPLETED'
and score_type='OVERALL';


Select *
From fact_student_sba_assessment f where status <> 'COMPLETED';



