$(document).on('turbolinks:load', function(){

    flatpickr('.loanStartDate',{
        altInput: true,
        altFormat: "j/m/Y"
    });
    flatpickr('.loanContractualEndDate',{
        altInput: true,
        altFormat: "j/m/Y"
    });
    flatpickr('.loanEndDate',{
        altInput: true,
        altFormat: "j/m/Y"
    });
    
    if($('.loanBorrower').length!==0){
        InitializeSelectList('newLoanBorrower');
    }

});