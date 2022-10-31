count()
sum()
min()
max()
avg()

select count(*)
from TbItems

select (sum(SalesPrice)/2) * sum(PurchasePrice)
from TbItems

select min(SalesPrice),max(PurchasePrice),avg(SalesPrice)
from TbItems

select min(SalesPrice),max(PurchasePrice),avg(SalesPrice),CategoryId
from TbItems
group by CategoryId

select * from TbItems

select sum(SalesPrice),CategoryId
from TbItems
group by CategoryId
having sum(SalesPrice)>17000
order by CategoryId desc

select * from(
select sum(SalesPrice) as Sumtion,CategoryId
from TbItems
group by CategoryId) as innerSelect
where Sumtion>17000

select sum(SalesPrice),CategoryName,TbCategories.CategoryId
from TbItems join TbCategories
on TbItems.CategoryId=TbCategories.CategoryId
group by TbCategories.CategoryName,TbCategories.CategoryId
having sum(SalesPrice)>17000
order by TbCategories.CategoryName desc

select *,
(select sum(InvoicePrice) 
from TbSalesInvoiceItems
where TbSalesInvoiceItems.InvoiceId=TbSalesInvoices.InvoiceId)
from TbSalesInvoices

select TbSalesInvoices.InvoiceDate,TbSalesInvoices.InvoiceId,
TbSalesInvoices.DelivryDate ,sum(InvoicePrice)
from TbSalesInvoices join TbSalesInvoiceItems
on TbSalesInvoices.InvoiceId=TbSalesInvoiceItems.InvoiceId
group by TbSalesInvoices.InvoiceDate,TbSalesInvoices.InvoiceId,
TbSalesInvoices.DelivryDate 

TbSalesInvoiceItems invoicePrice
TbItems				SalesPrice

update TbSalesInvoiceItems set InvoicePrice=
(select SalesPrice from TbItems
where TbItems.ItemId=TbSalesInvoiceItems.ItemId)