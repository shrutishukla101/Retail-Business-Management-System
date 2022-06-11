
SET SERVEROUTPUT ON

/* package name specification: RetailBusiness_Package */
CREATE OR REPLACE PACKAGE RetailBusiness_Package AS 

type cursor1 is ref cursor;

/* question 2: procedures to show the tuples in each table */
procedure show_customers;
procedure show_employees;
procedure show_logs;
procedure show_products;
procedure show_purchases; 

/* question 3: procedure to return the name of the customer as well as every purchase */ 
procedure purchases_made(c_id in customers.cid%type);

/* question 4: function to report the number of customers who have purchased the product identified by the pid */ 
function number_customers(cust_pid IN purchases.pid%type) return NUMBER; 

/* question 5: procedure for adding tuples to the Customers table.*/ 
procedure add_customer(c_id in customers.cid%type, c_name in customers.name%type, c_telephone# in customers.telephone#%type);

/* question 6: procedure for adding tuples to the Purchases table.*/ 
procedure add_purchase(e_id in purchases.eid%type, p_id in purchases.pid%type, c_id in purchases.cid%type, pur_qty in purchases.qty%type, pur_unit_price in purchases.unit_price%type);

end;
/


/* package body */
create or replace package body RetailBusiness_Package as

/* question 2: procedure to show the tuples in employees */
PROCEDURE show_employees
AS
    CURSOR c_emp IS
    SELECT * FROM employees;
    c_emp_rec c_emp%rowtype;

BEGIN
dbms_output.put_line( 'EID' || ',' || 'NAME' || ',' || 'TELEPHONE#' || ',' || 'EMAIL');
 OPEN c_emp;
    LOOP
        FETCH c_emp INTO c_emp_rec; 
        EXIT WHEN c_emp%notfound;
         dbms_output.put_line(c_emp_rec.eid || ',' || c_emp_rec.name || ',' || c_emp_rec.telephone# || ',' ||c_emp_rec.email); 
    END LOOP;
 CLOSE c_emp;
END show_employees;

/* question 2: procedure to show the tuples in customers */
PROCEDURE show_customers
AS
    CURSOR c_cust IS
    SELECT * FROM customers;
    c_cust_rec c_cust%rowtype;

BEGIN
dbms_output.put_line('CID' || ',' || 'NAME' || ',' || 'TELEPHONE#' || ',' ||'VISITS_MADE' || ',' || 'LAST_VISIT_DATE');
 OPEN c_cust;
    LOOP
        FETCH c_cust INTO c_cust_rec; 
        EXIT WHEN c_cust%notfound;
         dbms_output.put_line(c_cust_rec.cid || ',' || c_cust_rec.name || ',' || c_cust_rec.telephone# || ',' ||c_cust_rec.visits_made || ',' || c_cust_rec.last_visit_date); 
    END LOOP;
 CLOSE c_cust;
END show_customers;
      
/* question 2: procedure to show the tuples in products */
PROCEDURE show_products
AS
    CURSOR c_pr IS
    SELECT * FROM products;
    c_pr_rec c_pr%rowtype;

BEGIN
dbms_output.put_line('PID' || ',' || 'NAME' || ',' || 'QOH' || ',' || 'QOH_THRESHOLD' || ',' || 'REGULAR_PRICE' || ',' || 'DISCNT_RATE');
 OPEN c_pr;
    LOOP
        FETCH c_pr INTO c_pr_rec; 
        EXIT WHEN c_pr%notfound;
         dbms_output.put_line(c_pr_rec.pid || ',' || c_pr_rec.name || ',' || c_pr_rec.qoh || ',' ||c_pr_rec.qoh_threshold || ',' || c_pr_rec.regular_price || ',' || c_pr_rec.discnt_rate); 
    END LOOP;
 CLOSE c_pr;
END show_products;
      
/* question 2: procedure to show the tuples in purchases */
PROCEDURE show_purchases
AS
    CURSOR c_pur IS
    SELECT * FROM purchases;
    c_pur_rec c_pur%rowtype;

BEGIN
dbms_output.put_line('PUR#' || ',' || 'EID' || ',' || 'PID' || ',' || 'CID' || ',' || 'PUR_DATE' || ',' || 'QTY' || ',' || 'UNIT_PRICE' || ',' || 'TOTAL' ||','|| 'SAVING');
 OPEN c_pur;
    LOOP
        FETCH c_pur INTO c_pur_rec; 
        EXIT WHEN c_pur%notfound;
         dbms_output.put_line(c_pur_rec.pur# || ',' || c_pur_rec.eid || ',' || c_pur_rec.pid || ',' ||c_pur_rec.cid || ',' || c_pur_rec.pur_date || ',' || c_pur_rec.qty || ',' || 
         c_pur_rec.unit_price || ',' || c_pur_rec.total ||','|| c_pur_rec.saving); 
    END LOOP;
 CLOSE c_pur;
END show_purchases;
      
/* question 2: procedure to show the tuples in logs */
PROCEDURE show_logs
AS
    CURSOR c_log IS
    SELECT * FROM logs;
    c_log_rec c_log%rowtype;

BEGIN
dbms_output.put_line('LOG#' || ',' || 'USER_NAME' || ',' || 'OPERATION' || ',' || 'OP_TIME' || ',' || 'TABLE_NAME' || ',' || 'TUPLE_PKEY');
 OPEN c_log;
    LOOP
        FETCH c_log INTO c_log_rec; 
        EXIT WHEN c_log%notfound;
         dbms_output.put_line(c_log_rec.log# || ',' || c_log_rec.user_name || ',' || c_log_rec.operation || ',' ||c_log_rec.op_time || ',' || c_log_rec.table_name || ',' || c_log_rec.tuple_pkey); 
    END LOOP;
 CLOSE c_log;
END show_logs;


/* question 3,: procedure to return the name of the customer as well as every purchase */
PROCEDURE purchases_made(c_id in customers.cid%type)
      IS
          cursor cursor1 is
            select * from 
                (select name from customers where cid = c_id) a,
                (select * from 
                    (select pid, pur_date, qty, unit_price, total from purchases where cid = c_id)) b;
                    
          c_cid NUMBER;
          invalid_cid EXCEPTION;
      BEGIN
        c_cid:= 0;
        SELECT count(cid) INTO c_cid FROM CUSTOMERS WHERE cid = c_id;
        IF(c_cid = 0) THEN
            RAISE invalid_cid; 
        ELSE      
            dbms_output.put_line( 'name' || ',' || 'pid' || ',' || 'pur_date' || ',' || 'qty' || ',' || 'unit_price' || ',' || 'total');
            for c1 in cursor1
                loop
                    dbms_output.put_line( c1.name || ',' || c1.pid || ',' || c1.pur_date || ',' || c1.qty || ',' || c1.unit_price || ',' || c1.total );
                end loop;
        END IF;
        
     EXCEPTION 
        WHEN invalid_cid  THEN
            dbms_output.put_line('Invalid Customer ID'); 
                        
END purchases_made;


/* question 4: function to report the number of customers who have purchased the product identified by the pid */
FUNCTION number_customers(cust_pid IN purchases.pid%type)
    RETURN NUMBER IS
        num_of_customers NUMBER; 
        c_pid NUMBER;
        invalid_pid EXCEPTION;
        
    BEGIN      
        c_pid:= 0;
        SELECT count(pid) INTO c_pid FROM PURCHASES WHERE pid = cust_pid;
        IF(c_pid = 0) THEN
            RAISE invalid_pid; 
        ELSE
            SELECT count(DISTINCT cid) into num_of_customers FROM purchases WHERE pid = cust_pid;       
            return num_of_customers;  
        
        END IF;
    EXCEPTION 
        WHEN invalid_pid  THEN
        dbms_output.put_line('Invalid purchase ID.'); 
        RETURN 0;
END;

/* question 5: procedure for adding tuples to the Customers table*/
PROCEDURE add_customer(c_id IN CUSTOMERS.CID%TYPE, c_name IN CUSTOMERS.NAME%TYPE, c_telephone# IN CUSTOMERS.TELEPHONE#%TYPE)
      IS
      BEGIN
          INSERT INTO CUSTOMERS VALUES (c_id, c_name, c_telephone#, 1, sysdate);
          commit;
      END;


/* question 6: procedure for adding tuples to the Purchases table */ 

PROCEDURE add_purchase(
e_id in purchases.eid%type,
p_id in purchases.pid%type,
c_id in purchases.cid%type,
pur_qty in purchases.qty%type,
pur_unit_price in purchases.unit_price%type
)
IS
    pur_total PURCHASES.TOTAL%TYPE;
    pur_saving PURCHASES.SAVING%TYPE;
    reg_price PRODUCTS.REGULAR_PRICE%TYPE;
    pr_qoh PRODUCTS.QOH%TYPE;
    insuf_qty exception; 
          
BEGIN
    pur_total :=  pur_qty * pur_unit_price;
    SELECT REGULAR_PRICE INTO reg_price FROM PRODUCTS WHERE PID = p_id;
    pur_saving := (reg_price * pur_qty) - (pur_qty * pur_unit_price);
    SELECT QOH INTO pr_qoh FROM PRODUCTS WHERE PID = p_id;

    IF(pur_qty <= pr_qoh) THEN
    /*Insert new purchase*/
      INSERT INTO PURCHASES VALUES (seqpur#.nextval, e_id, p_id, c_id, sysdate, pur_qty, pur_unit_price, pur_total, pur_saving);
      commit;
    ELSE
      RAISE insuf_qty;
    END IF;
    
    EXCEPTION 
      WHEN insuf_qty THEN
      dbms_output.put_line('Insufficient quantity in stock.');
          
  END add_purchase;


END;
