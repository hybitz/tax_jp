create table applicable_items (
  valid_from date not null,
  valid_until date not null,
  measure_name varchar(255) not null,
  item_name varchar(255) not null,
  item_no varchar(5) not null,
  applicable_to varchar(255) not null
);
