SELECT TOP (1000) [templateID]
      ,[subject]
      ,[body]
      ,[allowSNPP]
      ,[allowEmail]
      ,[allowSMS]
      ,[include]
  FROM [CardAccessLiveConfigurationUS].[dbo].[MessageTemplates]
  WHERE [subject] LIKE '%BG %'