 -- SQL Query, Lab 2:
 -- Author: Chemerisov Oleg


/*
        1:  ������� ��������, � ������� ���� ������ � ���� 1999 ����. ����������� �� ����
            �������. ������������ ���������� ���������� (inner join) � distinct.
*/


select  distinct
        c.*
  from  customers c
        join orders o on
          o.customer_id = c.customer_id
        where date'1999-07-01' <= o.order_date and o.order_date < date'1999-08-01'
  order by c.customer_id
;


/*
        2:  ������� ���� �������� � ����� �� ������� �� 2000 ���, ���������� �� �� ����� �������
            (�������, � ������� ������ �� ���� ������� �� 2000 ���, ������� � �����), ����� �� ID
            ���������. ������� ����: ��� ���������, ��� ��������� (������� + ��� ����� ������),
            ����� ������� �� 2000 ���. ������������ ������� ���������� (left join) �������
            ���������� � ����������� ��� ������ ����� ������� (�� ������� �������) �� ��������
            �� 2000 ��� (��������� � ������������).
*/


select  c.customer_id,
        c.cust_last_name || ' ' || c.cust_first_name as cust_name,
        ord_sum.order_total
  from  customers c
        left join (
          select  o.customer_id,
                  sum(o.order_total) as order_total
            from  orders o
            where date'2000-01-01' <= o.order_date and o.order_date < date'2001-01-01'
            group by  o.customer_id
         ) ord_sum on
          ord_sum.customer_id = c.customer_id
  order by  ord_sum.order_total desc nulls last,
            c.customer_id        
;


/*
        3:  ������� �����������, ������� �������� �� ������ ����� ��������� (��� ������� �
            �������). ������������ ������� ���������� (����� ���������?) � �������� �������, �
            ����� ����� ������� �� ������� ����������� �����, ��� ������� �� �������������
            ����� �� ������� �������. ����������� ���������� ����������� �� ���� ������ ��
            ������ (� �������� �������, ����� �� ���� ���������� (� ������� �������).
*/


select  e.*
  from  employees e
        left join  job_history j on 
          e.employee_id = j.employee_id
  where j.employee_id is null
  order by  e.hire_date desc,
            e.employee_id
;


/*
        4:  ������� ��� ������, ���������� �� �� ���������� ������������ �������,
            �������������� � ���. ������� ����: ��� ������, �������� ������, ����������
            ��������� ������� �� ������. ����������� �� ���������� ������������ ������� ��
            ������ (�� �������� ���������� � ��������), ����� �� ���� ������ (� �������
            �������). ������, ��� ������� ��� ���������� � ������� �� ������, ������� � �����.
            ���������� �� ������������.
*/


select  w.warehouse_id,
        w.warehouse_name,
        count(distinct i.product_id) as product_count
  from  warehouses w
        left join
          inventories i on
            w.warehouse_id = i.warehouse_id
  group by  w.warehouse_id,
            w.warehouse_name
  order by  product_count desc,
            w.warehouse_id
;


/*
        5:  ������� �����������, ������� �������� � ���. ����������� �� ���� ����������.
*/


select  e.*
  from  employees e
          inner join  departments d on
            d.department_id = e.department_id
          inner join locations l on
            l.location_id = d.location_id and
            l.country_id = 'US'
  order by  e.employee_id            
;


/*
        6:  ������� ��� ������ � �� �������� �� ������� �����. ������� ����: ��� ������,
            �������� ������, ���� ������ � �������� (LIST_PRICE), �������� ������ �� �������
            �����. ���� �������� ������ �� ������� ����� ���, � ���� �������� ������� ����
            ���������, ���������������� �������� nvl ��� ���������� case (� ������� ����
            ������ ��� ���� ������� ���� �������� �� ������� �����, ������ ������ ������ ����
            ������� � �������������, ��� �������� �� ������� ����� ����� � �� ����; ���
            �������� ������� ����� ������� ��� ��������������� ����� � ���������, ��������� ��
            � ���� �������� ��������������� �����������). ����������� �� ���� ���������
            ������, ����� �� ���� ������.
*/


select  pi.product_id,
        pi.product_name,
        pi.list_price,
        nvl(pd.translated_description, '��� ��������') as ru_description
  from  product_information pi
          left join product_descriptions pd on
            pi.product_id = pd.product_id and
            pd.language_id = 'RU'
  order by  pi.category_id,
            pi.product_id
;


/*
        7:  ������� ������, ������� ������� �� �����������. ������� ����: ��� ������, ��������
            ������, ���� ������ � �������� (LIST_PRICE), �������� ������ �� ������� ����� (������
            ������ ���� ������� � �������������, ��� �������� ������ �� ������� ����� ����� �
            �� ����). ����������� �� ���� ������ � �������� ������� (������, ��� ������� ��
            ������� ����, ������� � �����), ����� �� ���� ������.
*/



select  pi.product_id,
        pi.product_name,
        pi.list_price,
        nvl(pd.translated_description, '��� ��������') as ru_description
  from  product_information pi
          left join product_descriptions pd on
            pi.product_id = pd.product_id and
            pd.language_id = 'RU'
          left join order_items oi on
            pi.product_id = oi.product_id
  where oi.product_id is null
  order by  pi.list_price desc nulls last,
            pi.product_id
;


        



















