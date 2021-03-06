// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require materialize
//= require_tree .

document.addEventListener('DOMContentLoaded', function(){
    var options = null;
    var elems = document.querySelectorAll('.tooltipped');
    var instances = M.Tooltip.init(elems, options);

    var searchClose = document.getElementById("close");
    var searchInput = document.getElementById("search");
    var searchForm = document.getElementById("form-search");
    if (typeof(searchClose) != 'undefined' && searchClose != null)
    {
        searchClose.onclick=function() {
            searchInput.value = "";
            searchForm.submit();
        }
    }
});
