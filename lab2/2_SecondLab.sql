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
        left join  job_history j on 
          e.employee_id = j.employee_id
  where j.employee_id is null
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
        5:  Выбрать сотрудников, которые работают в США. Упорядочить по коду сотрудника.
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
        nvl(pd.translated_description, 'Нет описания') as ru_description
  from  product_information pi
          left join product_descriptions pd on
            pi.product_id = pd.product_id and
            pd.language_id = 'RU'
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
        nvl(pd.translated_description, 'Нет описания') as ru_description
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


        



















