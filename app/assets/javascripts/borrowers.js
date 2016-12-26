
$(document).on('turbolinks:load', function(){
    // $('.borrowerBirthDate').datepicker({
    //     dateFormat: "dd/mm/yy",
    //     changeMonth: true,
    //     changeYear: true,
    //     yearRange: "1902:1999"
    // });

    flatpickr('.borrowerBirthDate',{
        altInput: true,
        altFormat: "j/m/Y"
    });


    $('.deleteABorrower').click(function(){
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

