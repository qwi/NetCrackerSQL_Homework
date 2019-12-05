 -- SQL Query, Lab 1:
 -- Author: Chemerisov Oleg

/*
    1:  Написать запрос, выводящий всю информацию о департаментах. Упорядочить по коду депортамента.
*/
  

select  d.*
  from  departments d
  order by  d.department_id
;
	

/*
    2:  Написать запрос, выбирающий ID, имя + фамилию ( в виде одного столбца через пробел) и адрес электронной почты всех клиентов
       (Использовать конкатенацию строк и переименование столбца с именем и фамилией на "Name"). Упорядочить по коду клиента.
*/
   
   
select   c.customer_id,
         c.cust_first_name || ' ' || c.cust_last_name as name,
         c.cust_email
  from   customers c
  order by  c.customer_id
;


/*
    3:  Написать запрос, выводящий сотрудников, зарплата которых за год лежит в диапозоне от 100 до 200 тыс. дол.,
        упорядочив их по занимаемой должности, зарплате( от большей к меньшей) и фамилии. Выбранные данные должны
        включать имя, должность(код должности), email, телефон, зарплату за месяц за вычетом налогов. Будем считать
        что у нас прогрессивная шкала налогообложения: с зарплаты за год от 100 до 150 тыс. дол. налог состовляет 30%,
        выше - 35%. Результат округлить до целого дол.
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
    4:  Выбрать страны с идентификаторами DE, IT или RU. 
        Переименовать столбцы на "Код страны", "Название страны".
        Упорядочить по названию страны.
*/


select  c.country_id as "Код страны",
        c.country_name as "Название страны"
  from  countries c
  where  c.country_id in ('DE', 'IT', 'RU')
  order  by  c.country_name
;

/*
    5:  Выбрать имя +фамилия сотрудников, у которых в фамилии вторая буква "а"(латинская),
        а в имени присутствует буква "d"( не важно, в каком регистре).
        Упорядочить по имени. Использовать оператор like и функции приведения к нужному регистру.
*/
     
     
select  e.first_name || ' ' || e.last_name as Name
  from  employees e
  where lower(e.last_name) like '_a%' and lower(e.first_name) like '%d%'
  order by  e.first_name
;


/*
    6:  Выбрать сотрудников у которых фамилия или имя короче 5 символов.
        Упорядочить записи по суммарной длине фамилии и имени, затем по длине фамилии,
        затем просто по фамилии, затем просто по имени. 
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
    7:  Выбрать должности в порядке их "Выгодности" (средней зарплате, за среднюю взять
        среднее-арифмитическое минимальной и максимальной зарплат). Более "выгодные"
        должности должны быть первыми, в случае одинаковой зарплаты упорядочить по коду
        должности. Вывести столбцы код должности, название должности, средняя зарплата
        после налогов, округленная до сотен. Считаем шкалу налогообложения плоской - 18%
*/


select  j.job_id,
        j.job_title,
        round (((j.min_salary + j.max_salary) / 2) - (((j.min_salary + j.max_salary) / 2) * 0.18), -2) as avg_salary 
  from  jobs j
  order by  avg_salary desc,
            j.job_id
;


/*
    8:  Будем считать, что все клиенты делятся на категории A,B,C. Категория
          А - кредитный лимит >= 3500
          B - кредитный лимит >= 1000
          C - все остальные.
        Вывести всех клиентов, упорядочив их по категории в обратном порядке
        (сначала клиенты категории А), затем по фамилии. 
        Вывести столбцы фамилия, имя, категория, комментарий. 
        В комментарии для клиентов А должна быть строка "Внимание VIP-клиенты",
        для остальных клиентов комментарий должен остаться пустым (NULL).
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
            'Внимание, VIP-клиенты'
        end comments       
  from  customers c
  order by  category,
            c.cust_last_name,
            c.cust_first_name         
;


/*
    9:  Вывести месяцы (их название на русском), в которые были заказы в 1998 году.
        Месяцы не должны повторяться и должны быть упорядочены. Использовать 
        группировку по функции extract от даты для исключения дублирования месяцев
        и decode для выбора месяца по его номеру. Подзапросы не использовать.
*/


select  decode(
          extract(month from order_date), 
            1, 'Январь',
            2, 'Февраль',
            3, 'Март',
            4, 'Апрель',
            5, 'Май',
            6, 'Июнь',
            7, 'Июль',
            8, 'Август',
            9, 'Сентябрь',
            10, 'Октябрь',
            11, 'Ноябрь',
            12, 'Декабрь'
        ) as month
  from   orders o
  where  date'1998-01-01'<=o.order_date and o.order_date<date'1999-01-01' and
         o.order_status >= 1
  group by  extract(month from o.order_date)
  order by  extract(month from o.order_date)
;


/*
    10:  Написать предыдущий запрос, используя для получиния названия месяца 
         функцию to_char(указать для функции nls_date_language 3-м параметром.
         Вместо группировки использовать параметр distinct, подзапросы не использовать.
*/


select  distinct
        to_char(o.order_date, 'Month', 'nls_date_language = russian') as month
  from  orders o
  where  o.order_status >= 1 and
         (o.order_date >= date'1998-01-01' and o.order_date<date'1999-01-01') 
  order by  to_date(month, 'Month', 'nls_date_language = russian')
;



/*
    11:  Написать запрос, выводящий все даты текущего месяца. Текущий месяц должен браться
         из sysdate. Второй столбец должен содержать комментарий в виде строки "Выходной" для
         суббот и воскресений. Для определения дня недели воспользоваться функцией to_char.
         Для выбора чисел от 1 до 31 можно воспользоваться псевдостолбцом rownum, выбирая
         данные из любой таблицы, где кол-во строк более 30.
*/


select  trunc(sysdate, 'mm') + rownum -1 as dt,
        case
          when trim(to_char(trunc(sysdate, 'mm') + rownum -1, 'DY', 'nls_date_language=english')) in ('SAT', 'SUN') then
            'Выходной'
        end comments
  from  dual
  connect by  trunc(sysdate, 'mm') + rownum -1 < add_months(trunc(sysdate, 'mm'), 1)
;


/*
    12:  Выбрать всех сотрудников (код сотрудника, фамилия+имя через пробел, код должности,
         зарплата, комиссия - %), которые получают комиссию от заказов. Воспользоваться
         конструкцией is not null.Упорядочить сотрудников по проценту комиссии (от большего к
         меньшему), затем по коду сотрудника.
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
    13:  Получить статистику по сумме продаж за 1995-2000 годы в разрезе кварталов (1 квартал
         январь-март и т.д.). В выборке должно быть 6 столбцов – год, сумма продаж за 1-ый, 2-
         ой, 3-ий и 4-ый квартала, а также общая сумма продаж за год. Упорядочить по году.
         Воспользоваться группировкой по году, а также суммированием по выражению с case
         или decode, которое будут отделять продажи за нужный квартал.
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
    14:  Выбрать из таблицы товаров всю оперативную память. Считать таковой любой товар
         для которого в названии указан размер в MB или GB (в любом регистре), название
         товара не начинается с HD, а также в первых 30 символах описания товара не
         встречаются слова disk, drive и hard. Вывести столбцы: код товара, название товара,
         гарантия, цена (по прайсу – LIST_PRICE), url в каталоге. В поле гарантия должно быть
         выведено целое число – количество месяцев гарантии (учесть, что гарантия может быть
         год и более). Упорядочить по размеру памяти (от большего к меньшему), затем по цене
         (от меньшей к большей). Размер для упорядочивания извлечь из названия товара по
         шаблону NN MB/GB (не забыть при этом сконвертировать GB в мегабайты) c помощью
         regexp_replace. Like не использовать, вместо него использовать regexp_like с явным
         указанием, что регистр букв следует игнорировать. 
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
    15:  Вывести целое количество минут, оставшихся до окончания занятий. Время окончания
         занятия в запросе должно быть задано в виде строки, например «21:30». Явного указания
         текущей даты в запросе быть не должно. Можно воспользоваться комбинацией функций
         to_char/to_date
*/

  
select  trunc((to_date(to_char(sysdate, 'dd.mm.yyyy') || '21:30', 'dd.mm.yyyy hh24:mi') - sysdate)* 24*60) as minutes
  from  dual
;