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


    bindEditAndRemoveStepEvent('.loan_step');

    function bindStepRemovalEvent(cssClass){
        $(cssClass).click(function(){
            var linkDeletionUrl = $(this).data('url');
            var objectId = $(this).data('objectid');
            var loan_id = $(this).data('loanid');
            var parent_type=$(this).data('parenttype');
            var afterAction=function(data){
                if(data.isError===false){
                    window.location=data.redirection;
                }
                HandleMessageFromServer(data);
                CloseModal();
            };

            DisplayConfirmationPopup(linkDeletionUrl, objectId, afterAction, loan_id, parent_type, cssClass);
        });
    }

    bindStepRemovalEvent('.removeStep');

    // When we click on the sync button
    function handleSyncResponse(data){
        // we receive the new list of steps from the server
        if(data.partial_view){
            $('.step_list_container').html(data.partial_view);
        }
        HandleMessageFromServer(data);
        bindEditAndRemoveStepEvent('.loan_step');
        bindStepRemovalEvent('.removeStep');
        $('.synchronizeSteps').hide();
        $('.synchronizeStepsIcon').hide();
    }


    if($('.synchronizeSteps').length!==0){
        $('.synchronizeSteps').click(function(){
            var url = $(this).data('url');
            var loan_id = $(this).data('objectid');
            AjaxRequest(url, {objectid: loan_id}, handleSyncResponse)
        });
    }


    function bindStepValidationEvent(cssClass){
        $(cssClass).click(function(){
            var linkDeletionUrl = $(this).data('url');
            var objectId = $(this).data('objectid');
            var loan_id = $(this).data('loanid');
            var parent_type = $(this).data('parenttype');

            var afterAction = function(data){
                if(data.is_error===false){
                    window.location=data.redirection;
                }
                HandleMessageFromServer(data);
                CloseModal();
            };

            DisplayConfirmationPopup(linkDeletionUrl, objectId, afterAction, loan_id, parent_type, cssClass);
        });
    }

    bindStepValidationEvent('.validateStep');

});