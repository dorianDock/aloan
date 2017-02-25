
$(document).on('turbolinks:load', function() {
    if ($('.loanTemplatePrerequisite').length !== 0) {
        InitializeSelectList('newLoanTemplate');
        $('.dropdown_clear_button')
            .on('click', function() {
                $('.loanTemplatePrerequisite')
                    .dropdown('clear')
                ;
            })
        ;
    }

    $('.deleteALoanTemplate').click(function(){
        var objectId=$(this).data('objectid');
        var linkDeletionUrl=$(this).data('url');
        var afterAction=function(data){
            if(data.isError===false){
                window.location=data.redirection;
            }
            // HandleMessageFromServer(data);
            CloseModal();
        };

        DisplayConfirmationPopup(linkDeletionUrl,objectId,afterAction);
    });


    // init new step form
    function initNewStepForm(data){
        $('#new_step_container').append(data.partial_view);
        if ($('.stepType').length !== 0) {
            InitializeSelectList('newStepType');
        }
    }

    // show step
    function initShowStep(data){
        $('.stepList').append(data.partial_view);
        bindStepRemovalEvent('.removeStep'+data.step_id);
        bindEditAndRemoveStepEvent('.loan_template_step'+data.step_id);
        if(data.max_release_amount != undefined && data.max_receipt_amount != undefined){
            $('.remainingReleaseNumber').html(data.max_release_amount);
            $('.remainingReceiptNumber').html(data.max_receipt_amount);
        }
        if((data.max_release_amount == undefined && data.max_receipt_amount == undefined) || (data.max_release_amount != 0 || data.max_receipt_amount != 0)){
            $('.addAStep').show();
        }

    }



    // bind the form submit event
    function bindFormSubmitEvent(){
        $('#new_step').submit(function() {
            var valuesToSubmit = $(this).serialize();
            $.ajax({
                type: "POST",
                url: $(this).attr('action'), // submits it to the given url of the form
                data: valuesToSubmit,
                dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
            }).success(function(data){
                $('#new_step_container').html('');
                if(data.success){
                    initShowStep(data);
                } else{
                    // we display the new form again
                    initNewStepForm(data);
                    bindFormSubmitEvent();
                }
            });
            return false; // prevents normal behaviour
        });
    }

    // When the call is executed to add a step
    function callNewStepTemplate(data){
        initNewStepForm(data);
        $('.addAStep').hide();
        bindFormSubmitEvent();

    }

    $('.addAStep').click(function(){
        var url = $(this).data('url');
        var loan_template_id = $(this).data('loantemplateid');
        AjaxRequest(url, {loan_template_id: loan_template_id}, callNewStepTemplate)
    });

    $('.removeStep,.editStep,.validateStep').hide();

    
    function bindStepRemovalEvent(cssClass){
        $(cssClass).click(function(){
            var linkDeletionUrl = $(this).data('url');
            var objectId = $(this).data('objectid');
            var loan_template_id = $(this).data('loantemplateid');
            var parent_type=$(this).data('parenttype');
            var afterAction=function(data){
                if(data.isError===false){
                    window.location=data.redirection;
                }
                HandleMessageFromServer(data);
                CloseModal();
            };

            DisplayConfirmationPopup(linkDeletionUrl,objectId,afterAction,loan_template_id,parent_type);
        });
    }

    bindStepRemovalEvent('.removeStep');
    bindEditAndRemoveStepEvent('.loan_template_step');


    
        


});