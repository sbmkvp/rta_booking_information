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
					} else {
						$(center_container).css('background','#d7ffca')
					}
          let center_title = $(`<div class="center-title">${center.name}</div>`)
          let center_availability = $(`<div class="center-availability">${center.availability}</div>`)
          $(center_container).append(center_title)
          $(center_container).append(center_availability)
          $('#main-container').append(center_container)
        }
      })
  })
