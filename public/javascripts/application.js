// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {

    $("#sign_up_btn").button();
    
    $("#user_submit").button();
    
    $("#event_submit").button();

    $("#place_submit").button();


    $(".vote_up").click(function(e) { 
	var e_id = $(".event").data("event");
	var p_id = $(this).data("place");

	//need sign in check

	$(this).next('.vote_count').html(
	    parseInt( $(this).next('.vote_count').html() ) + 1 );

	vote(e_id, p_id, 1);
	
    })

    $(".vote_down").click(function() { 
	var e_id = $(".event").data("event");
	var p_id = $(this).data("place");

	$(this).prev('.vote_count').html(
	    parseInt( $(this).prev('.vote_count').html() ) - 1 );

	vote(e_id, p_id, -1);
    })


})


function vote(e_id, p_id, v) {
    var auth = $("meta[name=csrf-token]").attr("content")

	$.ajax({
	    type: "POST",
	    url: "/votes/",
	    dataType: "json",
	    data: $.param({event_id: e_id, place_id: p_id, vote: v, 
			   authenticity_token: auth
			  }),
	    error: {
	    
	    },
	    success: function(data, textStatus) {
		var obj = $.parseJSON(data);
		//console.log(obj);		
	    },
	    complete: function(xhr) {

	    }
	});



}