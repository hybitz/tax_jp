create table depreciation_rates (
  valid_from date not null,
  valid_until date not null,
  durable_years integer not null,
  fixed_amount_rate decimal(1,6) not null,
  rate decimal(1,6) not null,
  revised_rate decimal(1,6) not null,
  guaranteed_rate decimal(1,6) not null
);
