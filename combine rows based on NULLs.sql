/*Combine rows to remove nulls or swap row values if not null */

/*
Input table:

ID  Account Contact
-----------------------
ID1 A11 C11
ID1 A12 NULL
ID2 A21 NULL
ID2 A22 C22
ID3 A31 C31
ID3 A32 C32
  
Output needs to be like this

ID  Account Contact 
-----------------------
ID1 A12 C11
ID2 A21 C22
ID3 A31 C32
ID3 A32 C31


For IDs with one NULL and one non-NULL Contact: The output row should 
combine the Account from the row with the NULL Contact and the Contact from the row with the non-NULL Contact.

 
For IDs with two non-NULL Contacts: The output should show both records, but with the Contact values swapped


*/ 

/****  SOLUTION 1 *********/

SELECT 
  t1.ID,
  t1.Account,
  t2.Contact
FROM MyTable AS t1
JOIN MyTable AS t2
  ON t1.ID = t2.ID
  AND COALESCE(t1.Contact, '') <> t2.Contact;

/* COALESCE(t1.Contact, '') <> t2.Contact is like a double filter. It takes care of records where contacts match and also records where t2.contact is null. */

/*** SOLUTION 2 ***************/
/* a single scan of the base table by using window functions */

SELECT
  mt.ID,
  mt.Account,
  CASE WHEN mt.rn = 1 THEN mt.NextContact ELSE mt.PrevContact END AS Contact
FROM (
    SELECT *,
      LAG(mt.Contact)  OVER (PARTITION BY mt.ID ORDER BY mt.Contact) AS PrevContact,
      LEAD(mt.Contact) OVER (PARTITION BY mt.ID ORDER BY mt.Contact) AS NextContact,
      ROW_NUMBER()     OVER (PARTITION BY mt.ID ORDER BY mt.Contact) AS rn
    FROM MyTable mt
) mt
WHERE rn = 1 OR PrevContact IS NOT NULL;


