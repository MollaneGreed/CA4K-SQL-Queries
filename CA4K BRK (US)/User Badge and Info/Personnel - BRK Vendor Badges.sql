SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    P.[LastName],
    B.[Badge],
    CASE
        WHEN B.[Enabled] = '1' THEN 'Enabled'
        WHEN B.[Enabled] = '0' THEN 'Disabled'
    END 'Enabled'	
  FROM [CardAccessLiveConfigurationUS].[dbo].[ca_vw_PersonnelInfo] vw_pi
  JOIN [CardAccessLiveConfigurationUS].[dbo].[Badge] B on B.Badge = vw_pi.BadgeID
  JOIN [CardAccessLiveConfigurationUS].[dbo].[Person] P on P.PersonID = B.PersonID
  WHERE vw_pi.CompanyName LIKE 'VENDOR'