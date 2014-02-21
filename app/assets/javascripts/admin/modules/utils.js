(function() {
  "use strict";
  window.GOVUK = window.GOVUK || {};

  var Utils = {
    padNumber: function padNumber(number, targetLength) {
      number = String(number);
      while ( number.length < targetLength ) {
        number = "0" + number
      }
      return number;
    }
  };

  window.GOVUK.Utils = Utils;
}());
