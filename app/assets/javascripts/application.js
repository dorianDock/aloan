// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/datepicker
//= require turbolinks

//= require flatpickr/dist/flatpickr
//= require semantic-ui
//= require_tree .


$(document).on('turbolinks:load', function () {
    $('.message > .close')
        .on('click', function () {
            $(this)
                .closest('.message')
                .transition('fade')
            ;
        })
    ;

    $('.myCustomSuccessMessage').hide();
    $('.myCustomErrorMessage').hide();

    $('.ui.modal')
        .modal('hide')
    ;

    $('.isPopup')
        .popup({
            inline   : true,
            hoverable: true,

        })
    ;

});

function AjaxRequest(targetUrl, parameters, callBackFunction) {
    $.ajax({
        url: targetUrl,
        data: parameters
    }).done(callBackFunction);
}

function showMessage(classToUseForContainer,classToUseForHeader, classToUseForContent, headerText, contentText){
    $(classToUseForContainer+' > '+classToUseForHeader).html(headerText);
    $(classToUseForContainer+' > '+classToUseForContent).html(contentText);
    $(classToUseForContainer).show();
}

function showSuccess(headerText, contentText) {
    showMessage('.myCustomSuccessMessage','.myCustomSuccessMessageHeader','.myCustomSuccessMessageContent',headerText,contentText);
}

function showError(headerText, contentText) {
    showMessage('.myCustomErrorMessage','.myCustomErrorMessageHeader','.myCustomErrorMessageContent',headerText,contentText);
}

function CloseModal(){
    return false;
}

// Help to manage the errors and the messages coming back form the server
function HandleMessageFromServer(data){
    if(data.isError===true){
        showError(data.responseMessage);
    } else{
        showSuccess(data.responseMessage);
    }
}


// Function about modals and confirmation modals

function DisplayConfirmationPopup(actionToPerform,objectId,afterAction){
    $('.confirmationModal')
        .modal({
            closable  : true,
            onDeny    : function(){
                CloseModal();
            },
            onApprove : function() {
                var parameters = {objectid: objectId};
                AjaxRequest(actionToPerform, parameters, afterAction);
            }
        })
        .modal('setting', 'transition', 'horizontal flip')
        .modal('show')
    ;
}
