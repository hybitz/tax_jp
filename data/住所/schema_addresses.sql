create table addresses (
  zip_code char(7) not null,
  prefecture_code char(2) not null,
  prefecture_name varchar(4) not null
);

create unique index index_zip_code_on_addresses on addresses(zip_code);
