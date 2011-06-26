// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


//jQuery active? test


$(document).ready(function() {
    
    $(".vote_up").click(function(e) { 
	e_id = $(".event").attr("id");
	p_id = $(this).parent().attr("id");

	//need sign in check
	$('#' + p_id + ' .vote_count').html(
	    parseInt($('#' + p_id + ' .vote_count').html()  ) + 1 )
	
	vote(e_id, p_id, 1);
	
    })

    $(".vote_down").click(function() { 
	e_id = $(".event").attr("id");
	p_id = $(this).parent().attr("id");

	$('#' + p_id + ' .vote_count').html(
	    parseInt($('#' + p_id + ' .vote_count').html()  ) - 1 )

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
		console.log(obj);		
	    },
	    complete: function(xhr) {

	    }
	});



}