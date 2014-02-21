module("DateFieldGroup", {
  setup: function() {
    var $fixture = $('\
      <div>\
        <select>\
          <option value=""></option>\
          <option value="2014">2014</option>\
          <option value="2015" selected="selected">2015</option>\
        </select>\
        <select>\
          <option value=""></option>\
          <option value="6">June</option>\
          <option value="7" selected="selected">July</option>\
        </select>\
        <select>\
          <option value=""></option>\
          <option value="1">1</option>\
          <option value="30" selected="selected">30</option>\
        </select>\
        <select>\
          <option value=""></option>\
          <option value="05">05</option>\
          <option value="23" selected="selected">23</option>\
        </select>\
        <select>\
          <option value=""></option>\
          <option value="00">00</option>\
          <option value="30" selected="selected">30</option>\
        </select>\
      </div>\
    ');
    $('#qunit-fixture').append($fixture);
    this.$dateSelects = $('select', $fixture);

    this.subject = new GOVUK.DateFieldGroup(this.$dateSelects);
  }
});

test("val with no argument returns the selected value as a date", function() {
  ok(this.subject.val() instanceof Date);
  equal(this.subject.val().valueOf(), Date.parse('2015-07-30 23:30:00').valueOf());
});

test("val with no argument return null if one of the date (not time) selects are not selected", function() {
  $(this.$dateSelects[0]).val(null);
  strictEqual(this.subject.val(), null);

  $(this.$dateSelects[0]).val("2015");
  $(this.$dateSelects[1]).val(null);
  strictEqual(this.subject.val(), null);

  $(this.$dateSelects[1]).val("7");
  $(this.$dateSelects[2]).val(null);
  strictEqual(this.subject.val(), null);

  $(this.$dateSelects[2]).val("30");
  $(this.$dateSelects[3]).val(null);
  $(this.$dateSelects[4]).val(null);
  notStrictEqual(this.subject.val(), null);
});

test("val called with a date sets the selects", function() {
  var date = new Date(Date.parse("2014-06-01 05:00:00"));
  this.subject.val(date);
  equal($(this.$dateSelects[0]).val(), "2014")
  equal($(this.$dateSelects[1]).val(), "6")
  equal($(this.$dateSelects[2]).val(), "1")
  equal($(this.$dateSelects[3]).val(), "05")
  equal($(this.$dateSelects[4]).val(), "00")
});

test("val called with a string attempts to parse that string and set a date from it", function() {
  this.subject.val("2014-06-01 05:00:00");
  equal($(this.$dateSelects[0]).val(), "2014")
  equal($(this.$dateSelects[1]).val(), "6")
  equal($(this.$dateSelects[2]).val(), "1")
  equal($(this.$dateSelects[3]).val(), "05")
  equal($(this.$dateSelects[4]).val(), "00")
});

test("val called with null clears the date fields", function() {
  this.subject.val(null);
  equal($(this.$dateSelects[0]).val(), "")
  equal($(this.$dateSelects[1]).val(), "")
  equal($(this.$dateSelects[2]).val(), "")
  equal($(this.$dateSelects[3]).val(), "")
  equal($(this.$dateSelects[4]).val(), "")
});
