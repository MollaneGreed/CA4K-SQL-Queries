--Connect to SQL database and run against Live Config
    SELECT 
      o.OperLoginName
      ,o.OperatorID
      ,r.RoleName
      ,o.RoleID
      ,o.OperFName
      ,o.OperLName
      ,o.Enabled
      ,o.EmailID
      ,o.LastLoggedIn
      ,o.LastLoggedInUncName
      ,o.LogoffTime
      ,o.LastUpdated
      ,o.IsGlobalAdministrator
      ,o.CanChangeThreatLevel
      ,o.UseLegacyDisplay
      ,o.ManualPrivileges
      ,o.DisableLogoff
      ,o.EventCount
      ,o.LastOperator
      ,o.LastWorkStation
    FROM Operators AS o
    LEFT JOIN Roles AS r ON o.RoleID = r.RoleID
    ORDER by o.OperLoginName;

-- Get a list of Readers and list who last updated it
    SELECT
        r.RdrNo,
        r.ReaderName,
        r.LastUpdated,
        o.OperLoginName,
        r.LastOperator
    FROM Reader r
    Join Operators AS o ON r.LastOperator = o.OperatorID
    ORDER BY r.LastUpdated DESC;

--Show 5 Readers with columns of data
    SELECT TOP 5
        *
    FROM Reader;

  

