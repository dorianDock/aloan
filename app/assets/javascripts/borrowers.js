
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


    $('.deleteALink').click(function(){
        var linkId=$(this).data('linkid');
        var linkDeletionUrl=$(this).data('url');
        var afterAction=function(data){
            if(data.isError===false){
                $('#edit_useful_link_'+linkId).remove();
            }

            HandleMessageFromServer(data);
            CloseModal();
        };

        DisplayConfirmationPopup(linkDeletionUrl,linkId,afterAction);
    });


});

