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


/*
        8:  ������� ��������, � ������� ���� ������ �� ����� ������, ��� � 2 ���� �����������
            ������� ���� ������. ������� ����: ��� �������, �������� ������� (������� + ���
            ����� ������), ���������� ����� �������, ������������ ����� ������. ����������� ��
            ���������� ����� ������� � �������� �������, ����� �� ���� �������.          
*/



select  c.customer_id,
        c.cust_last_name || ' ' || c.cust_first_name as cust_name,
        count(o.order_id) as large_sum_orders_count,
        max(o.order_total) as max_order_sum
  from  customers c
        join orders o on
          o.customer_id = c.customer_id
  where o.order_total > 2 * (
          select  avg(order_total)
            from  orders
        ) 
  group by  c.customer_id,
            c.cust_last_name,
            c.cust_first_name
  order by  large_sum_orders_count desc,
            c.customer_id
;
        


/*
        9:  ����������� �������� �� ����� ������� �� 2000 ���. ������� ����: ��� �������, ���
            ������� (������� + ��� ����� ������), ����� ������� �� 2000 ���. ����������� ������
            �� ����� ������� �� 2000 ��� � �������� �������, ����� �� ���� �������. �������, �
            ������� �� ���� ������� � 2000, ������� � �����.
*/



select  c.customer_id,
        c.cust_last_name || ' ' || c.cust_first_name as cust_name,
        o.order_total
  from  customers c
        left join (
          select  o.customer_id,
                  sum(o.order_total) as order_total
            from  orders o
            where date'2000-01-01' <= o.order_date and o.order_date < date'2001-01-01'
            group by  o.customer_id
        ) o on
          o.customer_id = c.customer_id
  order by  o.order_total desc nulls last,
            c.customer_id
;



/*
        10:  ���������� ���������� ������ ���, ����� �� �������� ��������, � ������� ������ ��
             ���� �������
*/



select  c.customer_id,
        c.cust_last_name || ' ' || c.cust_first_name as cust_name,
        o.order_total
  from  customers c
        join (
          select  o.customer_id,
                  sum(o.order_total) as order_total
            from  orders o
            where date'2000-01-01' <= o.order_date and o.order_date < date'2001-01-01'
            group by  o.customer_id
        ) o on
          o.customer_id = c.customer_id
  order by  o.order_total desc nulls last,
            c.customer_id
;



/*
        11: ������� ��������� �� �������� ����������� ��������� ��� �����. ��������� ��
            �������� ������� �����������, ��� ��������� �������: �SA_MAN� � �SA_REP�.
            ������� ����: ��� ���������, ��� ��������� (������� + ��� ����� ������), ���
            �������, ��� ������� (������� + ��� ����� ������), ���� ������, ����� ������,
            ���������� ��������� ������� � ������. ����������� ������ �� ���� ������ � ��������
            �������, ����� �� ����� ������ � �������� �������, ����� �� ���� ����������. ���
            ����������, � ������� ��� �������, ������� � �����.
*/



select  e.employee_id,
        e.last_name || ' ' || e.first_name as manager_name,
        c.customer_id,
        c.cust_last_name || ' ' || c.cust_first_name as cust_name,
        last_order.order_date,
        o.order_total,
        oi.lines
  from  employees e
        left join (
          select  max(o.order_date) as order_date,
                  o.sales_rep_id
            from  orders o 
            group by  o.sales_rep_id
        ) last_order on 
          last_order.sales_rep_id = e.employee_id
        left join orders o on
          o.sales_rep_id = last_order.sales_rep_id and
          o.order_date = last_order.order_date
        left join customers c on
          c.customer_id = o.customer_id
        left join (
          select  count(oi.line_item_id) as lines,
                  oi.order_id
            from  order_items oi
            group by  oi.order_id
        ) oi on
          oi.order_id = o.order_id
  where e.job_id in ('SA_MAN', 'SA_REP')
  order by  o.order_date desc nulls last,
            o.order_total desc nulls last,
            e.employee_id 
;



/*
        12: ���������, ���� �� ������, � ������� ������ ������������ �� �������. �������, ���
            ������ ����, ���� ����� ������ ������ ����� ��������� ���� ������� � ������, ����
            ���� ������� �������� � �������� (������). ���� ����� ������ ����, �� �������
            ������������ ������� ������ ����� ���� ����� �������, ����������� �� 2 ������ �����
            �������.
*/



select  max(
          round(
            (oi.real_price - o.order_total) / oi.real_price * 100,
            2
          )
        ) as max_discount_percent
  from  orders o
        join (
          select  sum(p.list_price * oi.quantity) as real_price, 
                  oi.order_id
            from  order_items oi
                  join product_information p on
                    p.product_id = oi.product_id
            group by  oi.order_id
        ) oi on
          oi.order_id = o.order_id
;



/*
        13:  ������� ������, ������� ���� ������ �� ����� ������. ������� ����: ��� ������,
             �������� ������, ���� ������ �� �������� (LIST_PRICE), ��� � �������� ������, ��
             ������� ���� ������ �����, ������, � ������� ��������� ������ �����. �����������
             ������ �� �������� ������, ����� �� ���� ������, ����� �� �������� ������.
*/



select  pi.product_id,
        pi.product_name,
        pi.list_price,
        w.warehouse_id,
        w.warehouse_name,
        con.country_name
  from  product_information pi
        join (
          select  inv.product_id,
                  count(inv.warehouse_id) as warehouse_count,
                  min(inv.warehouse_id) as warehouse_id
            from  inventories inv
            group by inv.product_id
        ) one_products on
          one_products.product_id = pi.product_id and
          one_products.warehouse_count = 1
        join warehouses w on
          w.warehouse_id = one_products.warehouse_id
        join locations l on
          l.location_id = w.location_id
        join countries con on 
          con.country_id = l.country_id
  order by  con.country_name,
            w.warehouse_id,
            pi.product_name
;



/*
        14:  ��� ���� ����� ������� ���������� ��������, ������� ��������� � ������ ������.
             ������� ����: ��� ������, �������� ������, ���������� ��������. ��� �����, � �������
             ��� ��������, � �������� ���������� �������� ������� 0. ����������� �� ����������
             �������� � �������� �������, ����� �� �������� ������.
*/



select  con.country_id,
        con.country_name,
        nvl(cus.customers_count, 0) as customers_count
  from  countries con
        left join (
          select  cus.cust_address_country_id,
                  count(cus.customer_id) as customers_count
            from  customers cus
            group by  cus.cust_address_country_id
        ) cus on
          cus.cust_address_country_id = con.country_id
  order by  customers_count desc,
            con.country_name
;



/*
        15:  ��� ������� ������� ������� ����������� �������� (���������� ����) ����� ���
             ��������. �������� ����� �������� ������� ��� ������� � ���� ����� ������ 2-�
             ������� ��� ����� ������� ������. ������� ����: ��� �������, ��� �������
             (������� + ��� ����� ������), ���� ������� � ����������� ���������� (����� ��
             �����������), �������� � ���� ����� ����� ��������. ���� � ������� ������� ��� ���
             ����� ���� �� ��� �������, �� ����� �������� �� ��������. ����������� �� ����
             �������.
*/



select  c.customer_id,
        c.cust_last_name || ' ' || c.cust_first_name as cust_name,
        o.order_date1,
        o.order_date2,
        o.min_orders_inerval
  from  customers c
        join (
          select  trunc(o2.order_date) - trunc(o1.order_date) as min_orders_inerval,
                  o1.order_date as order_date1,
                  o2.order_date as order_date2,
                  o1.customer_id
            from  orders o1
                  join orders o2 on
                    o2.customer_id = o1.customer_id and 
                    o2.order_date > o1.order_date
                  join (
                    select  o4.customer_id,
                            min(o4.order_date - o3.order_date) min_date
                      from  orders o3
                            join orders o4 on
                              o4.customer_id = o3.customer_id and 
                              o4.order_date > o3.order_date
                      group by o4.customer_id
                  ) interval_order on 
                    interval_order.customer_id = o2.customer_id and
                    min_date = o2.order_date - o1.order_date
        ) o on
          o.customer_id = c.customer_id
  order by  c.customer_id
;