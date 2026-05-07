select v3.Badge as Badge,v3.[Description] as Agent, vtable3.violationdatetime as APBTime, vtable3.PnlNo as APBPanel, vtable3.DeviceNo as APBDevice, v3.Edate as PriorEvent, v3.PnlNo as PriorPanel, v3.DeviceNo as PriorDevice  
from [CardAccessLiveEventsUS].[dbo].[Event] v3
inner join
(
select
v2.Badge, Max(v2.EDate) as priordatetime, (vtable.EDate) as violationdatetime, vtable.PnlNo, vtable.DeviceNo
FROM [CardAccessLiveEventsUS].[dbo].[Event] v2
inner join  
(
SELECT TOP (2000)
 [EDate]
,Badge
,PnlNo
,DeviceNo
 FROM [CardAccessLiveEventsUS].[dbo].[Event]
 WHERE [Class] = 'BADGE Violate APB'
 --and PnlNo IN('12')
 --and DeviceNo IN ('1','2')
  order by EDate desc
) vtable on vtable.Badge = v2.Badge
  where vtable.EDate > v2.EDate
  group by v2.Badge, vtable.EDate, vtable.DeviceNo, vtable.PnlNo
 ) vtable3 on v3.EDate = vtable3.priordatetime and vtable3.Badge = v3.Badge
where v3.Class != 'BADGE Violate APB'
-- The next line can be used to filter down to a spicific user or badge.
--and v3.[Description] LIKE '%Woodard%'
and v3.Badge like '15967'
order by APBTime desc
