alter procedure SpGetCustomerBalance
(
@CustomerId int
)
as
--------------------------- create report table --------------------
create table #CustomerBalance
(
Id int identity(1,1),
customerName nvarchar(200),
InvoiceDate datetime,
Received decimal(8,2),
Withdrwal decimal(8,2),
Balance decimal(8,2)
)
--------------------------- create report table --------------------

--------------------------- insert invoice data --------------------
insert into #CustomerBalance
select c.CustomerName,si.InvoiceDate,0,sum(sit.InvoicePrice),0 from TbCustomers as c join
TbSalesInvoices as si
on c.CustomerId=si.CustomerId
join TbSalesInvoiceItems as sit
on si.InvoiceId=sit.InvoiceId
where c.CustomerId=@CustomerId or @CustomerId=0
group by c.CustomerName,si.InvoiceDate
--------------------------- insert invoice data --------------------

--------------------------- insert cash data --------------------
insert into #CustomerBalance
select c.CustomerName,ct.CashDate,ct.CashValue,0,0
from TbCashTransacion as ct join
TbCustomers as c
on c.CustomerId=ct.CustomerId
where (c.CustomerId=@CustomerId or @CustomerId=0)
--------------------------- insert invoice data --------------------

--update #CustomerBalance set Balance=(select sum(Received)-sum(Withdrwal)
--from #CustomerBalance as c
--where c.InvoiceDate<=#CustomerBalance.InvoiceDate)

declare @Id int
declare @ReceivedVar decimal(8,2)
declare @WithdrowalVar decimal(8,2)
declare @BalanceVar decimal(8,2)
set @ReceivedVar=0
set @WithdrowalVar=0
set @BalanceVar=0
DECLARE cursor_product CURSOR
FOR select Id,Received,Withdrwal
from #CustomerBalance
order by InvoiceDate

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO 
    @Id, 
    @ReceivedVar,
	@WithdrowalVar;

WHILE @@FETCH_STATUS = 0
    BEGIN

		set @BalanceVar=@BalanceVar+(@ReceivedVar-@WithdrowalVar)
		print @BalanceVar

		update #CustomerBalance set Balance=@BalanceVar
		where Id=@Id

        FETCH NEXT FROM cursor_product INTO 
			@Id, 
			@ReceivedVar,
			@WithdrowalVar;
    END;

CLOSE cursor_product;

DEALLOCATE cursor_product;

select * from #CustomerBalance
order by InvoiceDate