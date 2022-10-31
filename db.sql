USE [master]
GO

CREATE DATABASE [StoreWebsite]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'StoreWebsite', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\StoreWebsite.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'StoreWebsite_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\StoreWebsite_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [StoreWebsite] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StoreWebsite].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StoreWebsite] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StoreWebsite] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StoreWebsite] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StoreWebsite] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StoreWebsite] SET ARITHABORT OFF 
GO
ALTER DATABASE [StoreWebsite] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StoreWebsite] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StoreWebsite] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StoreWebsite] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StoreWebsite] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StoreWebsite] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StoreWebsite] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StoreWebsite] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StoreWebsite] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StoreWebsite] SET  DISABLE_BROKER 
GO
ALTER DATABASE [StoreWebsite] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StoreWebsite] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StoreWebsite] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StoreWebsite] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StoreWebsite] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StoreWebsite] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StoreWebsite] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StoreWebsite] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [StoreWebsite] SET  MULTI_USER 
GO
ALTER DATABASE [StoreWebsite] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StoreWebsite] SET DB_CHAINING OFF 
GO
ALTER DATABASE [StoreWebsite] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [StoreWebsite] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [StoreWebsite] SET DELAYED_DURABILITY = DISABLED 
GO
USE [StoreWebsite]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PriceWithVat]
(
	@Price decimal(8,2)
)
RETURNS decimal(8,2)
AS
BEGIN
declare @PriceWithVat decimal(8,2)
set @PriceWithVat=((@Price*14)/100)+@Price

if(@PriceWithVat<0)
begin
set @PriceWithVat=0
end

return @PriceWithVat
END


GO
/****** Object:  UserDefinedFunction [dbo].[SalesPofit]    Script Date: 8/18/2020 1:57:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[SalesPofit]
(
@ItemId int
)
returns decimal(8,2)
as
begin
declare @SalesPrice decimal(8,2)
declare @PurchasePrice decimal(8,2)

select @SalesPrice=SalesPrice,@PurchasePrice=PurchasePrice
from TbItems
where ItemId=@ItemId
return @PurchasePrice-@SalesPrice
end
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TbCategories] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbCustomers](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TbCustomers] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbItemImages](
	[ImageId] [int] IDENTITY(1,1) NOT NULL,
	[ImageName] [nvarchar](200) NOT NULL,
	[ItemId] [int] NOT NULL,
 CONSTRAINT [PK_TbItemImages] PRIMARY KEY CLUSTERED 
(
	[ImageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbItems](
	[ItemId] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [nvarchar](100) NOT NULL,
	[SalesPrice] [decimal](8, 2) NOT NULL,
	[PurchasePrice] [decimal](8, 2) NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_TbItems] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbPurchaseInvoiceItems](
	[InvoiceItemId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[InvoiceId] [int] NOT NULL,
	[Qty] [float] NOT NULL,
	[InvoicePrice] [decimal](8, 4) NOT NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_TbPurchaseInvoiceItems] PRIMARY KEY CLUSTERED 
(
	[InvoiceItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbPurchaseInvoices](
	[InvoiceId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[SupplierId] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_TbPurchaseInvoices] PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbSalesInvoiceItems](
	[InvoiceItemId] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[InvoiceId] [int] NOT NULL,
	[Qty] [float] NOT NULL CONSTRAINT [DF_TbSalesInvoiceItems_Qty]  DEFAULT ((1)),
	[InvoicePrice] [decimal](8, 4) NOT NULL CONSTRAINT [DF_TbSalesInvoiceItems_InvoicePrice]  DEFAULT ((0)),
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_TbSalesInvoiceItems] PRIMARY KEY CLUSTERED 
(
	[InvoiceItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbSalesInvoices](
	[InvoiceId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceDate] [datetime] NOT NULL CONSTRAINT [DF_TbSalesInvoices_InvoiceDate]  DEFAULT (getdate()),
	[DelivryDate] [datetime] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[DelivryManId] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_TbSalesInvoices] PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbSuppliers](
	[SupplierId] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TbSupplier] PRIMARY KEY CLUSTERED 
(
	[SupplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetItemsByName]
(	
	@ItemName nvarchar(200)
)
RETURNS TABLE 
AS

RETURN 
(
select * from TbItems
where ItemName like '%'+@ItemName+'%'
)

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VwItemCategories]
AS
SELECT dbo.TbItems.ItemName, dbo.TbItems.SalesPrice, dbo.TbCategories.CategoryName
FROM   dbo.TbItems INNER JOIN
             dbo.TbCategories ON dbo.TbItems.CategoryId = dbo.TbCategories.CategoryId

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VwItemsOutOfInvoices]
as
select i.ItemName,c.CategoryName,si.InvoicePrice,i.PurchasePrice
from  TbCategories as c left join  TbItems as i
on i.CategoryId=c.CategoryId
left join TbSalesInvoiceItems as si
on si.ItemId=i.ItemId
where si.InvoicePrice is null
GO
SET IDENTITY_INSERT [dbo].[TbCategories] ON 

INSERT [dbo].[TbCategories] ([CategoryId], [CategoryName]) VALUES (1, N'Hp')
INSERT [dbo].[TbCategories] ([CategoryId], [CategoryName]) VALUES (2, N'Dell')
INSERT [dbo].[TbCategories] ([CategoryId], [CategoryName]) VALUES (3, N'Lenovo')
INSERT [dbo].[TbCategories] ([CategoryId], [CategoryName]) VALUES (4, N'Issus')
INSERT [dbo].[TbCategories] ([CategoryId], [CategoryName]) VALUES (5, N'Microsoft')
INSERT [dbo].[TbCategories] ([CategoryId], [CategoryName]) VALUES (6, N'MSI')
INSERT [dbo].[TbCategories] ([CategoryId], [CategoryName]) VALUES (7, N'Acer')
SET IDENTITY_INSERT [dbo].[TbCategories] OFF
SET IDENTITY_INSERT [dbo].[TbCustomers] ON 

INSERT [dbo].[TbCustomers] ([CustomerId], [CustomerName]) VALUES (1, N'ali')
INSERT [dbo].[TbCustomers] ([CustomerId], [CustomerName]) VALUES (2, N'ahmed')
INSERT [dbo].[TbCustomers] ([CustomerId], [CustomerName]) VALUES (3, N'ibrahem')
INSERT [dbo].[TbCustomers] ([CustomerId], [CustomerName]) VALUES (4, N'mahmoud')
INSERT [dbo].[TbCustomers] ([CustomerId], [CustomerName]) VALUES (5, N'abdallah')
SET IDENTITY_INSERT [dbo].[TbCustomers] OFF
SET IDENTITY_INSERT [dbo].[TbItems] ON 

INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (2, N'Hp g3 745', CAST(4300.00 AS Decimal(8, 2)), CAST(4800.00 AS Decimal(8, 2)), 1)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (3, N'Hp Zbook g2', CAST(7200.00 AS Decimal(8, 2)), CAST(7600.00 AS Decimal(8, 2)), 1)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (10, N'Hp Zbook g3', CAST(10000.00 AS Decimal(8, 2)), CAST(12500.00 AS Decimal(8, 2)), 1)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (11, N'Dell Lattiude 6520', CAST(3200.00 AS Decimal(8, 2)), CAST(3600.00 AS Decimal(8, 2)), 2)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (12, N'Dell Lattiude 6540 M', CAST(4600.00 AS Decimal(8, 2)), CAST(5000.00 AS Decimal(8, 2)), 2)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (14, N'Dell Lattidue 5540', CAST(4500.00 AS Decimal(8, 2)), CAST(5000.00 AS Decimal(8, 2)), 2)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (15, N'Lenovo ThikPad 550', CAST(5500.00 AS Decimal(8, 2)), CAST(6200.00 AS Decimal(8, 2)), 3)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (16, N'Lenovo ThikPad 6520', CAST(6500.00 AS Decimal(8, 2)), CAST(7000.00 AS Decimal(8, 2)), 3)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (17, N'Hp Zbook g3 Studio', CAST(13000.00 AS Decimal(8, 2)), CAST(14000.00 AS Decimal(8, 2)), 1)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (18, N'Microsoft Surface pro 2', CAST(12000.00 AS Decimal(8, 2)), CAST(13000.00 AS Decimal(8, 2)), 4)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (19, N'Msi 670 HQ', CAST(13000.00 AS Decimal(8, 2)), CAST(14000.00 AS Decimal(8, 2)), 5)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (20, N'Msi 520', CAST(7500.00 AS Decimal(8, 2)), CAST(8000.00 AS Decimal(8, 2)), 5)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (21, N'Dell 7510', CAST(11500.00 AS Decimal(8, 2)), CAST(12500.00 AS Decimal(8, 2)), 2)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (22, N'Dell 7520', CAST(12500.00 AS Decimal(8, 2)), CAST(13500.00 AS Decimal(8, 2)), 2)
INSERT [dbo].[TbItems] ([ItemId], [ItemName], [SalesPrice], [PurchasePrice], [CategoryId]) VALUES (24, N'Lenovo Ideapad 4562', CAST(5000.00 AS Decimal(8, 2)), CAST(6500.00 AS Decimal(8, 2)), 3)
SET IDENTITY_INSERT [dbo].[TbItems] OFF
SET IDENTITY_INSERT [dbo].[TbSalesInvoiceItems] ON 

INSERT [dbo].[TbSalesInvoiceItems] ([InvoiceItemId], [ItemId], [InvoiceId], [Qty], [InvoicePrice], [Notes]) VALUES (2, 2, 1, 3, CAST(5000.0000 AS Decimal(8, 4)), N'item sold')
INSERT [dbo].[TbSalesInvoiceItems] ([InvoiceItemId], [ItemId], [InvoiceId], [Qty], [InvoicePrice], [Notes]) VALUES (3, 3, 1, 5, CAST(6000.0000 AS Decimal(8, 4)), N'item sold 2')
INSERT [dbo].[TbSalesInvoiceItems] ([InvoiceItemId], [ItemId], [InvoiceId], [Qty], [InvoicePrice], [Notes]) VALUES (6, 10, 1, 1, CAST(7000.0000 AS Decimal(8, 4)), N'item sold 2')
INSERT [dbo].[TbSalesInvoiceItems] ([InvoiceItemId], [ItemId], [InvoiceId], [Qty], [InvoicePrice], [Notes]) VALUES (7, 10, 2, 1, CAST(7000.0000 AS Decimal(8, 4)), NULL)
INSERT [dbo].[TbSalesInvoiceItems] ([InvoiceItemId], [ItemId], [InvoiceId], [Qty], [InvoicePrice], [Notes]) VALUES (8, 11, 2, 1, CAST(7000.0000 AS Decimal(8, 4)), NULL)
SET IDENTITY_INSERT [dbo].[TbSalesInvoiceItems] OFF
SET IDENTITY_INSERT [dbo].[TbSalesInvoices] ON 

INSERT [dbo].[TbSalesInvoices] ([InvoiceId], [InvoiceDate], [DelivryDate], [CustomerId], [DelivryManId], [Notes]) VALUES (1, CAST(N'2020-08-13 23:04:55.260' AS DateTime), CAST(N'2020-08-13 23:04:55.260' AS DateTime), 1, 1, NULL)
INSERT [dbo].[TbSalesInvoices] ([InvoiceId], [InvoiceDate], [DelivryDate], [CustomerId], [DelivryManId], [Notes]) VALUES (2, CAST(N'2020-08-13 23:16:48.027' AS DateTime), CAST(N'2020-08-13 23:16:48.027' AS DateTime), 2, 1, NULL)
SET IDENTITY_INSERT [dbo].[TbSalesInvoices] OFF
SET IDENTITY_INSERT [dbo].[TbSuppliers] ON 

INSERT [dbo].[TbSuppliers] ([SupplierId], [SupplierName]) VALUES (1, N'ali')
INSERT [dbo].[TbSuppliers] ([SupplierId], [SupplierName]) VALUES (2, N'Hossam')
INSERT [dbo].[TbSuppliers] ([SupplierId], [SupplierName]) VALUES (3, N'Ramy')
INSERT [dbo].[TbSuppliers] ([SupplierId], [SupplierName]) VALUES (4, N'Youssef')
SET IDENTITY_INSERT [dbo].[TbSuppliers] OFF
ALTER TABLE [dbo].[TbPurchaseInvoiceItems] ADD  CONSTRAINT [DF_TbPurchaseInvoiceItems_Qty]  DEFAULT ((1)) FOR [Qty]
GO
ALTER TABLE [dbo].[TbPurchaseInvoiceItems] ADD  CONSTRAINT [DF_TbPurchaseInvoiceItems_InvoicePrice]  DEFAULT ((0)) FOR [InvoicePrice]
GO
ALTER TABLE [dbo].[TbPurchaseInvoices] ADD  CONSTRAINT [DF_TbPurchaseInvoices_InvoiceDate]  DEFAULT (getdate()) FOR [InvoiceDate]
GO
ALTER TABLE [dbo].[TbItemImages]  WITH CHECK ADD  CONSTRAINT [FK_TbItemImages_TbItems] FOREIGN KEY([ItemId])
REFERENCES [dbo].[TbItems] ([ItemId])
GO
ALTER TABLE [dbo].[TbItemImages] CHECK CONSTRAINT [FK_TbItemImages_TbItems]
GO
ALTER TABLE [dbo].[TbItems]  WITH CHECK ADD  CONSTRAINT [FK_TbItems_TbCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[TbCategories] ([CategoryId])
GO
ALTER TABLE [dbo].[TbItems] CHECK CONSTRAINT [FK_TbItems_TbCategories]
GO
ALTER TABLE [dbo].[TbPurchaseInvoiceItems]  WITH CHECK ADD  CONSTRAINT [FK_TbPurchaseInvoiceItems_TbItems] FOREIGN KEY([ItemId])
REFERENCES [dbo].[TbItems] ([ItemId])
GO
ALTER TABLE [dbo].[TbPurchaseInvoiceItems] CHECK CONSTRAINT [FK_TbPurchaseInvoiceItems_TbItems]
GO
ALTER TABLE [dbo].[TbPurchaseInvoiceItems]  WITH CHECK ADD  CONSTRAINT [FK_TbPurchaseInvoiceItems_TbPurchaseInvoices] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[TbPurchaseInvoices] ([InvoiceId])
GO
ALTER TABLE [dbo].[TbPurchaseInvoiceItems] CHECK CONSTRAINT [FK_TbPurchaseInvoiceItems_TbPurchaseInvoices]
GO
ALTER TABLE [dbo].[TbPurchaseInvoices]  WITH CHECK ADD  CONSTRAINT [FK_TbPurchaseInvoices_TbSuppliers] FOREIGN KEY([SupplierId])
REFERENCES [dbo].[TbSuppliers] ([SupplierId])
GO
ALTER TABLE [dbo].[TbPurchaseInvoices] CHECK CONSTRAINT [FK_TbPurchaseInvoices_TbSuppliers]
GO
ALTER TABLE [dbo].[TbSalesInvoiceItems]  WITH CHECK ADD  CONSTRAINT [FK_TbSalesInvoiceItems_TbItems] FOREIGN KEY([ItemId])
REFERENCES [dbo].[TbItems] ([ItemId])
GO
ALTER TABLE [dbo].[TbSalesInvoiceItems] CHECK CONSTRAINT [FK_TbSalesInvoiceItems_TbItems]
GO
ALTER TABLE [dbo].[TbSalesInvoiceItems]  WITH CHECK ADD  CONSTRAINT [FK_TbSalesInvoiceItems_TbSalesInvoices] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[TbSalesInvoices] ([InvoiceId])
GO
ALTER TABLE [dbo].[TbSalesInvoiceItems] CHECK CONSTRAINT [FK_TbSalesInvoiceItems_TbSalesInvoices]
GO
ALTER TABLE [dbo].[TbSalesInvoices]  WITH CHECK ADD  CONSTRAINT [FK_TbSalesInvoices_TbCustomers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[TbCustomers] ([CustomerId])
GO
ALTER TABLE [dbo].[TbSalesInvoices] CHECK CONSTRAINT [FK_TbSalesInvoices_TbCustomers]
GO