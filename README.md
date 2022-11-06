# EmailValidator

## Description
As per Salesforce best practice docs: "_Your Pardot prospect database grows over time. To keep your list up to date, practice good database hygiene by checking that all your prospects are engaged. Bad database hygiene affects your scoring and grading and email deliverability, and it can prevent you from reaching your revenue potential. Good database hygiene keeps you connected with the most engaged prospects, protects your sending reputation, and helps increase your ROI. When your database is clean, you can focus on nurturing only the most qualified prospects._"



The idea behind our app is to save Customers some time by using external services which would provide an email scoring based on publicly available information on the Web.

The solution would leverage **Pardot API v5** and **External Actions** to integrate with external email validation services, initially EmailRep.

EmailRep uses hundreds of factors like domain age, traffic rankings, presence on social media sites, professional networking sites, personal connections, public records, deliverability, data breaches, dark web credential leaks, phishing emails, threat actor emails, and more to answer these types of questions:

* Is this email risky?
* Is this a throwaway account?
* What kind of online presence does this email have?
* Is this a trustworthy sender?

Our value proposition is:
* Save Pardot admin time
* Increase your database hygiene by deleting inactive/low reputation prospects
* Decrease your bounce rates and increase your ROI