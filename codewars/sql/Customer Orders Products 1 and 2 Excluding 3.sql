select 
      c.customer_id,
      c.name,
      concat('Product 1: ', 
      count(o.order_id) filter(where o.product_name = 'Product 1'),
             ' times', ' || ', 'Product 2: ',
      count(o.order_id) filter(where o.product_name = 'Product 2'),
             ' times'
             ) as 	product_summary
from customers c
join orders o 
using(customer_id)
where exists (
select 1 from orders oo where oo.customer_id = c.customer_id 
  and oo.product_name in ('Product 1')
) and exists (
select 1 from orders oo where oo.customer_id = c.customer_id 
  and oo.product_name in ('Product 2')
) and not exists (
select 1 from orders oo where oo.customer_id = c.customer_id 
  and oo.product_name in ('Product 3')
)
group by 1, 2
order by customer_id desc