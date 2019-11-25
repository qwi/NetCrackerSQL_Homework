 -- SQL Query, Lab 2:
 -- Author: Chemerisov Oleg


/*
      1:  Выбрать клиентов, у которых были заказы в июле 1999 года. Упорядочить по коду
          клиента. Использовать внутреннее соединение (inner join) и distinct.
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
      2:  Выбрать всех клиентов и сумму их заказов за 2000 год, упорядочив их по сумме заказов
          (клиенты, у которых вообще не было заказов за 2000 год, вывести в конце), затем по ID
          заказчика. Вывести поля: код заказчика, имя заказчика (фамилия + имя через пробел),
          сумма заказов за 2000 год. Использовать внешнее соединение (left join) таблицы
          заказчиков с подзапросом для выбора суммы товаров (по таблице заказов) по клиентам
          за 2000 год (подзапрос с группировкой).
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
        3:  Выбрать сотрудников, которые работают на первой своей должности (нет записей в
            истории). Использовать внешнее соединение (какое конкретно?) с таблицей истории, а
            затем отбор записей из таблицы сотрудников таких, для которых не «подцепилось»
            строк из таблицы истории. Упорядочить отобранных сотрудников по дате приема на
            работу (в обратном порядке, затем по коду сотрудника (в обычном порядке).
*/


select  e.*
  from  employees e
        left join 
          job_history j on 
            e.employee_id = j.employee_id
  where j.employee_id is null
  order by  e.hire_date desc,
            e.employee_id
;




















