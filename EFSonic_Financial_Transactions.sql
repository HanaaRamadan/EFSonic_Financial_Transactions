DECLARE  @Language INT = 1  ,
         @FromDate DATETIME = '2023-012-07',
         @ToDate DATETIME = '2024-01-05',
         @OrgID INT = 8;
		 
		 select x.OrganizationCodeName,x.CostCenterName,x.AccountName,x.TransDate,case when x.OpeningBalance is null then
		 'Opening Balance' else cast (x.OpeningBalance as varchar(20)) end as 'Opening',x.Balance,x.Credit,x.Debit
		 from (
	
SELECT [dbo].[Organization].[OrganizationCode]+ '-'+[dbo].[OrganizationLanguage].Description AS [OrganizationCodeName] , 
  [dbo].[FinanceCostCenterLanguage].Description AS [CostCenterName] ,  [dbo].[FinanceChartOfAccountLanguage].Description AS [AccountName],  
  [dbo].[FinanceAccountCostCenter].CreatedDate AS [TransDate] , 
  lag([dbo].[FinanceAccountCostCenter].Balance) OVER (PARTITION BY [dbo].[FinanceAccountCostCenter].AccountID ORDER BY [dbo].[FinanceAccountCostCenter].CreatedDate) AS [OpeningBalance]
  ,[dbo].[FinanceAccountCostCenter].[Balance] AS [Balance] ,
  CASE 
   WHEN LAG([dbo].[FinanceAccountCostCenter].Balance, 1) OVER (PARTITION BY [dbo].[FinanceAccountCostCenter].AccountID ORDER BY [dbo].[FinanceAccountCostCenter].CreatedDate) > [dbo].[FinanceAccountCostCenter].[Balance]
   THEN LAG([dbo].[FinanceAccountCostCenter].Balance, 1) OVER (PARTITION BY [dbo].[FinanceAccountCostCenter].AccountID ORDER BY [dbo].[FinanceAccountCostCenter].CreatedDate) - [dbo].[FinanceAccountCostCenter].[Balance]
   ELSE 0
   END AS [Credit],
   CASE 
   WHEN LAG([dbo].[FinanceAccountCostCenter].Balance, 1) OVER (PARTITION BY [dbo].[FinanceAccountCostCenter].AccountID ORDER BY [dbo].[FinanceAccountCostCenter].CreatedDate) < [dbo].[FinanceAccountCostCenter].[Balance]
   THEN [dbo].[FinanceAccountCostCenter].[Balance] - LAG([dbo].[FinanceAccountCostCenter].Balance, 1) OVER (PARTITION BY [dbo].[FinanceAccountCostCenter].AccountID ORDER BY [dbo].[FinanceAccountCostCenter].CreatedDate)
   ELSE 0
   END AS [Debit] 
  FROM [dbo].[FinanceAccountCostCenter]

  INNER JOIN [dbo].[Organization] ON [dbo].[Organization].[OrganizationID]=[dbo].[FinanceAccountCostCenter].[OrganizationID]
  INNER JOIN [dbo].[OrganizationLanguage]  ON [dbo].[OrganizationLanguage].[OrganizationID] = [dbo].[Organization].[OrganizationID] and OrganizationLanguage.LanguageID=@Language
  INNER JOIN [dbo].[FinanceCostCenterLanguage]  ON [dbo].[FinanceCostCenterLanguage].[CostCenterID] = [dbo].[FinanceAccountCostCenter].[CostCenterID] AND FinanceCostCenterLanguage.LanguageID =@Language
  INNER JOIN [dbo].[FinanceChartOfAccountLanguage]  ON [dbo].[FinanceChartOfAccountLanguage].[AccountID] = [dbo].[FinanceAccountCostCenter].[AccountID] AND FinanceChartOfAccountLanguage.LanguageID=@Language

    WHERE ([dbo].[FinanceAccountCostCenter].CreatedDate >= @FromDate) AND 
	     ([dbo].[FinanceAccountCostCenter].CreatedDate <= @ToDate)   AND 
		  ([dbo].[Organization].OrganizationID = @OrgID )

		  )X
		  ORDER BY x.TransDate
		 
