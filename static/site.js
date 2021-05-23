//(function() {
	let load_post = function(post_id) {
		let post = document.getElementById("reply_post_"+post_id);
		let uuid = post.getElementsByTagName("x-picref")[0].getAttribute("uuid");
		let img = post.getElementsByName("img");
		fetch("/api/v0/files?uuid="+uuid).then(function(req) {
			img.setAttribute("src", req.json())
		})
	}

	document.onload = () => {

	}
//})()
