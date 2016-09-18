select * from tab;
select * from major;
=======CREATE=======
DROP SEQUENCE account_seq;
DROP SEQUENCE p_order_seq;
DROP SEQUENCE bom_seq;
DROP SEQUENCE sr_book_seq;
DROP SEQUENCE item_seq;
DROP SEQUENCE pro_directions_seq;
DROP SEQUENCE inventory_seq;
CREATE SEQUENCE account_seq START with 1000 increment by 1 nocache nocycle;
CREATE SEQUENCE p_order_seq START with 1000 increment by 1 nocache nocycle;
CREATE SEQUENCE bom_seq START with 1000 increment by 1 nocache nocycle;
CREATE SEQUENCE sr_book_seq START with 1000 increment by 1 nocache nocycle;
CREATE SEQUENCE item_seq START with 1000 increment by 1 nocache nocycle;
CREATE SEQUENCE pro_directions_seq START with 1000 increment by 1 nocache nocycle;
CREATE SEQUENCE inventory_seq START with 1000 increment by 1 nocache nocycle;

DROP TABLE item CASCADE CONSTRAINT;
CREATE TABLE item(
	item_seq INT CONSTRAINT item_pk PRIMARY KEY,
	item_name 		VARCHAR2(20) NOT NULL,
	division 		VARCHAR2(20) NOT NULL,
	defective_rate	VARCHAR2(20) ,
	lead_time 		VARCHAR2(20)
);
insert into item(item_seq, item_name, division, defective_rate, lead_time) values(item_seq.nextval,'A','PART','5','30');
DROP TABLE Member CASCADE CONSTRAINT;
CREATE TABLE Member (
   mem_id VARCHAR2(20) CONSTRAINT member_pk PRIMARY KEY,
   pw VARCHAR2(20) NOT NULL,
   name VARCHAR2(20) NOT NULL,
   gender VARCHAR2(10) NOT NULL,
   reg_date VARCHAR2(20) NOT NULL,
   ssn VARCHAR2(10) NOT NULL,
   email VARCHAR2(30),
   profile_img VARCHAR2(100) DEFAULT 'default.jpg',
   role VARCHAR2(10) DEFAULT 'STUDENT',
   phone VARCHAR2(13) NOT NULL,
   major_seq INT,
   account_seq INT ,
   address VARCHAR2(100),
   CONSTRAINT gender_ck CHECK (gender IN ('MALE','FEMALE')),
   CONSTRAINT major_member_fk FOREIGN KEY (major_seq) REFERENCES Major(major_seq) ON DELETE CASCADE,
   CONSTRAINT account_member_fk FOREIGN KEY (account_seq) REFERENCES account(account_seq) ON DELETE CASCADE
);
DROP TABLE account CASCADE CONSTRAINT;
CREATE TABLE account(
   account_seq INT CONSTRAINT account_pk PRIMARY KEY,
   account_name VARCHAR2(20) NOT NULL,
   unit_price INT NOT NULL,
   Delivery INT NOT NULL,
   Doc VARCHAR2(200),
   item_seq INT NOT NULL,
    CONSTRAINT item_account_fk FOREIGN KEY (item_seq)REFERENCES item(item_seq) on delete CASCADE
);
DROP TABLE sr_book CASCADE CONSTRAINT;
CREATE TABLE sr_book(
	sr_book_seq INT CONSTRAINT sr_book_pk PRIMARY KEY,
	sr_date VARCHAR2(20) NOT NULL,
	r_quantity INT ,
	r_amout INT ,
	s_quantity INT,
	s_price INT,
	s_amount INT,
	item_seq INT,
	p_order_seq INT,
	account_seq INT,
    CONSTRAINT item_sr_book_fk FOREIGN KEY (item_seq) REFERENCES item(item_seq) on delete cascade,
    CONSTRAINT p_order_book_fk FOREIGN KEY (p_order_seq) REFERENCES p_order(p_order_seq) on delete cascade,
    CONSTRAINT account_sr_book_fk FOREIGN KEY (account_seq) REFERENCES account(account_seq) on delete cascade
	);
DROP TABLE p_order CASCADE CONSTRAINT;
CREATE TABLE p_order(
	p_order_seq INT CONSTRAINT p_order_pk PRIMARY KEY,
	p_date VARCHAR2(20) NOT NULL,
	p_quantity int NOT NULL,
	p_unit_price int NOT NULL,
	amount int NOT NULL,
	i_date VARCHAR2(20) ,
	account_seq int,
	bom_seq int,
	item_seq int,
	CONSTRAINT item_p_order_fk FOREIGN KEY (item_seq) REFERENCES item(item_seq) on delete cascade,
    CONSTRAINT bom_p_order_fk FOREIGN KEY (bom_seq) REFERENCES bom(bom_seq) on delete cascade,
    CONSTRAINT account_p_order_fk FOREIGN KEY (account_seq) REFERENCES account(account_seq) on delete cascade
);

DROP TABLE bom CASCADE CONSTRAINT;
CREATE TABLE bom(
	bom_seq INT CONSTRAINT bom_pk PRIMARY KEY,
	per_unit int,
	item_seq int,
    CONSTRAINT item_bom_fk FOREIGN KEY (item_seq) REFERENCES item(item_seq) on delete cascade
);
DROP TABLE pro_directions CASCADE CONSTRAINT;
CREATE TABLE pro_directions(
	pro_directions_seq INT CONSTRAINT pro_directions_pk PRIMARY KEY,
	start_date VARCHAR2(20) NOT NULL,
	end_date VARCHAR2(20) NOT NULL,
	pro_number int NOT NULL,
	BOM_price int NOT NULL,
	item_seq int,
    CONSTRAINT item_pro_directions_fk FOREIGN KEY (item_seq) REFERENCES item(item_seq) on delete cascade
);
DROP TABLE inventory CASCADE CONSTRAINT;
CREATE TABLE inventory(
	inventory_seq INT CONSTRAINT inventory_pk PRIMARY KEY,
	lsat_qty int default 0,
	invt_tot_qty int default 0,
	avg_price int default 0,
	invt_amount int default 0,
	shpg_tot_qty int default 0,
	current_qty int default 0,
	item_seq int,
	sr_book_seq int,
    CONSTRAINT item_inventory_fk FOREIGN KEY (item_seq) REFERENCES item(item_seq) on delete cascade,
    CONSTRAINT sr_book_inventory_fk FOREIGN KEY (sr_book_seq) REFERENCES sr_book(sr_book_seq) on delete cascade
);
 select * from tab;
 







====== select ========

select * from 
select * from 
select * from 
select * from 
select * from 
select * from 
CREATE sequence seq increment by 1 start with 1000 nocycle;
SELECT SEQUENCE_OWNER, SEQUENCE_NAME FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'HANBIT';
DROP SEQUENCE SEQ;

