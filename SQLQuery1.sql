select i.ItemName,c.CategoryName,si.InvoicePrice,0
from  TbCategories as c left join  TbItems as i
on i.CategoryId=c.CategoryId
inner join TbSalesInvoiceItems as si
on si.ItemId=i.ItemId
--where si.InvoiceId=1

alter view VwItemsOutOfInvoices
as
select i.ItemName,c.CategoryName,si.InvoicePrice,i.PurchasePrice
from  TbCategories as c left join  TbItems as i
on i.CategoryId=c.CategoryId
left join TbSalesInvoiceItems as si
on si.ItemId=i.ItemId
where si.InvoicePrice is null

select * from VwItemsOutOfInvoices

select * 
from VwItemCategories
where ItemName like '%h%'
order by SalesPrice

select CustomerId as Id,CustomerName as Name,1 as Type from TbCustomers
union all
select *,2 from TbSuppliers
order by Id

select si.CustomerId,sit.ItemId,sit.InvoicePrice
from TbSalesInvoices as si join TbSalesInvoiceItems as sit
on si.InvoiceId=sit.InvoiceId
union all
select si.SupplierId,sit.ItemId,sit.InvoicePrice
from TbPurchaseInvoices as si join TbPurchaseInvoiceItems as sit
on si.InvoiceId=sit.InvoiceId

SELECT *, CHARINDEX('t', ItemName) AS MatchPosition,
len(ItemName),format(SalesPrice,'0,00'),
left(ItemName,3)+convert(varchar, ItemId)
from TbItems

SELECT DIFFERENCE('Juice', 'Jucy');

SELECT REVERSE('SQL Tutorial');

SELECT left('SQL Tutorial', 3) AS ExtractString;

SELECT STR(185);

SELECT DATEADD(day, -1, DelivryDate) AS DateAdd
from TbSalesInvoices

select x.dateDifference,sit.InvoicePrice from (
SELECT *, DATEDIFF(day, DelivryDate, getdate()) AS dateDifference,
day(DelivryDate)
from TbSalesInvoices) as x join TbSalesInvoiceItems as sit
on x.InvoiceId=sit.InvoiceId

select dbo.PriceWithVat(SalesPrice) as priceWithVat,SalesPrice,
dbo.SalesPofit(ItemId) as profit
from TbItems

select * from dbo.GetItemsByName('hp')

execute SpGetInvoices 1