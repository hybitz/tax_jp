if (typeof tax === "undefined") {
  var tax = {};
}

tax.NONTAXABLE = 1; // 非課税
tax.INCLUSIVE = 2; // 内税
tax.EXCLUSIVE = 3; // 外税

tax.RATE_3 = Date.parse('1989-04-01');

tax.consumptionTaxes = [
    {date: Date.parse('2014-04-01'), rate: 0.08},
    {date: Date.parse('1997-04-01'), rate: 0.05},
    {date: Date.parse('1989-04-01'), rate: 0.03},
];

tax.getRateOn = function(date, options) {
  if (typeof date === 'string') {
    date = Date.parse(date);
  }
  options = options || {};

  var ret = 0;
  for (var i = 0; this.consumptionTaxes.length; i ++) {
    ret = this.consumptionTaxes[i].rate;
    if (date >= this.consumptionTaxes[i].date) {
      break;
    }
  }

  if (options.percent) {
    ret *= 100;
  }
  
  return ret;
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
