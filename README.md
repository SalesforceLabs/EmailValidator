# Email Validator for Pardot

## Description
As per Salesforce best practice docs: "_Your Pardot prospect database grows over time. To keep your list up to date, practice good database hygiene by checking that all your prospects are engaged. Bad database hygiene affects your scoring and grading and email deliverability, and it can prevent you from reaching your revenue potential. Good database hygiene keeps you connected with the most engaged prospects, protects your sending reputation, and helps increase your ROI. When your database is clean, you can focus on nurturing only the most qualified prospects._"



The idea behind our app is to save Customers some time by using external services which would provide an email scoring based on publicly available information on the Web.

The solution would leverage **Pardot API v5** and **External Actions** to integrate with external email validation services.
For the time being, the following APIs have been integrated with Email Validator for Pardot (alphabetically sorted):
* **Abstract Email Validation**: https://www.abstractapi.com/api/email-verification-validation-api
* **Email Rep**: https://emailrep.io/
* Twilio's **Sendgrid**: https://sendgrid.com/solutions/email-api/email-address-validation-api/
* **Zerobounce**: https://www.zerobounce.net/docs/email-validation-api-quickstart#validate_emails__v2__

**NOTE:** You need to have an API key from at least one of the above services to use Email Validator for Pardot (all of them provide free tiers to be able to test it).

## Value Proposition
Our value proposition is:
* Save Pardot Admin time
* Increase your database hygiene by deleting inactive/low reputation prospects
* Decrease your bounce rates and increase your ROI
