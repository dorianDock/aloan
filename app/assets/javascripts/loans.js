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
        toggleFieldsIfLoanTemplatePresent();
    }

    function toggleFieldsIfLoanTemplatePresent(){
        var selectList = $('.editLoanLoanTemplate > select');
        var objectLink = selectList.data('objectlinkid');
        if (!selectList.data('blockfields') && objectLink != undefined && objectLink != "") {
            // we disable the amount, the rate, the contractual end date
            $("input[name='loan[amount]']").parent('.field').addClass('disabled');
            $("input[name='loan[rate]']").parent('.field').addClass('disabled');
            $("input[name='loan[contractual_end_date]']").parent('.field').addClass('disabled');
            selectList.data('blockfields',true);
        } else {
            // we enable again the amount, the rate, the contractual end date
            $("input[name='loan[amount]']").parent('.field').removeClass('disabled');
            $("input[name='loan[rate]']").parent('.field').removeClass('disabled');
            $("input[name='loan[contractual_end_date]']").parent('.field').removeClass('disabled');
            selectList.data('blockfields',false);
        }
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
        //toggleFieldsIfLoanTemplatePresent();
        //InitializeSelectList('editLoanLoanTemplate');
        $('.dropdown_clear_button')
            .on('click', function() {
                $('.editLoanLoanTemplate')
                    .dropdown('clear')
                ;
                //toggleFieldsIfLoanTemplatePresent();
            })
        ;
    }





});