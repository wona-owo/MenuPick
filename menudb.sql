-- 작성자 : 김찬희
drop table tbl_dinner cascade constraints;
drop table tbl_food cascade constraints;
drop table tbl_menu;
drop table tbl_member cascade constraints;
drop table tbl_like;
drop table tbl_review cascade constraints;
drop table tbl_book;
drop table tbl_recommend;
drop table tbl_report;

drop sequence seq_dinner;
drop sequence seq_member;
drop sequence seq_review;
drop sequence seq_book;

create table
  tbl_dinner (
    dinner_no varchar2 (11) primary key,
    dinner_name varchar2 (100) not null,
    dinner_addr varchar2 (100) not null,
    dinner_open varchar2 (20) not null,
    dinner_close varchar2 (20) not null,
    dinner_phone char(13) not null,
    dinner_email varchar2 (30) not null,
    dinner_parking char(1) not null check (dinner_parking in ('y', 'n')),
    dinner_max_person number not null, -- 최대 수용 인원
    busi_no char(12) not null, -- 사업자 등록 번호
    dinner_id varchar2 (20) not null,
    dinner_pw varchar2 (60) not null,
    dinner_confirm char(1) default 'n' check (dinner_confirm in ('y', 'n')) -- 승인 여부
  );



-- 'd' || to_char(sysdate, 'yymmdd') || lpad (seq_dinner.nextval, 4, '0')
create sequence seq_dinner maxvalue 9999 cycle;

-- Inserting dinner1 account confirmed
insert into tbl_dinner values ( 'd' || to_char (sysdate, 'yymmdd') || lpad (seq_dinner.nextval, 4, '0'), '식당하나 이름', '식당하나 주소', '0900', '2200', '010-1111-1111', 'blackeagle10@icloud.com', 'y', '30', '111111111111', 'dinner11234', 'dinner11234@', 'y');

-- Inserting dinner2 account unconfirmed
insert into tbl_dinner values ( 'd' || to_char (sysdate, 'yymmdd') || lpad (seq_dinner.nextval, 4, '0'), '식당둘 이름', '식당둘 주소', '1000', '2000', '010-2222-2222', 'blackeagle10@icloud.com', 'y', '30', '222222222222', 'dinner21234', 'dinner21234@', 'n');

select * from tbl_dinner;

create table
  tbl_food (
    food_no varchar2 (11) primary key,
    food_name varchar2 (30) not null,
    food_nation varchar2 (30) not null,
    food_cat varchar2 (30) not null
  );

create table
  tbl_menu (
    dinner_no varchar2 (11) not null references tbl_dinner (dinner_no) on delete cascade,
    food_no varchar2 (11) not null references tbl_food (food_no) on delete cascade,
    price number not null,
    primary key (dinner_no, food_no) -- 프라이머리 키 두개
  );

create table
  tbl_member (
    member_no varchar2 (11) primary key,
    member_id varchar2 (30) not null,
    member_pw varchar2 (60) not null,
    member_name varchar2 (30) not null,
    member_nick varchar2 (30) not null,
    member_phone char(13) not null,
    member_addr varchar2 (100) not null,
    member_gender char(1) not null check (member_gender in ('m', 'f')),
    member_email varchar2 (30) not null,
    enroll_date date default sysdate not null,
    adult_confirm char(1) default 'n' check (adult_confirm in ('y', 'n')),
    member_level number default 3 not null check (member_level in (1, 2, 3))
  );


-- 'm' || to_char(sysdate, 'yymmdd') || lpad (seq_member.nextval, 4, '0')
create sequence seq_member maxvalue 9999 cycle;

-- Inserting admin account
insert into tbl_member values ( 'm' || to_char (sysdate, 'yymmdd') || lpad (seq_member.nextval, 4, '0'), 'admin999', 'admin999@', '관리자 이름', '관리자 별명', '010-8645-5542', '경기도 용인시 기흥구', 'm', 'blackeagle10@icloud.com', sysdate, 'y', '1');

-- Inserting user1 female, none adult, level 2 account
insert into tbl_member values ( 'm' || to_char (sysdate, 'yymmdd') || lpad (seq_member.nextval, 4, '0'), 'user11234', 'user11234@', '유저하나 이름', '유저하나 별명', '010-1111-1111', '유저하나 주소', 'f', 'blackeagle10@icloud.com', sysdate, 'n', '2');

-- Inserting user2 male, adult, level 3 account
insert into tbl_member values ( 'm' || to_char (sysdate, 'yymmdd') || lpad (seq_member.nextval, 4, '0'), 'user21234', 'user21234@', '유저둘 이름', '유저둘 별명', '010-2222-2222', '유저둘 주소', 'm', 'blackeagle10@icloud.com', sysdate, 'y', '3');

select * from tbl_member;

create table
  tbl_like (
    dinner_no varchar2 (11) not null references tbl_dinner (dinner_no) on delete cascade,
    member_no varchar2 (11) not null references tbl_member (member_no) on delete cascade,
    primary key (dinner_no, member_no) -- 프라이머리 키 두개
  );

create table
  tbl_review (
    review_no varchar2 (11) primary key,
    dinner_no varchar2 (11) references tbl_dinner (dinner_no) on delete cascade,
    member_no varchar2 (11) references tbl_member (member_no) on delete cascade,
    review_con varchar2 (2000),
    review_img blob,
    review_date date
  );

-- 'r' || to_char(sysdate, 'yymmdd') || lpad (seq_review.nextval, 4, '0')
create sequence seq_review maxvalue 9999 cycle;

create table
  tbl_book (
    book_no varchar2 (11),
    dinner_no varchar2 (11) references tbl_dinner (dinner_no) on delete cascade,
    member_no varchar2 (11) references tbl_member (member_no) on delete cascade,
    book_date date,
    book_time varchar2 (20),
    book_cnt number
  );

-- 'b' || to_char(sysdate, 'yymmdd') || lpad (seq_book.nextval, 4, '0')
create sequence seq_book maxvalue 9999 cycle;

-- Insert into tbl_book
insert into tbl_book values ( 'b' || to_char(sysdate, 'yymmdd') || lpad(seq_book.nextval, 4, '0'), 'd2411060001', 'm2411060002', to_date('24/11/15', 'yy/mm/dd'), '1230', 4);

create table
  tbl_recommend (
    review_no varchar2 (11) references tbl_review (review_no) on delete cascade,
    member_no varchar2 (11) references tbl_member (member_no) on delete cascade,
    report char(1) default 'n' not null check (report in ('n', 'y')),
    primary key (review_no, member_no)
  );

-- 수정 로그 : tbl_dinner dinner_addr, dinner_name  / member_addr 컬럼 자료형 크기 조정
alter table tbl_dinner modify dinner_addr varchar2(100);
alter table tbl_dinner modify dinner_name varchar2(100);
alter table tbl_member modify member_addr varchar2(100);

commit;
