create table health_insurances (
  valid_from date not null,
  valid_until date not null,
  prefecture_code char(2),
  general decimal(1,4) not null,
  care decimal(1,4) not null,
  particular decimal(1,4) not null,
  basic decimal(1,4) not null
);
