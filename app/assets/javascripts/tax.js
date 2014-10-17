if (typeof tax === "undefined") {
  var tax = {};
}

tax.NONTAXABLE = 1; // 非課税
tax.INCLUSIVE = 2; // 内税
tax.EXCLUSIVE = 3; // 外税

tax.RATE_3 = Date.parse('1989-04-01');
tax.RATE_5 = Date.parse('1997-04-01');
tax.RATE_8 = Date.parse('2014-04-01');

tax.getRateOn = function(date) {
  if (typeof date === 'string') {
    date = Date.parse(date);
  }
  
  if (date >= tax.RATE_3 && date < tax.RATE_5) {
    return 0.03;
  } else if (date >= tax.RATE_5 && date < tax.RATE_8) {
    return 0.05;
  } else if (date >= tax.RATE_8) {
    return 0.08;
  }
  
  return 0;
};

tax.calcTaxAmount = function(taxType, rate, amount) {
  if ( isNaN( amount ) ) {
    return '';
  }

  if ( taxType == tax.INCLUSIVE ) {
    return parseInt(amount * rate / (1 + rate));
  }
  else if ( taxType == tax.EXCLUSIVE ) {
    return parseInt(amount * rate); 
  }

  return '';
};
