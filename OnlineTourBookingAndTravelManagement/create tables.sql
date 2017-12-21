CREATE OR REPLACE PROCEDURE SIX_MONTH_HOTEL /*HOTEL BOOKED IN PAST 6 MONTHS*/
IS
CURSOR HOTEL_DETAILS IS 
 
  SELECT NAME, HOTELNAME
  FROM HOTEL H , HOTEL_BOOKING_DETAILS H2, PERSON P
  WHERE TRUNC(H2.HOTEL_BOOKING_DATE)>=TRUNC(SYSDATE-180)  AND H2.HOTEL_ID=H.HOTEL_ID AND P.PERSON_ID=H2.person_ID;

THISNAME VARCHAR(30);

THISHOTELNAME VARCHAR(200);

BEGIN
OPEN HOTEL_DETAILS;

LOOP
  FETCH HOTEL_DETAILS INTO  THISNAME, THISHOTELNAME;
    EXIT WHEN (HOTEL_DETAILS%NOTFOUND);
   DBMS_OUTPUT.PUT_LINE('Name of customer is:'||THISNAME||' and Name of hotel is: '||THISHOTELNAME);
END LOOP;
CLOSE HOTEL_DETAILS;
END;
/

SET SERVEROUTPUT ON
EXECUTE SIX_MONTH_HOTEL;


create or replace procedure city_visit
IS
cursor cities is 
select p.name person_name,c1.city_name,a.name , t.tour_name
from  customer c,person p,travel_agency a,book_tour b, tour_package t ,cities c1,package_cities p1
where  b.package_id=t.package_id and  t.company_id=a.company_id and a.name='&agencyname' and 
t.tour_name='&packagename' and c.person_id=b.person_id and
c.person_id=p.person_id and t.package_id=p1.package_id and p1.city_id=c1.city_id; 
cityy  cities%rowtype;
begin 
open cities;
loop
fetch cities into cityy;
exit when cities%NOTFOUND;
dbms_output.put_line('travel agency name:  '|| cityy.name|| '  and 
citynames:'||cityy.city_name||' and package name: '||cityy.tour_name||'  and booking is under: '||cityy.person_name);
end loop;
close cities;
end;
/

EXECUTE city_visit;
/*try entering TOON-TOWN travels for agencyname and DELUXE for packagename when prompted */


Create or replace procedure TOP_PACKAGE  /*SHOWS THE PACKAGE WHICH IS BOOKED BY MORE NO OF PEOPLE and the customer names who booked that package */

IS
CURSOR PACKAGE IS 
select t1.tour_name, p.name from (select pkg_id
from
(
select p.package_id pkg_id,
count(*) cnt
from tour_package p, book_tour b 
where b.transaction_id not in (select c.transaction_id from cancel_tour c) and 
p.package_id=b.package_id
group by p.package_id
)
where
cnt=(
select max(cnt) from 
(
select p.package_id pkg_id,
count(*) cnt
from tour_package p, book_tour b 
where b.transaction_id not in (select c.transaction_id from cancel_tour c) and 
p.package_id=b.package_id
group by p.package_id
)
))t, book_tour b,person p ,tour_package t1
where t.pkg_id=b.package_id and  p.person_id=b.person_id and t1.package_id=t.pkg_id;

thistourname varchar(150);
thisname varchar(200);
BEGIN
OPEN package;

LOOP
  FETCH package INTO thistourname,thisname;
  EXIT WHEN (package%NOTFOUND);

   dbms_output.put_line('tour name:'|| THIStourNAME||' booking is under: '|| THISname);
END LOOP;
CLOSE package;
END;

/

SET SERVEROUTPUT ON
EXECUTE top_package;