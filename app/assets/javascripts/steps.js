
$(document).on('turbolinks:load', function() {
    if ($('.stepEditType').length !== 0) {
        InitializeSelectList('stepEditionType');
    }

});