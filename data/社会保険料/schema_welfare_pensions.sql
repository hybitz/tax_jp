create table welfare_pensions (
  valid_from date not null,
  valid_until date not null,
  general decimal(1,5) not null,
  particular decimal(1,5) not null,
  child_support decimal(1,5) not null
);
