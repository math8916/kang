/*
META PROCEDURE
*/
SELECT OBJECT_NAME FROM USER_PROCEDURES;
--DROP PROCEDURE HANBIT.INSERTGRADE;
/*
=============== Item ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-8
@UPDATE DATE: 2016-9-8
@DESC :제품 및 부품리스트
=============== item ===============
*/
--1.DEF_INSERT_item
CREATE OR REPLACE PROCEDURE insert_item(
sp_item_name in item.item_name%TYPE,
sp_division in item.division%TYPE,
sp_defective_rate in item.defective_rate%TYPE
)AS
BEGIN
   INSERT INTO item(item_seq,item_name,division,defective_rate) VALUES(item_seq.nextval,sp_item_name,sp_division,sp_defective_rate);
END insert_item;
--EXE_INSERT_item
EXEC HANBIT.INSERT_item('ictr','PART','1');


--2. DEF_COUNT_item
 CREATE OR REPLACE PROCEDURE count_item(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM item;
    END count_item;
--EXE_COUNT_item        
DECLARE
        sp_count NUMBER;
    BEGIN
            count_item(sp_count);
            DBMS_OUTPUT.put_line ('수량 :'||sp_count);
    END;
--3. DEF_FIND_item
CREATE OR REPLACE PROCEDURE find_item(
    sp_item_seq IN OUT item.item_seq%TYPE,
    sp_item_name        OUT item.item_name%TYPE,
sp_division OUT item.division%TYPE,
sp_defective_rate OUT item.defective_rate%TYPE,
    sp_result out VARCHAR2
    ) AS
    SP_temp_count NUMBER;
    BEGIN
        SELECT COUNT(*) into SP_temp_count from item where item_seq = sp_item_seq;
        IF(SP_temp_count >0)
        THEN
            SELECT 
            item_seq,item_name,division,defective_rate
            into sp_item_seq,sp_item_name,sp_division,sp_defective_rate
            FROM item 
            WHERE item_seq =sp_item_seq;
            sp_result :='품목번호 :'||sp_item_seq||',품목명 :'||sp_item_name||',구분 :'||sp_division||',불량율 :'||sp_defective_rate;
        ELSE
            sp_result :='품목이 없습니다';
        END IF;
    END find_item;
  --EXE_FIND_item      
    DECLARE
        sp_item_seq NUMBER:=1001;
        sp_result VARCHAR2(200);
        sp_item_name VARCHAR2(20); 
sp_division VARCHAR2(20);
sp_defective_rate VARCHAR2(20);

    BEGIN
            find_item(sp_item_seq,sp_item_name,sp_division,sp_defective_rate,sp_result);
            DBMS_OUTPUT.put_line (sp_result);
    END;
      --4. all item
CREATE OR REPLACE PROCEDURE all_item(
    sp_result OUT CLOB
) AS
    sp_temp CLOB;
    sp_cnt  NUMBER := 0;
BEGIN
        
    FOR item_rec IN (SELECT m.item_seq
                            ,m.title
                      FROM   item m
                     )
    LOOP
        sp_cnt := sp_cnt + 1;
        IF sp_cnt = 1 THEN
           sp_temp := item_rec.item_seq||'-'||item_rec.title;
           
        ELSE
        
          sp_temp := sp_temp||CHR(10)||
                     item_rec.item_seq||'-'||item_rec.title;
          
        END IF;
    END LOOP;
    
    sp_result := sp_temp;
    
END all_item;
exec all_item();

    DECLARE
    sp_result CLOB;
  BEGIN
    all_item(sp_result);
        DBMS_OUTPUT.put_line(sp_result);
   
    END all_item;
    
--4. DEF_ALL_item(CRSOR VERSION)
CREATE OR REPLACE PROCEDURE HANBIT.all_item(
    item_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN item_cur FOR SELECT item_seq,item_name,division,defective_rate FROM item;
END all_item;
--EXE_ALL_item(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_item_seq   item.item_seq%TYPE;
  sp_item_name item.item_name%TYPE;
  sp_division item.division%TYPE;
  sp_defective_rate item.defective_rate%TYPE;
BEGIN
  all_item (sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_item_seq,sp_item_name,sp_division,sp_defective_rate;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_item_seq || ' | ' ||sp_item_name||' | ' ||sp_item_name||' | '|| sp_division||' | '|| sp_defective_rate);
  END LOOP;
  CLOSE sp_cursor;
END;
--DEF_A_UPDATE_item
CREATE OR REPLACE PROCEDURE a_update_item(
 sp_item_seq in item.item_seq%TYPE,
 sp_item_name  in item.item_name%TYPE,
 sp_division in item.division%TYPE,
 sp_defective_rate in item.defective_rate%TYPE
 )
 AS
 BEGIN
    UPDATE item SET item_name=sp_item_name,division=sp_division,defective_rate=sp_defective_rate WHERE item_seq=sp_item_seq;
 END;
--EXE_A_UPDATE_item
BEGIN a_update_item('1003','cpu','PART','1');end a_update_item;
--5. DEF_DELETE_item --
CREATE OR REPLACE PROCEDURE delete_item( sp_item_seq in item.item_seq%TYPE) AS
BEGIN DELETE FROM item WHERE item_seq=sp_item_seq;END;
BEGIN delete_item(1003);end delete_item;

---Select ----
select * from item;
/*
=============== production ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-8
@UPDATE DATE: 2016-9-8
@DESC :제품 및 부품리스트
=============== production ===============
*/
select * from production;
--1.DEF_INSERT_production
CREATE OR REPLACE PROCEDURE insert_production(
sp_production_name in production.production_name%TYPE,
sp_p_division in production.p_division%TYPE,
sp_p_defective_rate in production.p_defective_rate%TYPE,
sp_p_lead_time in production.p_lead_time%TYPE)
AS 
BEGIN
   INSERT INTO production(production_seq,production_name,p_division,p_defective_rate,p_lead_time) VALUES(production_seq.nextval,sp_production_name,sp_p_division,sp_p_defective_rate,sp_p_lead_time);
END insert_production;
--EXE_INSERT_production
EXEC HANBIT.INSERT_production('hidden2','Good','1','10');


--2. DEF_COUNT_production
 CREATE OR REPLACE PROCEDURE count_production(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM production;
    END count_production;
--EXE_COUNT_production        
DECLARE
        sp_count NUMBER;
    BEGIN
            count_production(sp_count);
            DBMS_OUTPUT.put_line ('수량 :'||sp_count);
    END;
--3. DEF_FIND_production
CREATE OR REPLACE PROCEDURE find_production(
    sp_production_seq IN OUT production.production_seq%TYPE,
    sp_production_name        OUT production.production_name%TYPE,
sp_division OUT production.p_division%TYPE,
sp_defective_rate OUT production.p_defective_rate%TYPE,
sp_lead_time OUT production.p_lead_time%TYPE,
    sp_result out VARCHAR2
    ) AS
    SP_temp_count NUMBER;
    BEGIN
        SELECT COUNT(*) into SP_temp_count from production where production_seq = sp_production_seq;
        IF(SP_temp_count >0)
        THEN
            SELECT 
            production_seq,production_name,p_division,p_defective_rate,p_lead_time
            into sp_production_seq,sp_production_name,sp_division,sp_defective_rate,sp_lead_time
            FROM production 
            WHERE production_seq =sp_production_seq;
            sp_result :='품목번호 :'||sp_production_seq||',품목명 :'||sp_production_name||',구분 :'||sp_division||',불량율 :'||sp_defective_rate||',대당생산소요시간 : '||sp_lead_time;
        ELSE
            sp_result :='품목이 없습니다';
        END IF;
    END find_production;
  --EXE_FIND_production      
    DECLARE
        sp_production_seq NUMBER:=1001;
        sp_result VARCHAR2(200);
        sp_production_name VARCHAR2(20); 
sp_division VARCHAR2(20);
sp_defective_rate VARCHAR2(20);
sp_lead_time VARCHAR2(20);
    BEGIN
            find_production(sp_production_seq,sp_production_name,sp_division,sp_defective_rate,sp_lead_time,sp_result);
            DBMS_OUTPUT.put_line (sp_result);
    END;
      --4. all production
CREATE OR REPLACE PROCEDURE all_production(
    sp_result OUT CLOB
) AS
    sp_temp CLOB;
    sp_cnt  NUMBER := 0;
BEGIN
        
    FOR production_rec IN (SELECT production.production_seq
                            ,production.production_name
                      FROM   production m
                     )
    LOOP
        sp_cnt := sp_cnt + 1;
        IF sp_cnt = 1 THEN
           sp_temp := production_rec.production_seq||'-'||production_rec.production_name;
           
        ELSE
        
          sp_temp := sp_temp||CHR(10)||
                     production_rec.production_seq||'-'||production_rec.title;
          
        END IF;
    END LOOP;
    
    sp_result := sp_temp;
    
END all_production;
exec all_production();

    DECLARE
    sp_result CLOB;
  BEGIN
    all_production(sp_result);
        DBMS_OUTPUT.put_line(sp_result);
   
    END all_production;
    
--4. DEF_ALL_production(CRSOR VERSION)
CREATE OR REPLACE PROCEDURE HANBIT.all_production(
    production_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN production_cur FOR SELECT production_seq,production_name,p_division,p_defective_rate,p_lead_time FROM production;
END all_production;
--EXE_ALL_production(URSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_production_seq   production.production_seq%TYPE;
  sp_production_name production.production_name%TYPE;
  sp_division production.p_division%TYPE;
  sp_defective_rate production.p_defective_rate%TYPE;
  sp_lead_time production.p_lead_time%TYPE;
BEGIN
  all_production (sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_production_seq,sp_production_name,sp_division,sp_defective_rate,sp_lead_time;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_production_seq || ' | '  ||sp_production_name||' | '|| sp_division||' | '|| sp_defective_rate||' | '||sp_lead_time);
  END LOOP;
  CLOSE sp_cursor;
END;
--DEF_A_UPDATE_production
CREATE OR REPLACE PROCEDURE a_update_production(
 sp_production_seq in production.production_seq%TYPE,
 sp_production_name  in production.production_name%TYPE,
 sp_p_division in production.p_division%TYPE,
 sp_p_defective_rate in production.p_defective_rate%TYPE,
 sp_lead_time in production.p_lead_time%TYPE
 )
 AS
 BEGIN
    UPDATE production SET production_name=sp_production_name,p_division=sp_p_division,p_defective_rate=sp_p_defective_rate,p_lead_time=sp_lead_time WHERE production_seq=sp_production_seq;
 END;
--EXE_A_UPDATE_production
BEGIN a_update_production('1001','hidden_kang3','GOOD','1','2');end a_update_production;
--5. DEF_DELETE_production --
CREATE OR REPLACE PROCEDURE delete_production( sp_production_seq in production.production_seq%TYPE) AS
BEGIN DELETE FROM production WHERE production_seq=sp_production_seq;END;
BEGIN delete_production(1000);end delete_production;

---Select ----
select * from production;

/*
=============== MEMBER ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :구성원
=======================================
*/
--DEF_A_INSERT_member
select * from member;
select * from major;
CREATE OR REPLACE PROCEDURE a_insert_Member(
   sp_mem_id IN Member.mem_id%TYPE,
   sp_pw IN member.pw%TYPE,
   sp_name IN Member.name%TYPE,
   sp_gender IN Member.gender%TYPE,
   sp_reg_date IN Member.reg_date%TYPE,
   sp_ssn IN Member.ssn%TYPE,
   sp_email IN Member.email%TYPE,
   sp_profile_img IN Member.profile_img%TYPE,
   sp_role IN Member.role%TYPE,
   sp_phone IN Member.phone%TYPE,
   sp_major_seq IN Member.major_seq%TYPE,
   sp_account_seq   IN Member.account_seq%TYPE,
      sp_address   IN Member.address%TYPE
  ) AS 
BEGIN
   INSERT INTO Member(mem_id,pw,name,gender,reg_date,ssn,email,profile_img,role,phone,major_seq,account_seq,address)
   VALUES(sp_mem_id,sp_pw,sp_name,sp_gender,sp_reg_date,sp_ssn,sp_email,sp_profile_img,sp_role,sp_phone,sp_major_seq,sp_account_seq,sp_address);
END a_insert_Member;
--EXE_A_INSERT_Member
EXEC HANBIT.A_INSERT_MEMBER('ACC3','1','최거래 ','MALE','2016-05-01','710221-1','charls@gmail.com','default.jpg','ACCOUNT','010-4545-1123','','1001','서울 서대문구');
EXEC HANBIT.A_INSERT_MEMBER('hong','1','홍길동 ','MALE','2016-05-01','710222-1','charls@gmail.com','default.jpg','STUDENT','010-4545-1124','1000','','서울 서대문구');
EXEC HANBIT.A_INSERT_MEMBER('PROF1','1','최강 ','MALE','2016-05-01','710223-1','charls@gmail.com','default.jpg','PROF','010-4545-1125','1000','','서울 서대문구');
EXEC HANBIT.A_INSERT_MEMBER('COM1','1','김유신','MALE','2016-05-01','710224-1','charls@gmail.com','default.jpg','SALES','010-4545-1127','','1001','서울 서대문구');
--DEF_COUNT_member
 CREATE OR REPLACE PROCEDURE a_count_member(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM member ;
    END a_count_member;
--EXE_COUNT_member        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_member(sp_count);
            DBMS_OUTPUT.put_line ('회원수 :'||sp_count);
    END;
--DEF_EXIST_MEMBER_ID
CREATE OR REPLACE PROCEDURE exist_member_id(
sp_mem_id in Member.mem_id%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM Member WHERE mem_id=sp_mem_id; 
END exist_member_id;
--EXE_EXIST_MEMBER_ID
DECLARE sp_mem_id VARCHAR2(30):='hong';sp_count NUMBER;BEGIN exist_member_id(sp_mem_id,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_member_ID   
CREATE OR REPLACE PROCEDURE a_find_by_member_id(
    sp_member_id IN OUT Member.mem_id%TYPE,
    sp_member OUT Member%ROWTYPE
    ) AS BEGIN
        SELECT * into sp_member from member where mem_id = sp_member_id;
    
    END a_find_by_member_id;
 --EXE_FIND_BY_member_ID      
    DECLARE
        sp_member_id VARCHAR2(120):='hong';
        sp_member Member%ROWTYPE;
    BEGIN
            a_find_by_member_id(sp_member_id,sp_member);
            DBMS_OUTPUT.put_line ('이름 : '||sp_member.name||'|| ,역할: '||sp_member.role);
    END a_find_by_member_id;
--DEF_ALL_member(URSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_member(
    member_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN member_cur FOR SELECT * FROM Member ;
END a_all_member;
--EXE_ALL_member(URSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_member Member%ROWTYPE;
 BEGIN
  a_all_member(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_member;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_member.mem_id || ' | ' ||sp_member.name||' | '||sp_member.email);
  END LOOP;
  CLOSE sp_cursor;
END;
--DEF_A_UPDATE_member
CREATE OR REPLACE PROCEDURE a_update_member(
 sp_member_id in member.mem_id%TYPE,
 sp_pw in member.pw%TYPE,
 sp_email in member.email%TYPE,
 sp_phone in member.phone%TYPE
 )
 AS
 BEGIN
    UPDATE Member SET pw=sp_pw,email=sp_email,phone=sp_phone WHERE mem_id=sp_member_id;
 END;
--EXE_A_UPDATE_member
BEGIN a_update_member('hong','1','math@test.com','123-1234-1234');end a_update_member;
-- DEF_A_DELETE_member
 CREATE OR REPLACE PROCEDURE a_delete_member(sp_member_id IN Member.mem_id%TYPE) AS
 BEGIN DELETE FROM Member WHERE mem_id = sp_member_id; END;
 -- EXE A_DELETE_member
 BEGIN a_delete_member('ACC2'); END;
 select * from member;
 /*
=============== Account ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :거래처
=======================================
*/
select * from account;
--DEF_A_INSERT_account
CREATE OR REPLACE PROCEDURE a_insert_account(
   sp_account_name IN account.account_name%TYPE,
   sp_account_address IN account.account_address%TYPE
    ) AS 
BEGIN
   INSERT INTO account(account_seq,account_name,account_address)
   VALUES(account_seq.nextval,sp_account_name,sp_account_address);
END a_insert_account;
select * from account;
--EXE_A_INSERT_account
EXEC HANBIT.a_insert_account('최선주식회사','서울 서대문구 홍은동');
--DEF_COUNT_account
 CREATE OR REPLACE PROCEDURE a_count_account(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM account ;
    END a_count_account;
--EXE_COUNT_account        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_account(sp_count);
            DBMS_OUTPUT.put_line ('회원수 :'||sp_count);
    END;
--DEF_EXIST_account_ID
CREATE OR REPLACE PROCEDURE exist_account_id(
sp_account_seq in account.account_seq%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM account WHERE account_seq=sp_account_seq; 
END exist_account_id;
--EXE_EXIST_account_ID
DECLARE sp_account_seq number:='1002';sp_count NUMBER;BEGIN exist_account_id(sp_account_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_account_ID   
CREATE OR REPLACE PROCEDURE a_find_by_account_id(
    sp_account_seq IN OUT account.account_seq%TYPE,
    sp_account OUT account%ROWTYPE
    ) AS BEGIN
        SELECT * into sp_account from account where account_seq = sp_account_seq;
    
    END a_find_by_account_id;
 --EXE_FIND_BY_account_ID      
    DECLARE
        sp_account_seq number:='1001';
        sp_account account%ROWTYPE;
    BEGIN
            a_find_by_account_id(sp_account_seq,sp_account);
            DBMS_OUTPUT.put_line ('이름 : '||sp_account.account_name||'|| ,주소 : '||sp_account.account_address);
    END a_find_by_account_id;
--DEF_ALL_account(CURSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_account(
    account_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN account_cur FOR SELECT * FROM account ;
END a_all_account;
--EXE_ALL_account(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_account account%ROWTYPE;
 BEGIN
  a_all_account(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_account;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_account.account_seq || ' | ' ||sp_account.account_name||' | '||sp_account.account_address);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_account
CREATE OR REPLACE PROCEDURE a_update_account(
 sp_account_seq in account.account_seq%TYPE,
 sp_account_name in account.account_name%TYPE,
 sp_account_address in account.account_address%TYPE
 )
 AS
 BEGIN
    UPDATE account SET account_name=sp_account_name,account_address=sp_account_address WHERE account_seq=sp_account_seq;
 END;
--EXE_UPDATE_account
BEGIN a_update_account('1001','korea1.com','Seoul');end a_update_account;
-- DEF_DELETE_account
 CREATE OR REPLACE PROCEDURE a_delete_account(sp_account_id IN account.account_seq%TYPE) AS
 BEGIN DELETE FROM account WHERE account_seq = sp_account_id; END;
 -- EXE DELETE_account
 BEGIN a_delete_account('1003'); END;
 select * from account;
 
 /*
=============== quotation ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :견적서
=======================================
*/
--DEF_A_INSERT_quotation
select * from quotation;
CREATE OR REPLACE PROCEDURE a_insert_quotation(
   sp_unit_price IN quotation.unit_price%TYPE,
   sp_Delivery IN quotation.Delivery%TYPE,
   sp_DOC    IN quotation.DOC%TYPE,
   sp_item_seq IN quotation.item_seq%TYPE,
   sp_account_seq IN quotation.account_seq%TYPE
   ) AS 
BEGIN
   INSERT INTO quotation(quotation_seq,unit_price,Delivery,DOC,item_seq,account_seq)
   VALUES(quotation_seq.nextval,sp_unit_price,sp_Delivery,sp_DOC,sp_item_seq,sp_account_seq);
END a_insert_quotation;
select * from quotation;
--EXE_A_INSERT_quotation
EXEC a_insert_quotation('100','2','현금결재','1002','1002');
--DEF_COUNT_quotation
 CREATE OR REPLACE PROCEDURE a_count_quotation(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM quotation ;
    END a_count_quotation;
--EXE_COUNT_quotation        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_quotation(sp_count);
            DBMS_OUTPUT.put_line ('견적수 :'||sp_count);
    END;
--DEF_EXIST_quotation_ID
CREATE OR REPLACE PROCEDURE exist_quotation_id(
sp_quotation_seq in quotation.quotation_seq%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM quotation WHERE quotation_seq=sp_quotation_seq; 
END exist_quotation_id;
--EXE_EXIST_quotation_ID
DECLARE sp_quotation_seq number:='1001';sp_count NUMBER;BEGIN exist_quotation_id(sp_quotation_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_quotation_ID   
CREATE OR REPLACE PROCEDURE a_find_by_quotation_id(
    sp_quotation_seq IN OUT quotation.quotation_seq%TYPE,
    sp_unit_price OUT quotation.unit_price%ROWTYPE,
    sp_Delivery OUT quotation.Delivery%ROWTYPE,
    sp_DOC OUT quotation.DOC%ROWTYPE,
    sp_item_seq OUT quotation.item_seq%ROWTYPE,
    sp_account_seq OUT quotation.account_seq%ROWTYPE
        ) AS BEGIN
        SELECT * into sp_quotation from quotation where quotation_seq = sp_quotation_seq;
    
    END a_find_by_quotation_id;
 --EXE_FIND_BY_quotation_ID      
    DECLARE
        sp_quotation_seq number:='1004';
        sp_quotation quotation%ROWTYPE;
    BEGIN
            a_find_by_quotation_id(sp_quotation_seq,sp_quotation);
            DBMS_OUTPUT.put_line ('견적서코드: '||sp_quotation.item_seq||'|| ,단가 : '||sp_quotation.unit_price||'|| ,납기 : '||sp_quotation.Delivery||'|| ,메모 : '||sp_quotation.DOC||'|| ,부품코드 : '||sp_quotation.item_seq||'|| ,거래처코드 : '||sp_quotation.account_seq);
    END a_find_by_quotation_id;
--DEF_ALL_quotation(CURSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_quotation(
    quotation_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN quotation_cur FOR SELECT * FROM quotation ;
END a_all_quotation;
--EXE_ALL_quotation(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_quotation quotation%ROWTYPE;
 BEGIN
  a_all_quotation(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_quotation;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('견적서코드: '||sp_quotation.quotation_seq||'|| ,단가 : '||sp_quotation.unit_price||'|| ,납기 : '||sp_quotation.Delivery||'|| ,메모 : '||sp_quotation.DOC||'|| ,부품코드 : '||sp_quotation.item_seq||'|| ,거래처코드 : '||sp_quotation.account_seq);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_quotation
CREATE OR REPLACE PROCEDURE a_update_quotation(
 sp_quotation_seq in quotation.quotation_seq%TYPE,
 sp_unit_price in quotation.unit_price%TYPE,
 sp_Delivery in quotation.Delivery%TYPE,
 sp_DOC in quotation.DOC%TYPE
 )
 AS
 BEGIN
    UPDATE quotation SET unit_price=sp_unit_price,Delivery=sp_Delivery,DOC=sp_DOC WHERE quotation_seq=sp_quotation_seq;
 END;
--EXE_UPDATE_quotation
BEGIN a_update_quotation('1004','4545','3','FOB 인도방식');end a_update_quotation;
-- DEF_DELETE_quotation
 CREATE OR REPLACE PROCEDURE a_delete_quotation(sp_quotation_id IN quotation.quotation_seq%TYPE) AS
 BEGIN DELETE FROM quotation WHERE quotation_seq = sp_quotation_id; END;
 -- EXE DELETE_quotation
 BEGIN a_delete_quotation('1005'); END;
 select * from quotation;
 
 /*
=============== sr_book ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :입출고장- 미 완성
=======================================
*/
--DEF_A_INSERT_sr_book
CREATE OR REPLACE PROCEDURE a_insert_sr_book(
   sp_sr_date IN sr_book.sr_date%TYPE,
   sp_r_quantity IN sr_book.r_quantity%TYPE,
   sp_r_amout IN sr_book.r_amout%TYPE,
   sp_s_quantity    IN sr_book.s_quantity%TYPE,
   sp_s_price    IN sr_book.s_price%TYPE,
   sp_s_amount    IN sr_book.s_amount%TYPE,
   sp_item_seq IN sr_book.item_seq%TYPE,
   sp_p_order_seq IN sr_book.p_order_seq%TYPE,
   sp_account_seq IN sr_book.account_seq%TYPE,
   sp_production_seq IN sr_book.production_seq%TYPE
     ) AS 
BEGIN
   INSERT INTO sr_book(sr_book_seq,sr_date,r_quantity,r_amout,s_quantity,s_price,s_amount,item_seq,p_order_seq,account_seq,production_seq)
   VALUES(sr_book_seq.nextval,sp_sr_date,sp_r_quantity,sp_r_amout,sp_s_quantity,sp_s_price,sp_s_amount,sp_item_seq,sp_p_order_seq,sp_account_seq,sp_production_seq);
END a_insert_sr_book;
select * from sr_book;
--EXE_A_INSERT_sr_book
EXEC HANBIT.A_INSERT_sr_book('2016-09-18','10','50000','','','','1001','1001','1001','');
EXEC HANBIT.A_INSERT_sr_book('2016-09-28','','','5000','50','25000','1001','1001','1001','');
--DEF_COUNT_sr_book
 CREATE OR REPLACE PROCEDURE a_count_sr_book(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM sr_book ;
    END a_count_sr_book;
--EXE_COUNT_sr_book        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_sr_book(sp_count);
            DBMS_OUTPUT.put_line ('입출고 전체 수 :'||sp_count);
    END;
--DEF_EXIST_sr_book_ID
CREATE OR REPLACE PROCEDURE exist_sr_book_id(
sp_sr_book_seq in sr_book.sr_book_seq%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM sr_book WHERE sr_book_seq=sp_sr_book_seq; 
END exist_sr_book_id;
--EXE_EXIST_sr_book_ID
DECLARE sp_sr_book_seq number:='1006';sp_count NUMBER;BEGIN exist_sr_book_id(sp_sr_book_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_sr_book_ID   
CREATE OR REPLACE PROCEDURE a_find_by_sr_book_id(
    sp_sr_book_seq IN OUT sr_book.sr_book_seq%TYPE,
    sp_sr_book OUT sr_book%ROWTYPE
    ) AS BEGIN
        SELECT * into sp_sr_book from sr_book where sr_book_seq = sp_sr_book_seq;
   
    END a_find_by_sr_book_id;
 --EXE_FIND_BY_sr_book_ID 
 select * from sr_book;     
    DECLARE
        sp_sr_book_seq number:='1005';
        sp_sr_book sr_book%ROWTYPE;
    BEGIN
            a_find_by_sr_book_id(sp_sr_book_seq,sp_sr_book);
            DBMS_OUTPUT.put_line (
            '입출고장코드 : '||sp_sr_book.sr_book_seq||
            '|| ,일자 : '||sp_sr_book.sr_date||
            '|| ,출고량 : '||sp_sr_book.r_quantity||
            '|| ,출고금액 : '||sp_sr_book.r_amout||
            '|| ,입고량 : '||sp_sr_book.s_quantity||
            '|| ,임고단가 : '||sp_sr_book.s_price||
            '|| ,입고금액 : '||sp_sr_book.s_amount||
            '|| ,부품 코드 : '||sp_sr_book.item_seq||
            '|| ,발주코드 : '||sp_sr_book.p_order_seq||
            '|| ,거래처코드 : '||sp_sr_book.account_seq||
            '|| ,제품코드 : '||sp_sr_book.production_seq);
    END a_find_by_sr_book_id;
--DEF_ALL_sr_book(URSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_sr_book(
    sr_book_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN sr_book_cur FOR SELECT * FROM sr_book ;
END a_all_sr_book;
--EXE_ALL_sr_book(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_sr_book sr_book%ROWTYPE;
 BEGIN
  a_all_sr_book(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_sr_book;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(
    '입출고장코드 : '||sp_sr_book.sr_book_seq||
            '|| ,일자 : '||sp_sr_book.sr_date||
            '|| ,출고량 : '||sp_sr_book.r_quantity||
            '|| ,출고금액 : '||sp_sr_book.r_amout||
            '|| ,입고량 : '||sp_sr_book.s_quantity||
            '|| ,임고단가 : '||sp_sr_book.s_price||
            '|| ,입고금액 : '||sp_sr_book.s_amount||
            '|| ,부품 코드 : '||sp_sr_book.item_seq||
            '|| ,발주코드 : '||sp_sr_book.p_order_seq||
            '|| ,거래처코드 : '||sp_sr_book.account_seq||
            '|| ,제품코드 : '||sp_sr_book.production_seq);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_sr_book
CREATE OR REPLACE PROCEDURE a_update_sr_book(
sp_sr_book_seq in sr_book.sr_book_seq%TYPE,
 sp_r_quantity in sr_book.r_quantity%TYPE,
 sp_r_amout in sr_book.r_amout%TYPE,
 sp_s_quantity in sr_book.s_quantity%TYPE,
 sp_s_price in sr_book.s_price%TYPE
 )
 AS
 BEGIN
    UPDATE sr_book SET r_quantity=sp_r_quantity,
                        r_amout=sp_r_amout,
                        s_quantity=sp_s_quantity, 
                        s_price=sp_s_price 
     WHERE sr_book_seq=sp_sr_book_seq;
 END;
--EXE_UPDATE_sr_book
BEGIN a_update_sr_book('1005','20','4000','4','5000');end a_update_sr_book;
-- DEF_DELETE_sr_book
 CREATE OR REPLACE PROCEDURE a_delete_sr_book(sp_sr_book_id IN sr_book.sr_book_seq%TYPE) AS
 BEGIN DELETE FROM sr_book WHERE sr_book_seq = sp_sr_book_id; END;
 -- EXE DELETE_sr_book
 BEGIN a_delete_sr_book('1006'); END;
 select * from sr_book;
 
 /*
=============== p_order ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :발주서
=======================================
*/
--DEF_A_INSERT_p_order
CREATE OR REPLACE PROCEDURE a_insert_p_order(
   sp_p_order_seq IN p_order.p_order_seq%TYPE,
   sp_P_DATE IN p_order.P_DATE%TYPE,
   sp_P_QUANTITY IN p_order.P_QUANTITY%TYPE,
   sp_P_UNIT_PRICE IN p_order.P_UNIT_PRICE%TYPE,
   sp_AMOUNT IN p_order.AMOUNT%TYPE,
   sp_I_DATE   IN p_order.I_DATE%TYPE,
   sp_account_seq IN p_order.account_seq%TYPE,
   sp_bom_seq IN p_order.bom_seq%TYPE,
   sp_item_seq IN p_order.item_seq%TYPE,
   sp_quotation_seq IN p_order.quotation_seq%TYPE,
   sp_production_seq IN p_order.production_seq%TYPE
   ) AS 
BEGIN
   INSERT INTO p_order(p_order_seq,P_DATE,P_QUANTITY,P_UNIT_PRICE,AMOUNT,I_DATE,ACCOUNT_SEQ,BOM_SEQ,ITEM_SEQ,QUOTATION_SEQ,production_seq)
   VALUES(p_order_seq.nextval,sp_P_DATE,sp_P_QUANTITY,sp_p_unit_price,sp_AMOUNT,sp_I_DATE,sp_account_seq,sp_bom_seq,sp_item_seq,sp_quotation_seq,sp_production_seq);
END a_insert_p_order;
select * from p_order;
--EXE_A_INSERT_p_order
EXEC HANBIT.a_insert_p_order('2016-09-18','1000','5','5000','2016-07-01','','','','','');
--DEF_COUNT_p_order
 CREATE OR REPLACE PROCEDURE a_count_p_order(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM p_order ;
    END a_count_p_order;
--EXE_COUNT_p_order        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_p_order(sp_count);
            DBMS_OUTPUT.put_line ('회원수 :'||sp_count);
    END;
--DEF_EXIST_p_order_ID
CREATE OR REPLACE PROCEDURE exist_p_order_id(
sp_p_order_seq in p_order.p_order_seq%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM p_order WHERE p_order_seq=sp_p_order_seq; 
END exist_p_order_id;
--EXE_EXIST_p_order_ID
DECLARE sp_p_order_seq number:='1001';sp_count NUMBER;BEGIN exist_p_order_id(sp_p_order_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_p_order_ID   
CREATE OR REPLACE PROCEDURE a_find_by_p_order_id(
    sp_p_order_seq IN OUT p_order.p_order_seq%TYPE,
    sp_p_order OUT p_order%ROWTYPE
    ) AS BEGIN
        SELECT * into sp_p_order from p_order where p_order_seq = sp_p_order_seq;
    
    END a_find_by_p_order_id;
 --EXE_FIND_BY_p_order_ID      
    DECLARE
        sp_p_order_seq number:='1001';
        sp_p_order p_order%ROWTYPE;
    BEGIN
            a_find_by_p_order_id(sp_p_order_seq,sp_p_order);
            DBMS_OUTPUT.put_line ('이름 : '||sp_p_order.p_order_name||'|| ,단가 : '||sp_p_order.unit_price);
    END a_find_by_p_order_id;
--DEF_ALL_p_order(URSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_p_order(
    p_order_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN p_order_cur FOR SELECT * FROM p_order ;
END a_all_p_order;
--EXE_ALL_p_order(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_p_order p_order%ROWTYPE;
 BEGIN
  a_all_p_order(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_p_order;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_p_order.p_order_seq || ' | ' ||sp_p_order.p_order_name||' | '||sp_p_order.unit_price);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_p_order
CREATE OR REPLACE PROCEDURE a_update_p_order(
 sp_p_order_seq in p_order.p_order_seq%TYPE,
 sp_p_order_name in p_order.p_order_name%TYPE,
 sp_unit_price in p_order.unit_price%TYPE,
 sp_Delivery in p_order.Delivery%TYPE
 )
 AS
 BEGIN
    UPDATE p_order SET p_order_name=sp_p_order_name,unit_price=sp_unit_price,Delivery=sp_Delivery WHERE p_order_seq=sp_p_order_seq;
 END;
--EXE_UPDATE_p_order
BEGIN a_update_p_order('1001','korea.com','3','45');end a_update_p_order;
-- DEF_DELETE_p_order
 CREATE OR REPLACE PROCEDURE a_delete_p_order(sp_p_order_id IN p_order.p_order_seq%TYPE) AS
 BEGIN DELETE FROM p_order WHERE p_order_seq = sp_p_order_id; END;
 -- EXE DELETE_p_order
 BEGIN a_delete_p_order('ACC2'); END;
 select * from p_order;
 
 /*
=============== inventory ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :재고
=======================================
*/
--DEF_A_INSERT_inventory
CREATE OR REPLACE PROCEDURE a_insert_inventory(
   sp_inventory_name IN inventory.inventory_name%TYPE,
   sp_unit_price IN inventory.unit_price%TYPE,
   sp_Delivery IN inventory.Delivery%TYPE,
   sp_DOC    IN inventory.DOC%TYPE,
   sp_item_seq IN inventory.item_seq%TYPE
   ) AS 
BEGIN
   INSERT INTO inventory(inventory_seq,inventory_name,unit_price,Delivery,DOC,item_seq)
   VALUES(inventory_seq.nextval,sp_inventory_name,sp_unit_price,sp_Delivery,sp_DOC,sp_item_seq);
END a_insert_inventory;
select * from inventory;
--EXE_A_INSERT_inventory
EXEC HANBIT.A_INSERT_inventory('한빛상사','10','5','부품공급업체','1002');
--DEF_COUNT_inventory
 CREATE OR REPLACE PROCEDURE a_count_inventory(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM inventory ;
    END a_count_inventory;
--EXE_COUNT_inventory        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_inventory(sp_count);
            DBMS_OUTPUT.put_line ('회원수 :'||sp_count);
    END;
--DEF_EXIST_inventory_ID
CREATE OR REPLACE PROCEDURE exist_inventory_id(
sp_inventory_seq in inventory.inventory_seq%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM inventory WHERE inventory_seq=sp_inventory_seq; 
END exist_inventory_id;
--EXE_EXIST_inventory_ID
DECLARE sp_inventory_seq number:='1001';sp_count NUMBER;BEGIN exist_inventory_id(sp_inventory_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_inventory_ID   
CREATE OR REPLACE PROCEDURE a_find_by_inventory_id(
    sp_inventory_seq IN OUT inventory.inventory_seq%TYPE,
    sp_inventory OUT inventory%ROWTYPE
    ) AS BEGIN
        SELECT * into sp_inventory from inventory where inventory_seq = sp_inventory_seq;
    
    END a_find_by_inventory_id;
 --EXE_FIND_BY_inventory_ID      
    DECLARE
        sp_inventory_seq number:='1001';
        sp_inventory inventory%ROWTYPE;
    BEGIN
            a_find_by_inventory_id(sp_inventory_seq,sp_inventory);
            DBMS_OUTPUT.put_line ('이름 : '||sp_inventory.inventory_name||'|| ,단가 : '||sp_inventory.unit_price);
    END a_find_by_inventory_id;
--DEF_ALL_inventory(URSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_inventory(
    inventory_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN inventory_cur FOR SELECT * FROM inventory ;
END a_all_inventory;
--EXE_ALL_inventory(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_inventory inventory%ROWTYPE;
 BEGIN
  a_all_inventory(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_inventory;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_inventory.inventory_seq || ' | ' ||sp_inventory.inventory_name||' | '||sp_inventory.unit_price);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_inventory
CREATE OR REPLACE PROCEDURE a_update_inventory(
 sp_inventory_seq in inventory.inventory_seq%TYPE,
 sp_inventory_name in inventory.inventory_name%TYPE,
 sp_unit_price in inventory.unit_price%TYPE,
 sp_Delivery in inventory.Delivery%TYPE
 )
 AS
 BEGIN
    UPDATE inventory SET inventory_name=sp_inventory_name,unit_price=sp_unit_price,Delivery=sp_Delivery WHERE inventory_seq=sp_inventory_seq;
 END;
--EXE_UPDATE_inventory
BEGIN a_update_inventory('1001','korea.com','3','45');end a_update_inventory;
-- DEF_DELETE_inventory
 CREATE OR REPLACE PROCEDURE a_delete_inventory(sp_inventory_id IN inventory.inventory_seq%TYPE) AS
 BEGIN DELETE FROM inventory WHERE inventory_seq = sp_inventory_id; END;
 -- EXE DELETE_inventory
 BEGIN a_delete_inventory('ACC2'); END;
 select * from inventory;
 
 /*
=============== bom ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :부품리스트
=======================================
*/
--DEF_A_INSERT_bom
CREATE OR REPLACE PROCEDURE a_insert_bom(
   sp_per_unit IN bom.per_unit%TYPE,
   sp_item_seq IN bom.item_seq%TYPE
   ) AS 
BEGIN
   INSERT INTO bom(bom_seq,per_unit,item_seq)
   VALUES(bom_seq.nextval,sp_per_unit,sp_item_seq);
END a_insert_bom;
select * from bom;
--EXE_A_INSERT_bom
EXEC HANBIT.A_INSERT_bom('10','1002');
--DEF_COUNT_bom
 CREATE OR REPLACE PROCEDURE a_count_bom(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM bom ;
    END a_count_bom;
--EXE_COUNT_bom        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_bom(sp_count);
            DBMS_OUTPUT.put_line ('회원수 :'||sp_count);
    END;
--DEF_EXIST_bom_ID
CREATE OR REPLACE PROCEDURE exist_bom_id(
sp_bom_seq in bom.bom_seq%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM bom WHERE bom_seq=sp_bom_seq; 
END exist_bom_id;
--EXE_EXIST_bom_ID
DECLARE sp_bom_seq number:='1001';sp_count NUMBER;BEGIN exist_bom_id(sp_bom_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_bom_ID   
CREATE OR REPLACE PROCEDURE a_find_by_bom_id(
    sp_bom_seq IN OUT bom.bom_seq%TYPE,
    sp_bom OUT bom%ROWTYPE
    ) AS BEGIN
        SELECT * into sp_bom from bom where bom_seq = sp_bom_seq;
    
    END a_find_by_bom_id;
 --EXE_FIND_BY_bom_ID      
    DECLARE
        sp_bom_seq number:='1001';
        sp_bom bom%ROWTYPE;
    BEGIN
            a_find_by_bom_id(sp_bom_seq,sp_bom);
            DBMS_OUTPUT.put_line ('이름 : '||sp_bom.bom_seq||'|| ,단가 : '||sp_bom.unit_price);
    END a_find_by_bom_id;
--DEF_ALL_bom(URSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_bom(
    bom_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN bom_cur FOR SELECT * FROM bom ;
END a_all_bom;
--EXE_ALL_bom(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_bom bom%ROWTYPE;
 BEGIN
  a_all_bom(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_bom;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_bom.bom_seq || ' | ' ||sp_bom.bom_seq||' | '||sp_bom.unit_price);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_bom
CREATE OR REPLACE PROCEDURE a_update_bom(
 sp_bom_seq in bom.bom_seq%TYPE,
 sp_bom_seq in bom.bom_seq%TYPE,
 sp_unit_price in bom.unit_price%TYPE,
 sp_Delivery in bom.Delivery%TYPE
 )
 AS
 BEGIN
    UPDATE bom SET bom_seq=sp_bom_seq,unit_price=sp_unit_price,Delivery=sp_Delivery WHERE bom_seq=sp_bom_seq;
 END;
--EXE_UPDATE_bom
BEGIN a_update_bom('1001','korea.com','3','45');end a_update_bom;
-- DEF_DELETE_bom
 CREATE OR REPLACE PROCEDURE a_delete_bom(sp_bom_id IN bom.bom_seq%TYPE) AS
 BEGIN DELETE FROM bom WHERE bom_seq = sp_bom_id; END;
 -- EXE DELETE_bom
 BEGIN a_delete_bom('ACC2'); END;
 select * from bom;
 
 /*
=============== pro_directions ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :생산지시서
=======================================
*/
--DEF_A_INSERT_pro_directions
CREATE OR REPLACE PROCEDURE a_insert_pro_directions(
   sp_pro_directions_name IN pro_directions.pro_directions_name%TYPE,
   sp_unit_price IN pro_directions.unit_price%TYPE,
   sp_Delivery IN pro_directions.Delivery%TYPE,
   sp_DOC    IN pro_directions.DOC%TYPE,
   sp_item_seq IN pro_directions.item_seq%TYPE
   ) AS 
BEGIN
   INSERT INTO pro_directions(pro_directions_seq,pro_directions_name,unit_price,Delivery,DOC,item_seq)
   VALUES(pro_directions_seq.nextval,sp_pro_directions_name,sp_unit_price,sp_Delivery,sp_DOC,sp_item_seq);
END a_insert_pro_directions;
select * from pro_directions;
--EXE_A_INSERT_pro_directions
EXEC HANBIT.A_INSERT_pro_directions('한빛상사','10','5','부품공급업체','1002');
--DEF_COUNT_pro_directions
 CREATE OR REPLACE PROCEDURE a_count_pro_directions(
    sp_count OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) into sp_count FROM pro_directions ;
    END a_count_pro_directions;
--EXE_COUNT_pro_directions        
DECLARE
        sp_count NUMBER;
    BEGIN
            a_count_pro_directions(sp_count);
            DBMS_OUTPUT.put_line ('회원수 :'||sp_count);
    END;
--DEF_EXIST_pro_directions_ID
CREATE OR REPLACE PROCEDURE exist_pro_directions_id(
sp_pro_directions_seq in pro_directions.pro_directions_seq%TYPE,
sp_count OUT NUMBER
)AS 
BEGIN SELECT COUNT(*) INTO sp_count FROM pro_directions WHERE pro_directions_seq=sp_pro_directions_seq; 
END exist_pro_directions_id;
--EXE_EXIST_pro_directions_ID
DECLARE sp_pro_directions_seq number:='1001';sp_count NUMBER;BEGIN exist_pro_directions_id(sp_pro_directions_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
--DEF_FIND_BY_pro_directions_ID   
CREATE OR REPLACE PROCEDURE a_find_by_pro_directions_id(
    sp_pro_directions_seq IN OUT pro_directions.pro_directions_seq%TYPE,
    sp_pro_directions OUT pro_directions%ROWTYPE
    ) AS BEGIN
        SELECT * into sp_pro_directions from pro_directions where pro_directions_seq = sp_pro_directions_seq;
    
    END a_find_by_pro_directions_id;
 --EXE_FIND_BY_pro_directions_ID      
    DECLARE
        sp_pro_directions_seq number:='1001';
        sp_pro_directions pro_directions%ROWTYPE;
    BEGIN
            a_find_by_pro_directions_id(sp_pro_directions_seq,sp_pro_directions);
            DBMS_OUTPUT.put_line ('이름 : '||sp_pro_directions.pro_directions_name||'|| ,단가 : '||sp_pro_directions.unit_price);
    END a_find_by_pro_directions_id;
--DEF_ALL_pro_directions(URSOR VERSION)
CREATE OR REPLACE PROCEDURE a_all_pro_directions(
    pro_directions_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN pro_directions_cur FOR SELECT * FROM pro_directions ;
END a_all_pro_directions;
--EXE_ALL_pro_directions(CURSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_pro_directions pro_directions%ROWTYPE;
 BEGIN
  a_all_pro_directions(sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_pro_directions;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_pro_directions.pro_directions_seq || ' | ' ||sp_pro_directions.pro_directions_name||' | '||sp_pro_directions.unit_price);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_pro_directions
CREATE OR REPLACE PROCEDURE a_update_pro_directions(
 sp_pro_directions_seq in pro_directions.pro_directions_seq%TYPE,
 sp_pro_directions_name in pro_directions.pro_directions_name%TYPE,
 sp_unit_price in pro_directions.unit_price%TYPE,
 sp_Delivery in pro_directions.Delivery%TYPE
 )
 AS
 BEGIN
    UPDATE pro_directions SET pro_directions_name=sp_pro_directions_name,unit_price=sp_unit_price,Delivery=sp_Delivery WHERE pro_directions_seq=sp_pro_directions_seq;
 END;
--EXE_UPDATE_pro_directions
BEGIN a_update_pro_directions('1001','korea.com','3','45');end a_update_pro_directions;
-- DEF_DELETE_pro_directions
 CREATE OR REPLACE PROCEDURE a_delete_pro_directions(sp_pro_directions_id IN pro_directions.pro_directions_seq%TYPE) AS
 BEGIN DELETE FROM pro_directions WHERE pro_directions_seq = sp_pro_directions_id; END;
 -- EXE DELETE_pro_directions
 BEGIN a_delete_pro_directions('ACC2'); END;
 select * from pro_directions;
