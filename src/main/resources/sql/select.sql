====== select ========

select * from member;
select * from item;
select * from account;
select * from quotation;
select * from subject;
select * from tab;
select * from sysobjects;
CREATE sequence seq increment by 1 start with 1000 nocycle;
SELECT SEQUENCE_OWNER, SEQUENCE_NAME FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'HANBIT';
DROP SEQUENCE SEQ;
