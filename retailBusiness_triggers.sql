SET SERVEROUTPUT ON

/* question 6: trigger for inserting a tuple into the Purchases table */
create or replace trigger purchases_add 
after insert on purchases
for each row
declare
qty products.qoh%type;
threshold products.qoh_threshold%type;
today customers.last_visit_date%type;
qoh_updated products.qoh%type;

begin
	update products 
		set qoh = qoh - :new.qty where pid = :new.pid;

	select last_visit_date into today from customers where cid = :new.cid;
	if (to_char(today, 'YYYY') = to_char(sysdate, 'YYYY') and to_char(today, 'MON') = to_char(sysdate, 'MON') and to_char(today, 'DD') = to_char(sysdate, 'DD'))
	then
		NULL;
	else
		update customers
			set visits_made = visits_made + 1 where cid = :new.cid;
		update customers
			set last_visit_date = sysdate where cid = :new.cid;
	end if;
	select qoh, qoh_threshold into qty, threshold from products where pid = :new.pid;
	if(qty < threshold) then
		dbms_output.put_line('The current qoh of the product is below the required threshold and new supply is required');
		update products 
			set qoh = threshold + 10 where pid = :new.pid;
            
            select qoh into qoh_updated from products where pid= :new.pid;            
            dbms_output.put_line('The new value of qoh after supply is: ' || qoh_updated );
	end if;
end;
/



/* question 7.1: trigger for inserting a tuple into the Customers table */
create or replace trigger insert_customers
after insert on customers
for each row
begin
insert into logs values (seqlog#.nextval, user, 'insert', sysdate, 'customers', :new.cid);
end;
/
show errors

/* question 7.2 trigger for updating the last_visit_date attribute of the Customers table */
create or replace trigger update_lastvisitdate_customers 
after update of last_visit_date on customers
for each row
begin
insert into logs values (seqlog#.nextval, user, 'update', sysdate, 'customers', :old.cid);
end;
/
show errors

/* question 7.3: trigger for updating the visits_made attribute of the Customers table */
create or replace trigger update_visitsmade_customers
after update of visits_made on customers
for each row
begin
insert into logs values (seqlog#.nextval, user, 'update', sysdate, 'customers', :old.cid);
end;
/
show errors

/* question 7.4: trigger for inserting a tuple into the Purchases table */
create or replace trigger insert_purchases
after insert on purchases
for each row
begin
insert into logs values (seqlog#.nextval, user, 'insert', sysdate, 'purchases', :new.pur#);
end;
/
show errors

/* question 7.5: trigger for updating the qoh attribute of the Products table */
create or replace trigger update_products 
after update of qoh on products
for each row
begin
insert into logs values (seqlog#.nextval, user, 'update', sysdate, 'products', :old.pid);
end;
/
show errors


