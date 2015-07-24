create table grades (
  valid_from date not null,
  valid_until date not null,
  grade integer not null,
  pension_grade integer not null,
  monthly_standard integer not null,
  daily_standard integer not null,
  salary_from integer not null,
  salary_to integer not null
);
