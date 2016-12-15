
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


});

