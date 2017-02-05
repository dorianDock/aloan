
$(document).on('turbolinks:load', function() {
    if ($('.loanTemplatePrerequisite').length !== 0) {
        InitializeSelectList('newLoanTemplate');
    }
});