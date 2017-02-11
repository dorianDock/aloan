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
    if($('.loanBorrowerEdition').length!==0){
        InitializeSelectList('editLoanBorrower');
    }



    function displaySingleLoanTemplate(data){
        $("input[name='loan[amount]']").val(data.amount);
        $("input[name='loan[rate]']").val(data.rate);
        var startDate = $('#loan_start_date').val();
        // if a value is set, we change the value of contractual end date also
        if(startDate != undefined && startDate != ''){
            var dateParsed = moment(startDate, "YYYY-MM-DD");
            var result = dateParsed.add(data.duration, 'months');
            contractualEndDatePicker.setDate(result.format('YYYY-MM-DD'));
        }

    }

    function onChangeNewLoanLoanTemplate(value, text, $choice){
        var retrieveInfoOnALoanTemplate = $('.loanLoanTemplate' + ' > select').data('singleobjecturl');
        var parameters = {objectid: value};
        AjaxRequest(retrieveInfoOnALoanTemplate, parameters, displaySingleLoanTemplate);
    }

    function onChangeLoanLoanTemplateEdition(value, text, $choice){
        var retrieveInfoOnALoanTemplate = $('.editLoanLoanTemplate' + ' > select').data('singleobjecturl');
        var parameters = {objectid: value};
        AjaxRequest(retrieveInfoOnALoanTemplate, parameters, displaySingleLoanTemplate);
    }


    if($('.loanLoanTemplate').length!==0){
        InitializeSelectList('newLoanLoanTemplate',onChangeNewLoanLoanTemplate);
        $('.dropdown_clear_button')
            .on('click', function() {
                $('.newLoanLoanTemplate')
                    .dropdown('clear')
                ;
            })
        ;
    }

    if($('.loanLoanTemplateEdition').length!==0){
        InitializeSelectList('editLoanLoanTemplate',onChangeLoanLoanTemplateEdition);
        //InitializeSelectList('editLoanLoanTemplate');
        $('.dropdown_clear_button')
            .on('click', function() {
                $('.editLoanLoanTemplate')
                    .dropdown('clear')
                ;
            })
        ;
    }





});