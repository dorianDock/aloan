
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
            HandleMessageFromServer(data);
            CloseModal();
        };

        DisplayConfirmationPopup(linkDeletionUrl,objectId,afterAction);
    });

    // When the call is executed to add a step
    function callNewStepTemplate(data){
        $('.stepsField').append(data.partial_view);
        if ($('.stepType').length !== 0) {
            InitializeSelectList('newStepType');
        }
    }

    $('.addAStep').click(function(){
        var url = $(this).data('url');
        var loan_template_id = $(this).data('loantemplateid');
        AjaxRequest(url, {loan_template_id: loan_template_id}, callNewStepTemplate)
    });

});