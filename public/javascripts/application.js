// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {

    $("#sign_up_btn").button();
    
    $("#user_submit").button();
    
    $("#event_submit").button();

    $("#place_submit").button();

    $("#event_event_date").datepicker();
    //$("#event_event_date").datepicker({ dateFormat: 'dd-mm-yy' });
    $("#event_event_date").datepicker("show");
    
    
//client side voting update

    $(".vote_up").click(function(e) { 
	var e_id = $(".event").data("event");
	var p_id = $(this).data("place");
	var votes_remaining = parseInt( $("#votes_remaining").text() );
	var votes = _abs_sum_vote();
	var total = votes + votes_remaining;

	var orig_vote = parseInt( $(this).next('.vote_count').text() );

	//need sign in check?


	if ( ( Math.abs(orig_vote + 1) < Math.abs(orig_vote) )  || votes_remaining -1 >= 0) {
	    $(this).next('.vote_count').html( orig_vote + 1 );

	    vote(e_id, p_id, 1);

	    //update votes remaining
	    $("#votes_remaining").html( total - _abs_sum_vote() );

	    //total vote update
 	    total_vote = parseInt($(this).parents().find('.place_total_votes_count').first().text());
	    $(this).parents().find('.place_total_votes_count').first().text(total_vote + 1);

	}
	else {
	    //error
	}
    })


    $(".vote_down").click(function() { 
	var e_id = $(".event").data("event");
	var p_id = $(this).data("place");
	var votes_remaining = parseInt( $("#votes_remaining").text() );
	var votes = _abs_sum_vote();
	var total = votes + votes_remaining;

	var orig_vote =	parseInt( $(this).prev('.vote_count').text() );


	if ( ( Math.abs(orig_vote - 1) < Math.abs(orig_vote) ) || votes_remaining -1 >= 0) {

	    $(this).prev('.vote_count').html(orig_vote - 1 );
	    
	    vote(e_id, p_id, -1);

	    //update votes remaining
	    $("#votes_remaining").html( total - _abs_sum_vote() );

	    //total vote update
 	    total_vote = parseInt($(this).parents().find('.place_total_votes_count').first().text());
	    $(this).parents().find('.place_total_votes_count').first().text(total_vote -  1);

	}
	else {
	    //error
	}
    })

    
})

function _valid_vote(vote, votes) {
    
}


function _abs_sum_vote() {
    var count = 0;

    $('.vote_count').each( function()  {
	count += Math.abs(parseInt($(this).text() ) );
	//console.log(this.innerHTML);
    });


    return count;
}



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