// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var is_event_expired = false;

$(document).ready(function() {


    $("#tabs").tabs();

    $("#sign_up_btn").button();
    
    $("#user_submit").button();
    
    $("#event_submit").button();

    $("#place_submit").button();

    $("#search_header_btn").button();

    var event_date = new Date( $('#time_remaining').text() );

    date_countdown(event_date);


/*manual place addition */
    
    if ( $("#manual_place_add_error").length == 0) {
	//if there is an error we want user to see the error div
	$('#manual_wrap').hide();
    }

    $('#search_no_find').click(function(e) {
	e.preventDefault();
	$('#manual_wrap').toggle('slow')
    });


/*date picka */

    $('#datepicker').datepicker({inline: true, altField: "#event_event_date"});
	//$('#event_event_date').val(selectedDate.asString());
    
//client side voting update

    $(".vote_up").click(function(e) { 

	if (is_event_expired) {
	    return;
	}

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

	if (is_event_expired) {
	    return;
	}

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


function date_countdown(event_date) {
    var currentTime = new Date();
    console.log(event_date.toString() );

    var days = ( (event_date - currentTime) / 1000 / 60 / 60 / 24);
    var hours = ( (event_date - currentTime) / 1000 / 60 / 60 );
    var minutes = ( (event_date - currentTime) / 1000 / 60 );

    //Expiry
    if (event_date - currentTime < 0) {
	$('#votebar').hide();
	$('._header_timeout').html("Voting is complete");

	is_event_expired = true;
	/*set to no action on event expiry*/

	/*
	$('#vote-info-lbl').html("Voting is complete");
	$('#votes_remaining').html("");	
	$('#time_remaining').html("");
*/
    }else {


	$('#time_remaining').countdown({until: event_date, 
			       format: 'dhms', description: '',
			       layout: '{dn} {dl} {hn}:{mnn}:{snn}'
			      });			       
	//onTick: _highlightlast5m( {tickInterval: 1}) });

	
    }

}


function _highlightlast5m(periods) {
    console.log("tick");
    if (periods[4] == 0 && periods[5] <= 10) {
	$('.countdown_row').css('color', 'red');
    }
    
}


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


/*
function search(search_text) {
    var auth = $("meta[name=csrf-token]").attr("content")
    var event_id = $(".event").data("event");

	$.ajax({
	    //type: "POST",
	    type: "GET",
	    url: "/places/search/",
	    dataType: "text",
	    //dataType: "json",
	    data: $.param({authenticity_token: auth, search_text: search_text, event_id: event_id}),
	    error: {

	    },
	    success: function(data, textStatus) {
		//var obj = $.parseJSON(data);
		//console.log(data);		

	    },
	    complete: function(data, xhr) {
		//var obj2 = $.parseJSON(data);
		//console.log(data.responseText);
		$('#search_results').html(data.responseText);

		//hook
		$('.place_add_btn').change( function() {
		    $(this).parent('.add_form').attr("action", "/events/" + $(this).val() + "/places");
		    
		});
		//$('.place_add_button').button();
		

		/*
		$(".add_form").submit(function(e) {	
		    e.preventDefault();
		    //console.log($(this) );
		    //console.log($(this).find("#place_cid").val() );
		    add_place( $(this), $(this).find("#place_cid").val() );
		});		
*/
/*
	    }
	});

}
*/

function add_place(button, place_id) {
    var auth = $("meta[name=csrf-token]").attr("content")
    var event_id = $(".event").data("event");

    $.ajax({
        type: "POST",
        url: "/events/" + event_id + "/places",
        dataType: "text",
        //dataType: "json",
        data: $.param({authenticity_token: auth, place: {cid: place_id} }),
        error: {

        },
        success: function(data, textStatus) {
            //var obj = $.parseJSON(data);
            //console.log(data);

        },
        complete: function(data, xhr) {
            //var obj2 = $.parseJSON(data);
            //console.log(data.responseText);
            //$('#search_results').html(data.responseText);
	    //button.hide();
        }
    });


}
