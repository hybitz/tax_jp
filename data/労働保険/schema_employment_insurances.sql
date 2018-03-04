create table employment_insurances (
  valid_from date not null,
  valid_until date not null,
  employee_general decimal(1,4) not null,
  employer_general decimal(1,4) not null,
  employee_agric decimal(1,4) not null,
  employer_agric decimal(1,4) not null,
  employee_const decimal(1,4) not null,
  employer_const decimal(1,4) not null
);
