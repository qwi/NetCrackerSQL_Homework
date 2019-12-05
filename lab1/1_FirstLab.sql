 -- SQL Query, Lab 1:
 -- Author: Chemerisov Oleg

/*
    1:  �������� ������, ��������� ��� ���������� � �������������. ����������� �� ���� ������������.
*/
  

select  d.*
  from  departments d
  order by  d.department_id
;
	

/*
    2:  �������� ������, ���������� ID, ��� + ������� ( � ���� ������ ������� ����� ������) � ����� ����������� ����� ���� ��������
       (������������ ������������ ����� � �������������� ������� � ������ � �������� �� "Name"). ����������� �� ���� �������.
*/
   
   
select   c.customer_id,
         c.cust_first_name || ' ' || c.cust_last_name as name,
         c.cust_email
  from   customers c
  order by  c.customer_id
;


/*
    3:  �������� ������, ��������� �����������, �������� ������� �� ��� ����� � ��������� �� 100 �� 200 ���. ���.,
        ���������� �� �� ���������� ���������, ��������( �� ������� � �������) � �������. ��������� ������ ������
        �������� ���, ���������(��� ���������), email, �������, �������� �� ����� �� ������� �������. ����� �������
        ��� � ��� ������������� ����� ���������������: � �������� �� ��� �� 100 �� 150 ���. ���. ����� ���������� 30%,
        ���� - 35%. ��������� ��������� �� ������ ���.
*/
  
  
select  e.last_name, 
        e.first_name,
        e.job_id,
        e.email,
        e.phone_number,
        case
          when e.salary * 12 between 100000 and 150000 then
            e.salary * 0.3
          when e.salary * 12 > 150000 then
            e.salary * 0.35
        end salary
  from  employees e
  where e.salary * 12 between 100000 and 200000
  order by  e.job_id,
            e.salary desc,
            e.last_name
;

       
/*
    4:  ������� ������ � ���������������� DE, IT ��� RU. 
        ������������� ������� �� "��� ������", "�������� ������".
        ����������� �� �������� ������.
*/


select  c.country_id as "��� ������",
        c.country_name as "�������� ������"
  from  countries c
  where  c.country_id in ('DE', 'IT', 'RU')
  order  by  c.country_name
;

/*
    5:  ������� ��� +������� �����������, � ������� � ������� ������ ����� "�"(���������),
        � � ����� ������������ ����� "d"( �� �����, � ����� ��������).
        ����������� �� �����. ������������ �������� like � ������� ���������� � ������� ��������.
*/
     
     
select  e.first_name || ' ' || e.last_name as Name
  from  employees e
  where lower(e.last_name) like '_a%' and lower(e.first_name) like '%d%'
  order by  e.first_name
;


/*
    6:  ������� ����������� � ������� ������� ��� ��� ������ 5 ��������.
        ����������� ������ �� ��������� ����� ������� � �����, ����� �� ����� �������,
        ����� ������ �� �������, ����� ������ �� �����. 
*/
     
     
select  e.*
  from  employees e
  where (
          length(e.last_name) < 5 or
          length(e.first_name) < 5
        )
  order by  length(e.last_name || e.first_name),
            length(e.last_name),
            e.last_name,
            e.first_name
;


/* 
    7:  ������� ��������� � ������� �� "����������" (������� ��������, �� ������� �����
        �������-�������������� ����������� � ������������ �������). ����� "��������"
        ��������� ������ ���� �������, � ������ ���������� �������� ����������� �� ����
        ���������. ������� ������� ��� ���������, �������� ���������, ������� ��������
        ����� �������, ����������� �� �����. ������� ����� ��������������� ������� - 18%
*/


select  j.job_id,
        j.job_title,
        round (((j.min_salary + j.max_salary) / 2) - (((j.min_salary + j.max_salary) / 2) * 0.18), -2) as avg_salary 
  from  jobs j
  order by  avg_salary desc,
            j.job_id
;


/*
    8:  ����� �������, ��� ��� ������� ������� �� ��������� A,B,C. ���������
          � - ��������� ����� >= 3500
          B - ��������� ����� >= 1000
          C - ��� ���������.
        ������� ���� ��������, ���������� �� �� ��������� � �������� �������
        (������� ������� ��������� �), ����� �� �������. 
        ������� ������� �������, ���, ���������, �����������. 
        � ����������� ��� �������� � ������ ���� ������ "�������� VIP-�������",
        ��� ��������� �������� ����������� ������ �������� ������ (NULL).
*/


select  c.cust_last_name,
        c.cust_first_name,
        case
          when  (c.credit_limit >= 3500) then
            'A'
          when  (c.credit_limit >= 1000) then
            'B'
          else
            'C'
        end category,
        case
          when (c.credit_limit >= 3500) then
            '��������, VIP-�������'
        end comments       
  from  customers c
  order by  category,
            c.cust_last_name,
            c.cust_first_name         
;


/*
    9:  ������� ������ (�� �������� �� �������), � ������� ���� ������ � 1998 ����.
        ������ �� ������ ����������� � ������ ���� �����������. ������������ 
        ����������� �� ������� extract �� ���� ��� ���������� ������������ �������
        � decode ��� ������ ������ �� ��� ������. ���������� �� ������������.
*/


select  decode(
          extract(month from order_date), 
            1, '������',
            2, '�������',
            3, '����',
            4, '������',
            5, '���',
            6, '����',
            7, '����',
            8, '������',
            9, '��������',
            10, '�������',
            11, '������',
            12, '�������'
        ) as month
  from   orders o
  where  date'1998-01-01'<=o.order_date and o.order_date<date'1999-01-01' and
         o.order_status >= 1
  group by  extract(month from o.order_date)
  order by  extract(month from o.order_date)
;


/*
    10:  �������� ���������� ������, ��������� ��� ��������� �������� ������ 
         ������� to_char(������� ��� ������� nls_date_language 3-� ����������.
         ������ ����������� ������������ �������� distinct, ���������� �� ������������.
*/


select  distinct
        to_char(o.order_date, 'Month', 'nls_date_language = russian') as month
  from  orders o
  where  o.order_status >= 1 and
         (o.order_date >= date'1998-01-01' and o.order_date<date'1999-01-01') 
  order by  to_date(month, 'Month', 'nls_date_language = russian')
;



/*
    11:  �������� ������, ��������� ��� ���� �������� ������. ������� ����� ������ �������
         �� sysdate. ������ ������� ������ ��������� ����������� � ���� ������ "��������" ���
         ������ � �����������. ��� ����������� ��� ������ ��������������� �������� to_char.
         ��� ������ ����� �� 1 �� 31 ����� ��������������� �������������� rownum, �������
         ������ �� ����� �������, ��� ���-�� ����� ����� 30.
*/


select  trunc(sysdate, 'mm') + rownum -1 as dt,
        case
          when trim(to_char(trunc(sysdate, 'mm') + rownum -1, 'DY', 'nls_date_language=english')) in ('SAT', 'SUN') then
            '��������'
        end comments
  from  dual
  connect by  trunc(sysdate, 'mm') + rownum -1 < add_months(trunc(sysdate, 'mm'), 1)
;


/*
    12:  ������� ���� ����������� (��� ����������, �������+��� ����� ������, ��� ���������,
         ��������, �������� - %), ������� �������� �������� �� �������. ���������������
         ������������ is not null.����������� ����������� �� �������� �������� (�� �������� �
         ��������), ����� �� ���� ����������.
*/


select  e.employee_id,
        e.last_name || ' ' || e.first_name as emp_name,
        e.job_id,
        e.salary,
        e.commission_pct
  from  employees e
  where   e.commission_pct is not null
  order by  e.commission_pct desc,
            e.job_id
;



/*
    13:  �������� ���������� �� ����� ������ �� 1995-2000 ���� � ������� ��������� (1 �������
         ������-���� � �.�.). � ������� ������ ���� 6 �������� � ���, ����� ������ �� 1-��, 2-
         ��, 3-�� � 4-�� ��������, � ����� ����� ����� ������ �� ���. ����������� �� ����.
         ��������������� ������������ �� ����, � ����� ������������� �� ��������� � case
         ��� decode, ������� ����� �������� ������� �� ������ �������.
*/     
     
     
select    to_char(o.order_date, 'yyyy') as year,
          sum(case
            when extract(month from o.order_date) between 1 and 3 then o.order_total
          end) quart1_sum,
          sum(case
            when extract(month from o.order_date) between 4 and 6 then o.order_total
          end) quart2_sum,
          sum(case
            when extract(month from o.order_date) between 6 and 9 then o.order_total
          end) quart3_sum,
          sum(case
             when extract(month from o.order_date) between 10 and 12 then o.order_total
          end) quart4_sum,    
          sum(o.order_total) as year_sum
  from    orders o
  where   date'1995-01-01'<=o.order_date and o.order_date<date'2000-01-01'
  group by  to_char(o.order_date, 'yyyy')
  order by  year
;
  

/*
    14:  ������� �� ������� ������� ��� ����������� ������. ������� ������� ����� �����
         ��� �������� � �������� ������ ������ � MB ��� GB (� ����� ��������), ��������
         ������ �� ���������� � HD, � ����� � ������ 30 �������� �������� ������ ��
         ����������� ����� disk, drive � hard. ������� �������: ��� ������, �������� ������,
         ��������, ���� (�� ������ � LIST_PRICE), url � ��������. � ���� �������� ������ ����
         �������� ����� ����� � ���������� ������� �������� (������, ��� �������� ����� ����
         ��� � �����). ����������� �� ������� ������ (�� �������� � ��������), ����� �� ����
         (�� ������� � �������). ������ ��� �������������� ������� �� �������� ������ ��
         ������� NN MB/GB (�� ������ ��� ���� ��������������� GB � ���������) c �������
         regexp_replace. Like �� ������������, ������ ���� ������������ regexp_like � �����
         ���������, ��� ������� ���� ������� ������������. 
*/


select    pi.product_id,
          pi.product_name,
          extract(month from pi.warranty_period) + 
            (extract(year from pi.warranty_period) * 12) as warranty_month,
          pi.list_price,
          pi.catalog_url
  from    product_information pi
  where   regexp_like(pi.product_name, '(\d+)\s?(mb|gb)(\s|$)', 'i') and
          not regexp_like(pi.product_name, '^hd', 'i') and
          not regexp_like(substr(pi.product_description, 1, 30), 'disk|drive|hard', 'i')
  order by  case regexp_substr(pi.product_name, '(\d+)\s?(mb|gb)(\s|$)', 1, 1, 'i', 2)
              when 'GB' then  
                to_number(regexp_substr(pi.product_name, '(\d+)\s?(mb|gb)(\s|$)', 1, 1, 'i', 1)) * 1024
              when 'MB' then
                to_number(regexp_substr(pi.product_name, '(\d+)\s?(mb|gb)(\s|$)', 1, 1, 'i', 1))
            end desc,
            pi.list_price
;
          

/*
    15:  ������� ����� ���������� �����, ���������� �� ��������� �������. ����� ���������
         ������� � ������� ������ ���� ������ � ���� ������, �������� �21:30�. ������ ��������
         ������� ���� � ������� ���� �� ������. ����� ��������������� ����������� �������
         to_char/to_date
*/

  
select  trunc((to_date(to_char(sysdate, 'dd.mm.yyyy') || '21:30', 'dd.mm.yyyy hh24:mi') - sysdate)* 24*60) as minutes
  from  dual
;