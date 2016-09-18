--DEF_UPDATE_account
CREATE OR REPLACE PROCEDURE a_update_account(
 sp_account_id in account.account_seq%TYPE,
 sp_pw in account.pw%TYPE,
 sp_email in account.email%TYPE,
 sp_phone in account.phone%TYPE
 )
 AS
 BEGIN
    UPDATE account SET pw=sp_pw,email=sp_email,phone=sp_phone WHERE account_seq=sp_account_id;
 END;
--EXE_UPDATE_account
BEGIN a_update_account('hong','1','math@test.com','123-1234-1234');end a_update_account;
-- DEF_DELETE_account
 CREATE OR REPLACE PROCEDURE a_delete_account(sp_account_id IN account.account_seq%TYPE) AS
 BEGIN DELETE FROM account WHERE account_seq = sp_account_id; END;
 -- EXE DELETE_account
 BEGIN a_delete_account('ACC2'); END;
 select * from account;