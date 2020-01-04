 -- SQL Query, Lab 2:
 -- Author: Chemerisov Oleg


/*
        1:  ������� ��������, � ������� ���� ������ � ���� 1999 ����. ����������� �� ����
            �������. ������������ ���������� ���������� (inner join) � distinct.
*/



select  distinct c.*
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
        os.order_total
  from  customers c
        left join (
          select  o.customer_id,
                  sum(order_total) as order_total
            from  orders o
            where date'2000-01-01'<= o.order_date and o.order_date< date'2001-01-01'
            group by  o.customer_id
        ) os on
          os.customer_id = c.customer_id
  order by  os.order_total desc nulls last,
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
        left join job_history jh on
          jh.employee_id = e.employee_id
  where  jh.employee_id is null
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
        count(distinct i.product_id) as count
  from  warehouses w
        left join inventories i on
          i.warehouse_id = w.warehouse_id
  group by  w.warehouse_id, 
            w.warehouse_name
  order by  count desc,
            w.warehouse_id
;



/*
        5:  ������� �����������, ������� �������� � ���. ����������� �� ���� ����������.
*/



select  e.*
  from  employees e
        join departments d on
          d.department_id = e.department_id
        join locations l on 
          l.location_id = d.location_id 
          where l.country_id in('US')
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
        nvl(pd.translated_description, '��� ��������') as description
  from  product_information pi
        left join product_descriptions pd on
          pd.product_id = pi.product_id and 
          pd.language_id = 'RU'
          -- where pd.language_id in('RU')
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
        nvl(pd.translated_description, '��� ��������') as description
  from  product_information pi
        left join product_descriptions pd on
          pd.product_id = pi.product_id and 
          pd.language_id = 'RU8'
          -- where pd.language_id in('RU')
        left join order_items oi on
          oi.product_id = pi.product_id 
   where  oi.product_id is null       
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
        count(o.order_id) as orders_count,
        max(o.order_total) as order_sum
  from  customers c
        left join orders o on
          o.customer_id = c.customer_id 
  where o.order_total > (
          select avg(order_total) 
            from  orders
        ) * 2          
  group by  c.customer_id, 
            c.cust_last_name,
            c.cust_first_name
  order by  orders_count desc nulls last,
            c.customer_id
;



/*
        9:  ����������� �������� �� ����� ������� �� 2000 ���. ������� ����: ��� �������, ���
            ������� (������� + ��� ����� ������), ����� ������� �� 2000 ���. ����������� ������
            �� ����� ������� �� 2000 ��� � �������� �������, ����� �� ���� �������. �������, �
            ������� �� ���� ������� � 2000, ������� � �����.
*/



select  c.customer_id,
        c.cust_last_name || ' ' || cust_first_name as cust_name,
        o.order_total
  from  customers c
        left join (
          select  o.customer_id,
                  sum(o.order_total) as order_total
            from  orders o
            where  date'2000-01-01' <= o.order_date and o.order_date < date'2001-01-01'
            group by  o.customer_id
        ) o on
          o.customer_id = c.customer_id
  order by  o.order_total desc nulls last,
            c.customer_id
;

         -- date'2000-01-01' <= o.order_date and o.order_date < date'2001-01-01'

/*
        10:  ���������� ���������� ������ ���, ����� �� �������� ��������, � ������� ������ ��
             ���� �������
*/



select  c.customer_id,
        c.cust_last_name || ' ' || cust_first_name as cust_name,
        sum(o.order_total) as orders_sum
  from  customers c
        join orders o on
          o.customer_id = c.customer_id and
          date'2000-01-01' <= o.order_date and o.order_date < date'2001-01-01'
  group by  c.customer_id,
            c.cust_last_name || ' ' || cust_first_name
  order by  orders_sum desc nulls last,
            c.customer_id
;



/*
        11:  ������� ��������� �� �������� ����������� ��������� ��� �����. ��������� ��
             �������� ������� �����������, ��� ��������� �������: �SA_MAN� � �SA_REP�.
             ������� ����: ��� ���������, ��� ��������� (������� + ��� ����� ������), ���
             �������, ��� ������� (������� + ��� ����� ������), ���� ������, ����� ������,
             ���������� ��������� ������� � ������. ����������� ������ �� ���� ������ � ��������
             �������, ����� �� ����� ������ � �������� �������, ����� �� ���� ����������. ���
             ����������, � ������� ��� �������, ������� � �����.
*/



select  e.employee_id,
        e.last_name || ' ' || e.first_name as emp_name,
        c.customer_id,
        c.cust_last_name || ' ' || c.cust_first_name as cust_name,
        recent_order.max_o_date,
        o.order_total,
        oi.count_items
  from  employees e
        left join (
          select  max(o.order_date) as max_o_date,
                  o.sales_rep_id
            from  orders o
            group by  o.sales_rep_id
        ) recent_order on
          recent_order.sales_rep_id = e.employee_id
        left join orders o on
          o.sales_rep_id = recent_order.sales_rep_id and
          o.order_date = recent_order.max_o_date
        left join customers c on
          c.customer_id = o.customer_id  
        left join (
          select  count(oi.line_item_id) as count_items,
                  oi.order_id
            from  order_items oi
            group by  oi.order_id
        ) oi on
          oi.order_id = o.order_id
  where  e.job_id in ('SA_MAN', 'SA_REP')
  order by  o.order_date desc nulls last,
            o.order_total desc nulls last,
            e.employee_id    
;



/*
        12:  ���������, ���� �� ������, � ������� ������ ������������ �� �������. �������, ���
             ������ ����, ���� ����� ������ ������ ����� ��������� ���� ������� � ������, ����
             ���� ������� �������� � �������� (������). ���� ����� ������ ����, �� �������
             ������������ ������� ������ ����� ���� ����� �������, ����������� �� 2 ������ �����
             �������.
*/



select  max(orders.sale) as max_discount_percent
  from  (
    select  oi.order_id,
            round(1- sum(oi.unit_price * oi.quantity) / sum(pi.list_price * oi.quantity), 4) * 100 as sale
      from  order_items oi
            join product_information pi on
            pi.product_id = oi.product_id
      group by  oi.order_id
  ) orders
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
        c.country_name
  from  (
          select  i.product_id,
                  count(*) as count_warehouses
            from  inventories i
            group by  i.product_id  
        ) i
         join inventories i2 on
           i2.product_id = i.product_id
         join product_information pi on  
           pi.product_id = i.product_id
         join warehouses w on 
           w.warehouse_id = i2.warehouse_id
         left join locations l on 
           l.location_id = w.location_id
         left join countries c on
           c.country_id = l.country_id
  where  i.count_warehouses = 1 
  order by  c.country_name,
            w.warehouse_id,
            pi.product_name
;



/*
        14:  ��� ���� ����� ������� ���������� ��������, ������� ��������� � ������ ������.
             ������� ����: ��� ������, �������� ������, ���������� ��������. ��� �����, � �������
             ��� ��������, � �������� ���������� �������� ������� 0. ����������� �� ����������
             �������� � �������� �������, ����� �� �������� ������.
*/



select  c.country_id,
        c.country_name,
        nvl(cust.cust_count, 0) as cust_count
  from  countries c
        left join (
          select  cust.cust_address_country_id,
                  count(*) as cust_count
            from  customers cust
            group by  cust.cust_address_country_id
        ) cust on
          cust.cust_address_country_id = c.country_id
  order by  cust.cust_count desc nulls last,
            c.country_name
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
        o1.order_date as order_date1,
        o2.order_date as order_date2,
        o3.min_orders_interval
  from  customers c
        left join orders o1 on
          o1.customer_id = c.customer_id
        left join orders o2 on
          o2.customer_id = c.customer_id
        left join (
          select  o1.customer_id,
                  min(trunc(o2.order_date, 'dd') - trunc(o1.order_date, 'dd')) as min_orders_interval
            from  orders o1
                  left join orders o2 on
                    o2.customer_id = o1.customer_id
             where  o1.order_date < o2.order_date
            group by o1.customer_id
        ) o3 on 
            o3.customer_id = c.customer_id
  where trunc(o2.order_date, 'dd') - trunc(o1.order_date, 'dd') = o3.min_orders_interval
  order by c.customer_id
        
        
  
  
;  



/*
            16. ��� ������� ���������� ����� ���� ������ ������ � �����������(�������� � ���������� ����� ������) 
*/



select  e.employee_id,
        e.last_name || ' ' || e.first_name as e_name,
        d.department_name,
        min(jh.start_date) as start_date
  from  employees e
        left join job_history jh on
          jh.job_id = e.job_id
        left join departments d on
          d.department_id = jh.department_id
  group by  e.employee_id,
            e.last_name, 
            e.first_name,
            d.department_name
  order by  start_date desc nulls last,
            e.employee_id
;

/*
            16. ��� ������� ���������� ����� ���� ������ ������ � �����������(�������� � ���������� ����� ������)
*/            


select  e.employee_id,
        e.last_name || ' ' || e.first_name as employee_name,
        nvl(jh.start_date, e.hire_date) as hire_date
  from  employees e
        left join job_history jh on
          jh.employee_id = e.employee_id
  group by  e.employee_id,
            e.last_name || ' ' || e.first_name,
            nvl(jh.start_date, e.hire_date)
  order by  e.employee_id 
;