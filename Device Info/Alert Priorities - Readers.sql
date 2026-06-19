-- Set the following variables
DECLARE
  @SQL NVARCHAR(MAX),
  @Filter varchar(10) = 'False',
  @AlertFilter INT = 9,
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = '
SELECT
     r.[PnlRef] ''Panel#''
    ,r.[RdrNo] ''Reader#''
    ,r.[ReaderName] ''Reader Name''
    ,rp.[VPrior] ''Void Violate''
    ,r.[RespVoidBadge] ''Resp Req. for Void Violate''
    ,rp.[OTHPrior] ''Other Denied''
FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Reader] r
LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Readerpriority] rp ON r.PnlRef = rp.PnlRef AND r.RdrNo = rp.RdrNo
WHERE (@Filter <> ''True'' OR rp.[VPrior] LIKE @AlertFilter)
ORDER BY r.[PnlRef], r.[RdrNo];';

EXEC sp_executesql
  @SQL,
  N'@Filter varchar(10),
    @AlertFilter INT',
  @Filter = @Filter,
  @AlertFilter = @AlertFilter;