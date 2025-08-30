# Business Central W1 Repository

This repository holds the current W1 version of the Buisness Central Apps.

The purpose is to quickly be able to compare every version to find changes and to be used by
the GitHub Coding Agent to analyze the the apps to better extend the functionality.


## Structure

This repository contains multible applications, structured as follows:

- Each application is in its own folder, named after the application.
- Each application folder contains a 'source' folder with all the source files for that app.
- The 'source' folder contains a app.json that defines the app and its dependencies.


### List of Apps in this Repository


| App Name                                         | Path                                                        |
|--------------------------------------------------|-------------------------------------------------------------|
| Application                                      | Application/Source/Application                              |
| API Reports - Finance                            | APIReportsFinance/Source/API Reports - Finance              |
| APIV1                                            | APIV1/Source/_Exclude_APIV1_                                |
| APIV2                                            | APIV2/Source/_Exclude_APIV2_                                |
| Audit File Export                                | AuditFileExport/Source/Audit File Export                    |
| Bank Account Reconciliation With AI              | BankAccRecWithAI/Source/Bank Account Reconciliation With AI |
| Bank Deposits                                    | BankDeposits/Source/_Exclude_Bank Deposits                  |
| Base Application                                 | BaseApp/Source/Base Application                             |
| Business Foundation                              | BusinessFoundation/Source/Business Foundation               |
| Client AddIns                                    | ClientAddIns/Source/_Exclude_ClientAddIns_                  |
| Company Hub                                      | CompanyHub/Source/Company Hub                               |
| Contoso Coffee Demo Dataset                      | ContosoCoffeeDemoDataset/Source/Contoso Coffee Demo Dataset |
| Create Product Information With Copilot          | CreateProductInformationWithCopilot/Source/Create Product Information With Copilot |
| Dynamics BC Excel Reports                        | ExcelReports/Source/Dynamics BC Excel Reports               |
| E-Document Core                                  | EDocument Core/Source/E-Document Core                       |
| E-Document Connector - Avalara                   | EDocumentConnectors/Avalara/Source/E-Document Connector - Avalara |
| E-Document Connector - B2Brouter                 | EDocumentConnectors/B2Brouter/Source/E-Document Connector - B2Brouter |
| E-Document Connector - Continia                  | EDocumentConnectors/Continia/Source/E-Document Connector - Continia |
| E-Document Connector - Logiq                     | EDocumentConnectors/Logiq/Source/E-Document Connector - Logiq |
| E-Document Connector - Pagero                    | EDocumentConnectors/Pagero/Source/E-Document Connector - Pagero |
| Email - Current User Connector                   | Email - Current User Connector/Source/Email - Current User Connector |
| Email - Microsoft 365 Connector                  | Email - Microsoft 365 Connector/Source/Email - Microsoft 365 Connector |
| Email - Outlook REST API                         | Email - Outlook REST API/Source/Email - Outlook REST API     |
| Email - SMTP API                                 | Email - SMTP API/Source/Email - SMTP API                     |
| Email - SMTP Connector                           | Email - SMTP Connector/Source/Email - SMTP Connector         |
| Enforced Digital Vouchers                        | EnforcedDigitalVouchers/Source/Enforced Digital Vouchers     |
| ESG Statistical Accounts Demo Tool               | ESGStatisticalAccountsDemoTool/Source/ESG Statistical Accounts Demo Tool |
| Essential Business Headlines                     | EssentialBusinessHeadlines/Source/Essential Business Headlines |
| EU 3-Party Trade Purchase                        | EU3PartyTradePurchase/Source/EU 3-Party Trade Purchase       |
| ExcelReports                                     | ExcelReports/Source/Dynamics BC Excel Reports                |
| External File Storage - Azure Blob Service Connector | External File Storage - Azure Blob Service Connector/Source/External File Storage - Azure Blob Service Connector |
| External File Storage - Azure File Service Connector | External File Storage - Azure File Service Connector/Source/External File Storage - Azure File Service Connector |
| External File Storage - SharePoint Connector      | External File Storage - SharePoint Connector/Source/External File Storage - SharePoint Connector |
| ExternalEvents                                   | ExternalEvents/Source/_Exclude_Business_Events_              |
| Field Service Integration                        | FieldServiceIntegration/Source/Field Service Integration     |
| Intrastat                                        | Intrastat/Source/Intrastat Core                             |
| Late Payment Prediction                          | LatePaymentPredictor/Source/Late Payment Prediction          |
| Master Data Management                           | MasterDataManagement/Source/_Exclude_Master_Data_Management  |
| MicrosoftUniversalPrint                          | MicrosoftUniversalPrint/Source/Universal Print Integration   |
| OnPrem Permissions                               | Onprem Permissions/Source/OnPrem Permissions                 |
| Payment Practices                                | PaymentPractices/Source/Payment Practices                    |
| PayPal Payments Standard                         | PayPalPaymentsStandard/Source/Payment Links to PayPal        |
| Plan Configuration                               | PlanConfiguration/Source/_Exclude_PlanConfiguration_         |
| PowerBI Reports                                  | PowerBIReports/Source/PowerBI Reports                        |
| Recommended Apps                                 | RecommendedApps/Source/Recommended Apps                      |
| Report Layouts                                   | ReportLayouts/Source/_Exclude_ReportLayouts                  |
| Review General Ledger Entries                    | ReviewGLEntries/Source/Review General Ledger Entries         |
| SAF-T                                            | SAF-T/Source/SAF-T                                          |
| Sales and Inventory Forecast                     | SalesAndInventoryForecast/Source/Sales and Inventory Forecast |
| Sales Lines Suggestions                          | SalesLinesSuggestions/Source/Sales Lines Suggestions         |
| Send remittance advice by email                  | UKSendRemittanceAdvice/Source/Send remittance advice by email |
| Send To Email Printer                            | SendToEmailPrinter/Source/Send To Email Printer              |
| Service Declaration                              | ServiceDeclaration/Source/Service Declaration                |
| Simplified Bank Statement Import                 | SimplifiedBankStatementImport/Source/Simplified Bank Statement Import |
| Statistical Accounts                             | StatisticalAccounts/Source/Statistical Accounts              |
| Subscription Billing                             | SubscriptionBilling/Source/Subscription Billing              |
| Sustainability                                   | Sustainability/Source/Sustainability                        |
| Sustainability Contoso Coffee Demo Dataset        | SustainabilityContosoCoffeeDemoDataset/Source/Sustainability Contoso Coffee Demo Dataset |
| System Application                               | System Application/Source/System Application                 |
| VAT Group Management                             | VATGroupManagement/Source/VAT Group Management               |


The main apps are:
- Application
- Base Application
- Business Foundation
- System Application