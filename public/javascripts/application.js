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
	var votes_remaining = $("#votes_remaining").html();

	//need sign in check?
	if (votes_remaining > 0) {
	    $(this).next('.vote_count').html(
		parseInt( $(this).next('.vote_count').html() ) + 1 );

	    vote(e_id, p_id, 1);
	    $("#votes_remaining").html( --votes_remaining);
	}
	else {

	}
    })

    $(".vote_down").click(function() { 
	var e_id = $(".event").data("event");
	var p_id = $(this).data("place");
	var votes_remaining = $("#votes_remaining").html();

	if (votes_remaining > 0) {
	    $(this).prev('.vote_count').html(
		parseInt( $(this).prev('.vote_count').html() ) - 1 );
	    
	    vote(e_id, p_id, -1);
	    $("#votes_remaining").html( --votes_remaining);
	}
	else {
		//error
	}
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