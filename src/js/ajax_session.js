/**
 * ajax_session.js: this script utilizes ajax to retrieve data from
 *                  'retriever_session.php'. Specifically, the 'svm_title', and
 *                  'id_entity' values are taken from EAV data model, database
 *                  tables, and inserted into the DOM element 'svm_session_id'.
 */

$(document).ready(function() {
  $('select[name="svm_session"]').on('change', function(event) {
    event.preventDefault();




var container = document.querySelector('form');
var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {

      if ( mutation.type == 'childList' && typeof mutation.addNodes == 'Object' && mutation.addNodes.length > 0 ) {
        console.log("Recording mutation:", mutation.attributeName);
      }

    });
  });

observer.observe(container, {
    attributes: true,
    attributeFilter: ['name'],
    childList: true,
    subtree: true,
});




    if ( $('.fieldset_session_data_upload').length > 0 && $('select['name="svm_session_id"]').length > 0 ) {
    // AJAX Process
      $.ajax({
        type: 'POST',
        url: '../../php/retriever_sesion.php',
        dataType: 'json',
        beforeSend: function() {
          ajaxLoader( $(event.currentTarget) );
        }
      }).done(function(data) {

      // Append to DOM
        $.each( data['return'], function( index, value ) {
          var value_id    = value['value_id'];
          var value_title = value['value_title'];
          var element     = '<option ' + 'value="' + value_id + '">' + value_title + '</option>';

          $('select[name="svm_session_id"]').append( element );

        // Remove AJAX Overlay
          $('form .ajax_overlay').fadeOut(200, function(){ $(this).remove() });
        })

      }).fail(function(jqXHR, textStatus, errorThrown) {
        console.log('Error Thrown: '+errorThrown);
        console.log('Error Status: '+textStatus);

      // Remove AJAX Overlay
        $('form .ajax_overlay').fadeOut(200, function(){ $(this).remove() });
      });
    }

  });
});
