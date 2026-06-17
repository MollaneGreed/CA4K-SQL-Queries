DECLARE
    @Reader NVARCHAR (50) = 'MLK 1215 Finance';

SELECT
    t1.BadgeID,
    t1.FirstName,
    t1.LastName,
    t1.AccessGroupName,
    t2.Description
FROM CardAccessLiveConfigurationUS.dbo.ca_vw_GetReaderAccessListData t1
LEFT JOIN CardAccessLiveConfigurationUS.dbo.ca_vw_DeviceList t2 ON t2.PanelId = t1.PanelID and t2.DeviceId = t1.ReaderID
WHERE Description LIKE '%' + @Reader + '%'
ORDER BY t1.BadgeID;