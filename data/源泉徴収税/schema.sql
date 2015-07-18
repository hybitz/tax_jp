create table withheld_taxes (
  valid_from date not null,
  valid_until date not null,
  salary_range_from integer not null,
  salary_range_to integer not null,
  dependent_0 integer not null,
  dependent_1 integer not null,
  dependent_2 integer not null,
  dependent_3 integer not null,
  dependent_4 integer not null,
  dependent_5 integer not null,
  dependent_6 integer not null,
  dependent_7 integer not null,
  sub_salary integer not null
);
