 -- SQL Query, Lab 2:
 -- Author: Chemerisov Oleg


/*
        1:  Выбрать клиентов, у которых были заказы в июле 1999 года. Упорядочить по коду
            клиента. Использовать внутреннее соединение (inner join) и distinct.
*/



select  distinct c.*
  from  customers c
        join orders o on
          o.customer_id = c.customer_id
  where date'1999-07-01' <= o.order_date and o.order_date < date'1999-08-01'
  order by c.customer_id
;



/*
        2:  Выбрать всех клиентов и сумму их заказов за 2000 год, упорядочив их по сумме заказов
            (клиенты, у которых вообще не было заказов за 2000 год, вывести в конце), затем по ID
            заказчика. Вывести поля: код заказчика, имя заказчика (фамилия + имя через пробел),
            сумма заказов за 2000 год. Использовать внешнее соединение (left join) таблицы
            заказчиков с подзапросом для выбора суммы товаров (по таблице заказов) по клиентам
            за 2000 год (подзапрос с группировкой).
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
        3:  Выбрать сотрудников, которые работают на первой своей должности (нет записей в
            истории). Использовать внешнее соединение (какое конкретно?) с таблицей истории, а
            затем отбор записей из таблицы сотрудников таких, для которых не «подцепилось»
            строк из таблицы истории. Упорядочить отобранных сотрудников по дате приема на
            работу (в обратном порядке, затем по коду сотрудника (в обычном порядке).
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
        4:  Выбрать все склады, упорядочив их по количеству номенклатуры товаров,
            представленных в них. Вывести поля: код склада, название склада, количество
            различных товаров на складе. Упорядочить по количеству номенклатуры товаров на
            складе (от большего количества к меньшему), затем по коду склада (в обычном
            порядке). Склады, для которых нет информации о товарах на складе, вывести в конце.
            Подзапросы не использовать.
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
        5:  Выбрать сотрудников, которые работают в США. Упорядочить по коду сотрудника.
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
        6:  Выбрать все товары и их описание на русском языке. Вывести поля: код товара,
            название товара, цена товара в каталоге (LIST_PRICE), описание товара на русском
            языке. Если описания товара на русском языке нет, в поле описания вывести «Нет
            описания», воспользовавшись функцией nvl или выражением case (в учебной базе
            данных для всех товаров есть описания на русском языке, однако запрос должен быть
            написан в предположении, что описания на русском языке может и не быть; для
            проверки запроса можно указать код несуществующего языка и проверить, появилось ли
            в поле описания соответствующий комментарий). Упорядочить по коду категории
            товара, затем по коду товара.
*/




select  pi.product_id,
        pi.product_name,
        pi.list_price,
        nvl(pd.translated_description, 'Нет описания') as description
  from  product_information pi
        left join product_descriptions pd on
          pd.product_id = pi.product_id and 
          pd.language_id = 'RU'
          -- where pd.language_id in('RU')
  order by  pi.category_id,
            pi.product_id
;



/*
        7:  Выбрать товары, которые никогда не продавались. Вывести поля: код товара, название
            товара, цена товара в каталоге (LIST_PRICE), название товара на русском языке (запрос
            должен быть написан в предположении, что описания товара на русском языке может и
            не быть). Упорядочить по цене товара в обратном порядке (товары, для которых не
            указана цена, вывести в конце), затем по коду товара.
*/



select  pi.product_id,
        pi.product_name,
        pi.list_price,
        nvl(pd.translated_description, 'Нет описания') as description
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
        8:  Выбрать клиентов, у которых есть заказы на сумму больше, чем в 2 раза превышающую
            среднюю цену заказа. Вывести поля: код клиента, название клиента (фамилия + имя
            через пробел), количество таких заказов, максимальная сумма заказа. Упорядочить по
            количеству таких заказов в обратном порядке, затем по коду клиента.          
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
        9:  Упорядочить клиентов по сумме заказов за 2000 год. Вывести поля: код клиента, имя
            клиента (фамилия + имя через пробел), сумма заказов за 2000 год. Упорядочить данные
            по сумме заказов за 2000 год в обратном порядке, затем по коду клиента. Клиенты, у
            которых не было заказов в 2000, вывести в конце.
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
        10:  Переписать предыдущий запрос так, чтобы не выводить клиентов, у которых вообще не
             было заказов
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
        11:  Каждому менеджеру по продажам сопоставить последний его заказ. Менеджера по
             продажам считаем сотрудников, код должности которых: «SA_MAN» и «SA_REP».
             Вывести поля: код менеджера, имя менеджера (фамилия + имя через пробел), код
             клиента, имя клиента (фамилия + имя через пробел), дата заказа, сумма заказа,
             количество различных позиций в заказе. Упорядочить данные по дате заказа в обратном
             порядке, затем по сумме заказа в обратном порядке, затем по коду сотрудника. Тех
             менеджеров, у которых нет заказов, вывести в конце.
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
        12:  Проверить, были ли заказы, в которых товары поставлялись со скидкой. Считаем, что
             скидка была, если сумма заказа меньше суммы стоимости всех позиций в заказе, если
             цены товаров смотреть в каталоге (прайсе). Если такие заказы были, то вывести
             максимальный процент скидки среди всех таких заказов, округленный до 2 знаков после
             запятой.
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
        13:  Выбрать товары, которые есть только на одном складе. Вывести поля: код товара,
             название товара, цена товара по каталогу (LIST_PRICE), код и название склада, на
             котором есть данный товар, страна, в которой находится данный склад. Упорядочить
             данные по названию стране, затем по коду склада, затем по названию товара.
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
        14:  Для всех стран вывести количество клиентов, которые находятся в данной стране.
             Вывести поля: код страны, название страны, количество клиентов. Для стран, в которых
             нет клиентов, в качестве количества клиентов вывести 0. Упорядочить по количеству
             клиентов в обратном порядке, затем по названию страны.
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
        15:  Для каждого клиента выбрать минимальный интервал (количество дней) между его
             заказами. Интервал между заказами считать как разницу в днях между датами 2-х
             заказов без учета времени заказа. Вывести поля: код клиента, имя клиента
             (фамилия + имя через пробел), даты заказов с минимальным интервалом (время не
             отбрасывать), интервал в днях между этими заказами. Если у клиента заказов нет или
             заказ один за всю историю, то таких клиентов не выводить. Упорядочить по коду
             клиента.
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
            16. Для каждого сотрудника найти дату начала работы в организации(смотреть и предыдущие места работы) 
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
            16. Для каждого сотрудника найти дату начала работы в организации(смотреть и предыдущие места работы)
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