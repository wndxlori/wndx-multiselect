// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
    $('div.multiselect').each( function(boxIndex,box) {
       new WNDX.Multiselect( $(box) ).initialize();
    });

});