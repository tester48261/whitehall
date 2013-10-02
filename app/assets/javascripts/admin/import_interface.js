GOVUK.importInterface = (function() {
  var callbacks = {
    'new-row': function(payload) {
      console.log('test')
    }
  };

  return {
    init: function() {
      var $runImportForm = $('#run-import').closest('form');
      $runImportForm.submit(function(event) {
        $.post($runImportForm.attr('action'), $runImportForm.serialize());
        return false;
      })

      $('.import').each(function(index, importTable) {
        var $importTable = $(importTable);
        var importId = $importTable.data('import-id');

        var ws = new WebSocket("ws://localhost:8081/imports/"+importId);
        ws.onopen = function() {
          $('#import-connection-status').hide();
        };
        ws.onclose = function() {
          $('#import-connection-status').show();
        };

        ws.onmessage = function(messageEvent) {
          var update = JSON.parse(messageEvent.data);
          (callbacks[update['event']] || function(){})(update['payload']);
        };
      });
    }
  };
}());
