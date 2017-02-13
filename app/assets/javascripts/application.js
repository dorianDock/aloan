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
//= require moment

//= require_tree .


$(document).on('turbolinks:load', function () {
    // $('.ui.dropdown')
    //     .dropdown();
    // ;

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

// Initialize function for select lists
function InitializeSelectList(aCssClass, callBackOnChange) {
    var myElement = $('.' + aCssClass);
    var myUrl = myElement.data('url');
    var placeHolder = myElement.data('placeholder');
    var withoutSearch = myElement.data('withoutsearch');
    var preselect = myElement.data('preselect');
    if(myUrl==undefined){
        myUrl = $('.' + aCssClass+' > select').data('url');
    }
    if(callBackOnChange==undefined){
        callBackOnChange = function(){};
    }
    $.ajax({
        url: myUrl,
        data: {}
    }).done(function (data) {
        var firstValue=0;
        if(withoutSearch){
            myElement
                .dropdown({
                    onChange: callBackOnChange
                });
        } else {
            myElement
                .dropdown({
                    placeholder: placeHolder,
                    apiSettings: {
                        url: myUrl + '&query={query}'
                    },
                    onChange: callBackOnChange
                });
        }

        for (var i = 0; i < data.results.length; i++) {
            firstValue = data.results[i].value;
            $('.' + aCssClass + ' > select').append('<option value="' + data.results[i].value + '">' + data.results[i].name + '</option>');
        }

        if(preselect == true){
            setTimeout(function(){
                $('.' + aCssClass).dropdown('set selected', '2');
            },1);
        }
        
        // objectLink is the entity by which we are going to take the data already set
        var objectLink = $('.' + aCssClass + ' > select').data('objectlinkid');
        if (objectLink != undefined && objectLink != "") {
            var initializeUrl = $('.' + aCssClass + ' > select').data('initializeurl');
            var changeTheDropDown = function (data) {
                if(data == null){
                    return;
                }
                // we change the data from [] to [""]
                for (i = 0; i < data.length; i++) {
                    data[i] = data[i].toString();
                }
                $('.' + aCssClass).dropdown('set selected', data);
            };
            var parameters = {objectid: objectLink};
            AjaxRequest(initializeUrl, parameters, changeTheDropDown);
        }


    });





}

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
