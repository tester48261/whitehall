(function() {
  // "use strict";
  window.GOVUK = window.GOVUK || {};

  var AnnouncePublicationFields = {
    init: function init(args) {
      this.allowedTypeIds = args['allowed_type_ids'];

      var $form              = $('form.js-edition-form');
      this.$typeSelect       = $('select#edition_publication_type_id', $form);
      this.$announceFieldset = $('.js-announce-fieldset', $form);

      this.AnnounceFieldset.init(this.$announceFieldset);

      this.$typeSelect.change(this.showHideAnnounceFieldset);
      this.showHideAnnounceFieldset();
    },

    showHideAnnounceFieldset: function showHideAnnounceFieldset() {
      if ( this.allowedTypeIds.indexOf(Number(this.$typeSelect.val())) >= 0 ) {
        this.AnnounceFieldset.show();
      }
      else {
        this.AnnounceFieldset.hide();
      }
    },

    AnnounceFieldset: {
      init: function init($fieldset) {
        this.$fieldset         = $fieldset;
        this.$announceFields   = $('.js-announce-fields', this.$fieldset);
        this.dateFields        = new GOVUK.DateFieldGroup($('select.date', this.$announceFields));
        this.$dateTextField    = $('#edition_announced_publication_date_text', this.$announceFields);
        this.$summaryField     = $('#edition_announced_publication_summary', this.$announceFields);
        this.$announceCheckbox = makeAnnounceCheckbox();

        this.dateValue     = this.dateFields.val();
        this.dateTextValue = this.$dateTextField.val();
        this.summaryValue  = this.$summaryField.val();

        if ( this.dateValue ) {
          this.$announceCheckbox.attr('checked', 'checked');
        }
        else {
          this.$announceCheckbox.attr('checked', null);
          this.hideAnnounceFields();
        }

        this.$announceCheckbox.change(this.showHideAnnounceFields);

        function makeAnnounceCheckbox() {
          var announceCheckboxAndLabel = $('<label class="checkbox"><input type="checkbox" />Announce the publication date of this document</label>');
          $(".js-announce-fields", this.$fieldset).before(announceCheckboxAndLabel);
          return $('input', announceCheckboxAndLabel);
        }
      },

      show: function show() {
        this.$fieldset.show();
      },

      hide: function hide() {
        this.$fieldset.hide();
      },

      showHideAnnounceFields: function showHideAnnounceFields() {
        if ( this.$announceCheckbox.is(':checked') )
          this.showAnnounceFields();
        else
          this.hideAnnounceFields();
      },

      showAnnounceFields: function showAnnounceFields() {
        this.dateFields.val(this.dateValue);
        this.$dateTextField.val(this.dateTextValue);
        this.$summaryField.val(this.summaryValue);

        this.$announceFields.slideDown(200);
      },

      hideAnnounceFields: function hideAnnounceFields() {
        this.$announceFields.slideUp(200);

        this.dateValue     = this.dateFields.val();
        this.dateTextValue = this.$dateTextField.val();
        this.summaryValue  = this.$summaryField.val();

        this.dateFields.val(null);
        this.$dateTextField.val(null);
        this.$summaryField.val(null);
      }
    }
  };

  GOVUK.Proxifier.proxifyAllMethods(AnnouncePublicationFields);
  GOVUK.Proxifier.proxifyAllMethods(AnnouncePublicationFields.AnnounceFieldset);

  GOVUK.AnnouncePublicationFields = AnnouncePublicationFields;
}());
