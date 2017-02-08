$(document).on('turbolinks:load', function(){

    flatpickr('.loanStartDate',{
        altInput: true,
        altFormat: "j/m/Y"
    });
    var contractualEndDatePicker = flatpickr('.loanContractualEndDate',{
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

    function displaySingleLoanTemplate(data){
        console.log(data);
        $("input[name='loan[amount]']").val(data.amount);
        $("input[name='loan[rate]']").val(data.rate);
        var startDate = $('#loan_start_date').val();
        var dateParsed = moment(startDate, "YYYY-MM-DD");
        // if a value is set, we change the value of contractual end date also
        if(dateParsed != undefined){
            var result = dateParsed.add(data.duration, 'months');
            contractualEndDatePicker.setDate(result.format('YYYY-MM-DD'));
        }

    }

    function onChangeNewLoanLoanTemplate(value, text, $choice){
        var retrieveInfoOnALoanTemplate = $('.loanLoanTemplate' + ' > select').data('singleobjecturl');
        var parameters = {objectid: value};
        AjaxRequest(retrieveInfoOnALoanTemplate, parameters, displaySingleLoanTemplate);
        console.log(value);
        console.log(text);
        console.log($choice);
    }


    if($('.loanLoanTemplate').length!==0){
        InitializeSelectList('newLoanLoanTemplate',onChangeNewLoanLoanTemplate);
    }



});