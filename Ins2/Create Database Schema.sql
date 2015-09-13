use Master
go

-- create database script
if (exists (select * from sys.databases where name = 'Insurance'))
	drop database Insurance
go


if (not exists (select * from sys.databases where name = 'Insurance'))
	create database Insurance
go

use Insurance
go

-- create person table
create table Person
(
	PersonId		uniqueidentifier	default newid()
	,UserId			int					not null
	,FirstName		nvarchar(255)		null
	,LastName		nvarchar(255)		null
	,MobilePhone	nvarchar(255)		null
	,Email			nvarchar(255)		null


	,Created		datetime			default getdate()
	,CreatedBy		nvarchar(255)		null
	,Updated		datetime			default getdate()
	,UpdatedBy		nvarchar(255)		null
)
go

-- Product table
create table Product
(
	ProductId		uniqueidentifier	default newid()
	,SKU			nvarchar(30)		null
	,ProductName	nvarchar(255)		not null
	,SupplierId		uniqueidentifier	not null
	,AvailableFrom	datetime			not null
	,AvailableTo	datetime			null

	,Created		datetime			default getdate()
	,CreatedBy		nvarchar(255)		null
	,Updated		datetime			default getdate()
	,UpdatedBy		nvarchar(255)		null
)
go

-- Supplier table
create table Supplier
(
	SupplierId		uniqueidentifier	default newid()
	,SupplierName	nvarchar(255)		not null
	-- other attributes in the future
	,Created		datetime			default getdate()
	,CreatedBy		nvarchar(255)		null
	,Updated		datetime			default getdate()
	,UpdatedBy		nvarchar(255)		null
)
go

-- PersonProduct table
create table PersonProduct
(
	PersonProductId	uniqueidentifier	default newid()
	,PersonId		uniqueidentifier	not null
	,ProductId		uniqueidentifier	not null
	,EffectiveStart	datetime			not null
	,EffectiveEnd	datetime			not null


	,Created		datetime			default getdate()
	,CreatedBy		nvarchar(255)		null
	,Updated		datetime			default getdate()
	,UpdatedBy		nvarchar(255)		null
)
go

create view vwPersonProduct
as
	select
		pp.PersonProductId
		,pp.PersonId
		,pp.ProductId
		,pp.EffectiveStart
		,pp.EffectiveEnd
		,p.FirstName
		,p.LastName
		,p.MobilePhone
		,p.Email
	from
		PersonProduct pp
	join
		Person p
	on
		pp.PersonId = p.PersonId
go

insert into Supplier (SupplierName) values ('Supplier')

insert into Product (ProductName, SupplierId, AvailableFrom) select top 1 'Test Product', SupplierId, getdate() from Supplier

insert into Person (FirstName, LastName, MobilePhone, UserId) values ('Steven', 'Smith', '0421050981', 1)

insert into PersonProduct (PersonId, ProductId, EffectiveStart, EffectiveEnd) 
select 
	(select top 1 PersonId from Person)
	,(select top 1 ProductId from Product)
	,getdate()
	,dateadd(y, 1, getdate())

select * from Person

select * from vwPersonProduct
