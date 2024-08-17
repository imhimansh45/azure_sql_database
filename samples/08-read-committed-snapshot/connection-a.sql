/*
    Use WideWorldImporters Database
*/

drop table if exists dbo.sample_cities;
select CityId, CityName, StateProvinceID, [Location], LatestRecordedPopulation, LastEditedBy
into dbo.sample_cities from [Application].[Cities] 
go

select CityName, count(*) as [Rows]
from dbo.sample_cities 
where CityName in ('Redmond', 'Bellevue', 'Kirkland')
group by CityName
go

begin tran
    select @@trancount

    -- Make some changes
    insert into dbo.sample_cities  
        (CityID, CityName, StateProvinceID, LastEditedBy)
    values 
        (99999, 'Redmond', 50, 1)

    delete from dbo.sample_cities  
    where CityName = 'Bellevue'

    update dbo.sample_cities  
    set LatestRecordedPopulation = 123456
    where CityName = 'Kirkland' and StateProvinceID = 50

    -- This connection can see all the changes done to the data by itself
    select * from dbo.sample_cities  
    where CityName IN ('Kirkland', 'Redmond', 'Bellevue')
    order by CityID

    select CityName, count(*) as [Rows]
    from dbo.sample_cities 
    where CityName in ('Redmond', 'Bellevue', 'Kirkland')
    group by CityName

    select @@trancount
    /* STOP HERE AND EXECUTE IN ANOTHER SESSION THE "connection-b.sql" SCRIPT BEFORE PROCEEDING! */

commit tran
--or rollback tran



