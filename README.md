# EFSonic_Financial_Transactions

📌 Query: Financial Transactions Analysis (EFSonicData)

Description
This query generates a financial transactions report for a specific organization within a given date range, with multi-language support. It shows account balances, opening balance, debit, and credit movements.

Parameters

@Language → Report language (used to fetch localized descriptions).

@FromDate, @ToDate → Date range filter.

@OrgID → Organization ID filter.

Key Features

Retrieves financial transactions per account and cost center.

Uses LAG() window function to calculate:

Opening Balance (previous balance before transaction).

Credit (decrease in balance).

Debit (increase in balance).

Joins with Organization, Cost Center, and Chart of Accounts language tables to display descriptive names.

Final output includes user-friendly labels (e.g., shows "Opening Balance" when no opening value exists).

Output Columns

OrganizationCodeName → Organization code + description.

CostCenterName → Cost center description.

AccountName → Account description.

TransDate → Transaction date.

Opening → Opening balance (or labeled "Opening Balance").

Balance → Current balance.

Credit → Amount credited (balance decrease).

Debit → Amount debited (balance increase).

Use Case
✅ Suitable for financial reporting and audit trails, where organizations need to monitor account movements (debit/credit) over time with multilingual support.
