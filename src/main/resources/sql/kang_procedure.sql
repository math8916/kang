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
@DESC :전공
=============== item ===============
*/
--DEF_INSERT_item
CREATE OR REPLACE PROCEDURE insert_item(
    sp_item_name 		in item.item_name%TYPE, 		
	sp_division 		in item.division%TYPE, 		
	sp_defective_rate	in item.defective_rate%TYPE,	
	sp_lead_time 		in item.lead_time%TYPE)
AS 
BEGIN
   INSERT INTO item(item_seq,item_name,division,defective_rate,lead_time) VALUES(item_seq.nextval,sp_item_name,sp_division,sp_defective_rate,sp_lead_time);
END insert_item;
--EXE_INSERT_item
EXEC HANBIT.INSERT_item('ic3','PART','1','10');


--DEF_COUNT_item
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
--DEF_FIND_item
CREATE OR REPLACE PROCEDURE find_item(
    sp_item_seq IN OUT item.item_seq%TYPE,
    sp_item_name        OUT item.item_name%TYPE, 		
	sp_division 		OUT item.division%TYPE, 		
	sp_defective_rate	OUT item.defective_rate%TYPE,	
	sp_lead_time 		OUT item.lead_time%TYPE, 		
    sp_result out VARCHAR2
    ) AS
    SP_temp_count NUMBER;
    BEGIN
        SELECT COUNT(*) into SP_temp_count from item where item_seq = sp_item_seq;
        IF(SP_temp_count >0)
        THEN
            SELECT 
            item_seq,item_name,division,defective_rate,lead_time
            into sp_item_seq,sp_item_name,sp_division,sp_defective_rate,sp_lead_time
            FROM item 
            WHERE item_seq =sp_item_seq;
            sp_result :='품목번호 :'||sp_item_seq||',품목명 :'||sp_item_name||',구분 :'||sp_division||',불량율 :'||sp_defective_rate||',대당생산소요시간 : '||sp_lead_time;
        ELSE
            sp_result :='품목이 없습니다';
        END IF;
    END find_item;
  --EXE_FIND_item      
    DECLARE
        sp_item_seq NUMBER:=1001;
        sp_result VARCHAR2(200);
        sp_item_name 		VARCHAR2(20); 
		sp_division 		VARCHAR2(20);
		sp_defective_rate	VARCHAR2(20);
		sp_lead_time 		VARCHAR2(20);
    BEGIN
            find_item(sp_item_seq,sp_item_name,sp_division,sp_defective_rate,sp_lead_time,sp_result);
            DBMS_OUTPUT.put_line (sp_result);
    END;
      -- all item
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
    
--DEF_ALL_item(CRSOR VERSION)
CREATE OR REPLACE PROCEDURE HANBIT.all_item(
    item_cur OUT SYS_REFCURSOR
) IS
BEGIN 
    OPEN item_cur FOR SELECT item_seq,item_name,division,defective_rate,lead_time FROM item;
END all_item;
--EXE_ALL_item(URSOR VERSION)
DECLARE
  sp_cursor SYS_REFCURSOR;
  sp_item_seq   item.item_seq%TYPE;
  sp_item_name 		item.item_name%TYPE;
  sp_division 		item.division%TYPE;
  sp_defective_rate	item.defective_rate%TYPE;
  sp_lead_time 		item.lead_time%TYPE;
BEGIN
  all_item (sp_cursor);         
  LOOP 
    FETCH sp_cursor
    INTO  sp_item_seq,sp_item_name,sp_division,sp_defective_rate,sp_lead_time;
    EXIT WHEN sp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sp_item_seq || ' | ' ||sp_item_name||' | ' ||sp_item_name||' | '|| sp_division||' | '|| sp_defective_rate||' | '||sp_lead_time);
  END LOOP;
  CLOSE sp_cursor;
END;
--DEF_DELETE_item --
CREATE OR REPLACE PROCEDURE delete_item( sp_item_seq in item.item_seq%TYPE) AS
BEGIN DELETE FROM item WHERE item_seq=sp_item_seq;END;
BEGIN delete_item(1000);end delete_item;

---Select ----
select * from item;

/*
=============== MEMBER ===============
@AUTHOR :math89@gmail.com
@CREATE DATE: 2016-9-13
@UPDATE DATE: 2016-9-13
@DESC :구성원
=======================================
*/
--DEF_A_INSERT_member
CREATE OR REPLACE PROCEDURE a_insert_Member(
   sp_mem_id 		IN Member.mem_id%TYPE,
   sp_pw 			IN member.pw%TYPE,
   sp_name 			IN Member.name%TYPE,
   sp_gender 		IN Member.gender%TYPE,
   sp_reg_date 		IN Member.reg_date%TYPE,
   sp_ssn 			IN Member.ssn%TYPE,
   sp_email 		IN Member.email%TYPE,
   sp_profile_img 	IN Member.profile_img%TYPE,
   sp_role 			IN Member.role%TYPE,
   sp_phone 		IN Member.phone%TYPE,
   sp_major_seq 	IN Member.major_seq%TYPE,
   sp_account_seq  	IN Member.account_seq%TYPE,
   sp_address 	    IN Member.address%TYPE
) AS 
BEGIN
   INSERT INTO Member(mem_id,pw,name,gender,reg_date,ssn,email,profile_img,role,phone,major_seq,account_seq,address)
   VALUES(sp_mem_id,sp_pw,sp_name,sp_gender,sp_reg_date,sp_ssn,sp_email,sp_profile_img,sp_role,sp_phone,sp_major_seq,sp_account_seq,sp_address);
END a_insert_Member;
--EXE_A_INSERT_Member
EXEC HANBIT.A_INSERT_MEMBER('ACC2','1','박거래 ','MALE','2016-05-01','710201-1','charls@gmail.com','default.jpg','거래처','010-4545-1124','1000','1000','seoul');
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
            DBMS_OUTPUT.put_line ('이름 : '||sp_member.name||'|| ,부서 : '||sp_member.role);
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
--DEF_UPDATE_member
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
--EXE_UPDATE_member
BEGIN a_update_member('hong','1','math@test.com','123-1234-1234');end a_update_member;
-- DEF_DELETE_member
 CREATE OR REPLACE PROCEDURE a_delete_member(sp_member_id IN Member.mem_id%TYPE) AS
 BEGIN DELETE FROM Member WHERE mem_id = sp_member_id; END;
 -- EXE DELETE_member
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
--DEF_A_INSERT_account
CREATE OR REPLACE PROCEDURE a_insert_account(
   sp_account_name 	IN account.account_name%TYPE,
   sp_unit_price 		IN account.unit_price%TYPE,
   sp_Delivery 			IN account.Delivery%TYPE,
   sp_DOC 		    IN account.DOC%TYPE,
   sp_item_seq 		IN account.item_seq%TYPE
   ) AS 
BEGIN
   INSERT INTO account(account_seq,account_name,unit_price,Delivery,DOC,item_seq)
   VALUES(account_seq.nextval,sp_account_name,sp_unit_price,sp_Delivery,sp_DOC,sp_item_seq);
END a_insert_account;
select * from account;
--EXE_A_INSERT_account
EXEC HANBIT.A_INSERT_account('한빛상사','10','5','부품공급업체','1002');
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
DECLARE sp_account_seq number:='1001';sp_count NUMBER;BEGIN exist_account_id(sp_account_seq,sp_count);DBMS_OUTPUT.put_line ('결과값 : '||sp_count); END;   
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
            DBMS_OUTPUT.put_line ('이름 : '||sp_account.account_name||'|| ,단가 : '||sp_account.unit_price);
    END a_find_by_account_id;
--DEF_ALL_account(URSOR VERSION)
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
    DBMS_OUTPUT.PUT_LINE(sp_account.account_seq || ' | ' ||sp_account.account_name||' | '||sp_account.unit_price);
  END LOOP;
  CLOSE sp_cursor;
END;

--DEF_UPDATE_account
CREATE OR REPLACE PROCEDURE a_update_account(
 sp_account_seq in account.account_seq%TYPE,
 sp_account_name in account.account_name%TYPE,
 sp_unit_price in account.unit_price%TYPE,
 sp_Delivery in account.Delivery%TYPE
 )
 AS
 BEGIN
    UPDATE account SET account_name=sp_account_name,unit_price=sp_unit_price,Delivery=sp_Delivery WHERE account_seq=sp_account_seq;
 END;
--EXE_UPDATE_account
BEGIN a_update_account('1001','korea.com','3','45');end a_update_account;
-- DEF_DELETE_account
 CREATE OR REPLACE PROCEDURE a_delete_account(sp_account_id IN account.account_seq%TYPE) AS
 BEGIN DELETE FROM account WHERE account_seq = sp_account_id; END;
 -- EXE DELETE_account
 BEGIN a_delete_account('ACC2'); END;
 select * from account;