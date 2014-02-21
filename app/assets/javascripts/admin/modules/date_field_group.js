(function() {
  "use strict";
  window.GOVUK = window.GOVUK || {};

  function DateFieldGroup($dateFields) {
    for ( var key in $dateFields ) {
      if ( typeof $dateFields[key] == "function" ) {
        this[key] = $dateFields[key];
      }
    }

    function val(value) {
      if (value === undefined) {
        // Getter
        if ( !($dateFields[0].value && $dateFields[1].value && $dateFields[2].value) )
          return null;
        else {
          return new Date(
            $dateFields[0].value,
            Number($dateFields[1].value) - 1,
            Number($dateFields[2].value),
            $dateFields[3].value,
            $dateFields[4].value
          );
        }
      }
      else {
        // Setter
        if (!value) {
          $dateFields.val(null);
        }
        else {
          value = new Date(Date.parse(value));
          $($dateFields[0]).val(value.getFullYear());
          $($dateFields[1]).val(value.getMonth()+1);
          $($dateFields[2]).val(value.getDate());
          $($dateFields[3]).val(GOVUK.Utils.padNumber(value.getHours(), 2));
          $($dateFields[4]).val(GOVUK.Utils.padNumber(value.getMinutes(), 2));
        }
      }
    }
    this.val = val;
  }

  window.GOVUK.DateFieldGroup = DateFieldGroup;
}());
