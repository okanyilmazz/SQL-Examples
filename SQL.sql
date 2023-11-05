--1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
SELECT product_name, quantity_per_unit FROM products;

--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
SELECT product_id, product_name FROM products 
WHERE discontinued = 0;

--3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
SELECT product_id, product_name FROM products 
WHERE discontinued = 1;

--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id, product_name,unit_price FROM products
WHERE unit_price < 20;

--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT product_id, product_name, unit_price FROM products
WHERE unit_price BETWEEN 15 AND 25;

--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
SELECT product_name, units_on_order, units_in_stock FROM products
WHERE units_in_stock < units_on_order;

--7. İsmi `a` ile başlayan ürünleri listeleyeniz.
SELECT * FROM products 
WHERE LOWER(product_name) LIKE 'a%';

--8. İsmi `i` ile biten ürünleri listeleyeniz.
SELECT * FROM products
WHERE LOWER(product_name) LIKE '%i';

--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
SELECT product_name, unit_price, (unit_price + (unit_price * 0.18)) AS "UnitPriceKDV" FROM products;

--10. Fiyatı 30 dan büyük kaç ürün var?
SELECT COUNT(*) FROM products
WHERE unit_price > 30;

--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
SELECT LOWER(product_name) FROM products
ORDER BY unit_price DESC;

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
SELECT first_name || ' ' || last_name AS "AD SOYAD" FROM employees;

--13. Region alanı NULL olan kaç tedarikçim var?
SELECT COUNT(*) FROM suppliers 
WHERE region IS NULL;

--14. a.Null olmayanlar?
SELECT COUNT(*) FROM suppliers
WHERE region IS NOT NULL;

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
SELECT ('TR ' || UPPER(product_name)) FROM products;

--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
SELECT ('TR ' || product_name),unit_price FROM products
WHERE unit_price < 20;

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name, unit_price FROM products
WHERE unit_price = (SELECT MAX(unit_price) FROM products)

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC;
limit 10

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT product_name, unit_price FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
SELECT SUM(units_in_stock * unit_price) FROM products
WHERE units_in_stock > 0;

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
SELECT COUNT(*) FROM products
WHERE units_in_stock > 0 AND discontinued = 1;

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT p.product_name, c.category_name FROM products AS p
INNER JOIN categories AS C
ON C.category_id = p.category_id;

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT c.category_name, AVG(p.unit_price) FROM products AS P
INNER JOIN categories AS C
ON C.category_id = p.category_id
GROUP BY category_name;

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
SELECT P.product_name, P.unit_price, C.category_name FROM products AS P
INNER JOIN categories AS C
ON C.category_id = P.category_id
WHERE unit_price = (SELECT MAX(unit_price) FROM products);

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
SELECT P.product_name, C.category_name, S.company_name FROM products AS P
INNER JOIN categories AS C
ON C.category_id = P.category_id
INNER JOIN suppliers AS S
ON S.supplier_id = P.supplier_id
WHERE units_on_order = (SELECT MAX(units_on_order) FROM products);

--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `PhONe`) 
--almak için bir sorgu yazın.

SELECT p.product_id, p.product_name, s.company_name, s.phone  
FROM products AS p
JOIN suppliers AS s 
ON p.supplier_id = s.supplier_id 
WHERE units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.ship_address, e.first_name || ' ' || e.last_name AS "Ad Soyad", order_date FROM orders AS o
JOIN employees AS e
ON e.employee_id = o.employee_id
WHERE order_date >= '1998-03-01' AND order_date <= '1998-03-31';

--28. 1997 yılı şubat ayında kaç siparişim var?
SELECT count (*) FROM orders
WHERE DATE_PART('year', order_date) = 1997 AND DATE_PART('month',order_date) = 2;

--29. LONdON şehrinden 1998 yılında kaç siparişim var?
SELECT count (*) FROM orders 
WHERE ship_city = 'London' AND DATE_PART('year', order_date) = 1998;

--30. 1997 yılında sipariş veren müşterilerimin cONtactname ve telefON numarası
SELECT c.contact_name, c.phone, o.order_date  FROM orders AS o
JOIN customers AS c
ON c.customer_id = o.customer_id
WHERE DATE_PART('year', order_date) = 1997
ORDER BY o.order_date;

--31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT * FROM orders
WHERE freight > 40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT o.ship_city, c.company_name, c.contact_name FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE o.freight > 40;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT o.order_date, o.ship_city, UPPER(e.first_name || ' ' || e.last_name) FROM orders AS o
JOIN employees AS e
ON o.employee_id = e.employee_id
WHERE DATE_PART('year', order_date) = 1997
ORDER BY order_date;

--34. 1997 yılında sipariş veren müşterilerin cONtactname i, ve telefON numaraları 
--( telefON formatı 2223322 gibi olmalı )
SELECT c.contact_name, regexp_replace(c.phone, '[^0-9]', '', 'g') FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE DATE_PART('year', order_date) = 1997
ORDER BY order_date;

--35. Sipariş tarihi, müşteri cONtact name, çalışan ad, çalışan soyad
SELECT o.order_date, c.cONtact_name, e.first_name, e.last_name FROM orders AS o
JOIN customers AS c 
ON o.customer_id = c.customer_id
JOIN employees AS e 
ON e.employee_id = o.employee_id;

--36. Geciken siparişlerim?
SELECT * FROM orders
WHERE required_date < shipped_date;

--37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT o.required_date AS "Geciken Tarih", c.company_name AS "Müşteri Adı" FROM orders AS o
JOIN customers AS c
ON c.customer_id = o.customer_id
WHERE required_date < shipped_date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN categories AS c
ON p.category_id = c.category_id
WHERE od.order_id = 10248;

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.company_name FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN suppliers AS s
ON s.supplier_id = p.supplier_id
WHERE od.order_id = 10248;

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT e.first_name, p.product_name, od.quantity FROM employees AS e
JOIN orders AS o
ON o.employee_id = e.employee_id
JOIN order_details AS od
ON o.order_id = od.order_id
JOIN products AS p
ON p.product_id = od.product_id
WHERE e.employee_id = 3 AND DATE_PART('year',o.order_date) = 1997;

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, e.first_name, e.last_name FROM orders AS o
JOIN order_details AS od
ON od.order_id = o.order_id
JOIN employees AS e
ON e.employee_id = o.employee_id
WHERE od.quantity = (SELECT MAX(quantity) FROM order_details) AND DATE_PART('year', o.order_date) = 1997;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name, e.last_name, SUM(od.quantity) AS total_quantity FROM orders AS o
JOIN order_details AS od
ON od.order_id = o.order_id
JOIN employees AS e
ON e.employee_id = o.employee_id
WHERE DATE_PART('year', o.order_date) = 1997
GROUP BY e.first_name,e.employee_id
ORDER BY total_quantity DESC Limit 1;

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name, p.unit_price ,c.category_name FROM products AS p
JOIN categories AS c
ON p.category_id = c.category_id
WHERE p.unit_price = (SELECT MAX(unit_price) FROM products);

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name, e.last_name,o.order_date,o.order_id FROM orders AS o
JOIN employees AS e
ON o.employee_id = e.employee_id
ORDER BY o.order_date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, AVG(od.unit_price) AS average_price
FROM order_details AS od
JOIN orders AS o
ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, (od.quantity * od.unit_price) AS "Toplam Satış Miktarı" FROM orders AS o
JOIN order_details AS od
ON od.order_id = o.order_id
JOIN products AS p
ON od.product_id = p.product_id
JOIN categories AS c
ON p.category_id = c.category_id
WHERE DATE_PART('month',order_date) = 1;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id,(quantity * unit_price) AS "Total Price", (SELECT AVG (unit_price*quantity) AS "Total Average" FROM order_details) FROM order_details
WHERE (quantity * unit_price) > (
    SELECT AVG(quantity * unit_price)
    FROM order_details
);

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_id, p.product_name, c.category_name, s.company_name, od.quantity FROM order_details AS od
JOIN products AS p
on p.product_id = od.product_id
JOIN categories AS c
ON c.category_id = p.category_id
JOIN suppliers AS s
ON s.supplier_id = p.supplier_id
WHERE od.quantity = (SELECT MAX(quantity) FROM order_details)

--49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT(ship_country)) FROM orders
GROUP BY ship_country

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

--1. Anlaşılan soruya göre cevap;
SELECT e.first_name, SUM(od.quantity * od.unit_price)
FROM employees AS e
JOIN orders AS o ON o.employee_id = e.employee_id
JOIN order_details AS od ON o.order_id = od.order_id
WHERE e.employee_id = 3 AND o.order_date > (SELECT DATE_TRUNC('MONTH', CURRENT_DATE) - INTERVAL '1 month') AND o.order_date < CURRENT_DATE
GROUP BY e.first_name;

--2. Anlaşılan soruya göre cevap;
SELECT e.first_name, SUM(od.quantity*od.unit_price) FROM employees AS e
JOIN orders AS o
ON o.employee_id = e.employee_id
JOIN order_details AS od
ON o.order_id = od.order_id
WHERE e.employee_id = 3 AND o.order_date < CURRENT_DATE
GROUP BY e.first_name

--51. Hangi ülkeden kaç müşterimiz var
SELECT o.ship_country, COUNT(DISTINCT(c.customer_id)) FROM orders AS o
INNER JOIN customers AS c
ON c.customer_id = o.customer_id
GROUP BY o.ship_country

--52. 10 numaralı ID ye sahip ürünümden sON 3 ayda ne kadarlık ciro sağladım?

--1. YÖNTEM
SELECT o.order_date, SUM(od.quantity * od.unit_price) FROM products AS p
JOIN order_details AS od
ON od.product_id = p.product_id
JOIN orders AS o
ON o.order_id = od.order_id
WHERE p.product_id = 10
GROUP BY o.order_date
ORDER BY o.order_date DESC Limit 3

--2. YÖNTEM
SELECT o.order_date, SUM(od.quantity * od.unit_price)
FROM products AS p
JOIN order_details AS od 
ON od.product_id = p.product_id
JOIN orders AS o
ON o.order_id = od.order_id
WHERE p.product_id = 10
AND o.order_date >= (o.order_date - INTERVAL '2 months')
GROUP BY o.order_date
ORDER BY o.order_date DESC
LIMIT 3;

--53. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.employee_id ,COUNT(*) FROM orders AS o
JOIN employees AS e
ON e.employee_id = o.employee_id
GROUP BY e.employee_id

--54. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT c.customer_id,o.order_id FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL

--55. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT company_name, contact_name, address, city FROM customers
WHERE country = 'Brazil'

--56. Brezilya’da olmayan müşteriler
SELECT company_name, contact_name, address, city, country FROM customers
WHERE country != 'Brazil'

--57. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT company_name, contact_name, address, city FROM customers
WHERE country='Spain' OR country = 'France' OR country='Germany'

--58. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers
WHERE fax IS NULL

--59. LONdra’da ya da Paris’de bulunan müşterilerim
SELECT company_name, contact_name, address, city FROM customers
WHERE city = 'London' OR city='Paris'

--60. Hem Mexico D.F’da ikamet eden HEM DE CONtactTitle bilgisi ‘owner’ olan müşteriler
SELECT * FROM customers
WHERE city = 'México D.F.' AND contact_title = 'Owner'

--61. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name, unit_price FROM products
WHERE product_name LIKE 'C%'

--62. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name, last_name, birth_date FROM employees
WHERE first_name LIKE 'A%'

--63. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name FROM customers
WHERE UPPER(company_name) LIKE '%RESTAURANT%'

--64. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name, unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100

--65. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id, order_date FROM orders
WHERE DATE_PART('month',order_date) BETWEEN 7 AND  12 AND DATE_PART('year',order_date) = 1996

--66. Müşterilerimi ülkeye göre sıralıyorum:
SELECT * FROM customers 
ORDER BY country

--67. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sONuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC

--68. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sONuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC, units_in_stock ASC;

--69. 1 Numaralı kategoride kaç ürün vardır..?
SELECT SUM(units_in_stock) FROM products
WHERE category_id = 1

--70. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT(ship_country)) FROM orders
