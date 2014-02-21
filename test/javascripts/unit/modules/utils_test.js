module("General utilities");

test("padNumber should return number as a string padded to target length", function() {
  strictEqual(GOVUK.Utils.padNumber(23, 5), "00023");
});
