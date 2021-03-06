
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
});