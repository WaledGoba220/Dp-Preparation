declare @InvoicePriceVar decimal(8,2)
declare @ItemId int
declare @Sum decimal(8,2)
set @Sum=0
DECLARE cursor_product CURSOR
FOR select InvoicePrice,ItemId
from TbSalesInvoiceItems

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO 
    @InvoicePriceVar, 
    @ItemId;

WHILE @@FETCH_STATUS = 0
    BEGIN

		set @Sum=@Sum+@InvoicePriceVar
		print 'invoice price'
		print @InvoicePriceVar
		print 'sumtion'
		print @Sum

        FETCH NEXT FROM cursor_product INTO 
			@InvoicePriceVar, 
			@ItemId;
    END;

CLOSE cursor_product;

DEALLOCATE cursor_product;