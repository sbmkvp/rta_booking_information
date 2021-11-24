fetch('results.json')
  .then(response => response.json())
  .then(centers_data => { 
    fetch('centers.json')
      .then(response => response.json())
      .then(centers_ids => {
        for(i in centers_data){
          let center = centers_data[i]
          center.name = centers_ids.find(d => d.id == center.location).name
          center.availability = center.result.ajaxresult.slots.nextAvailableDate
          let center_container = $(`<div class="center-container"></div>`)
          if(center.availability==null){
						center.availability = "🙁"
						$(center_container).css('background','#D77D2222')
					} else {
            let availability = center.availability.split(' ')[0].split('/').reverse().join('-')
            availability = new Date(Date.parse(availability))
            let today = new Date()
            let difference = (availability - today)/86400000
						if(difference < 28) $(center_container).css('background','#DAEDC5')
						if(difference < 21) $(center_container).css('background','#C4E6B1')
						if(difference < 14) $(center_container).css('background','#AADE9E')
						if(difference < 7) $(center_container).css('background','#8BD78B')
					}
          let center_title = $(`<div class="center-title">${center.name}</div>`)
          let center_availability = $(`<div class="center-availability">${center.availability}</div>`)
          $(center_container).append(center_title)
          $(center_container).append(center_availability)
          $('#main-container').append(center_container)
        }
      })
  })

fetch('update-time.txt')
	.then(response => response.text())
	.then(update_time => {
		$('#update-time').text(update_time)
	})
