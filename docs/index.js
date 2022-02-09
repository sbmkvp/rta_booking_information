fetch('results.json')
  .then(response => response.json())
  .then(centers_data => { 
    fetch('centers.json')
      .then(response => response.json())
      .then(centers_ids => {

        for(i in centers_data){
          let center = centers_data[i]
          center.name = centers_ids.find(d => d.id == center.location).name
          center.dist_class = centers_ids.find(d => d.id == center.location).dist_class
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
            $(center_container).css('cursor','pointer')
            $(center_container).on('click',()=>{
              $('#modal-title').html(center.name)
              $('#modal-content').html(center.result.ajaxresult.slots.listTimeSlot.filter(a => a.availability).map(a=>a.startTime).join("<br>"))
              $('#modal-background').css('display','block')
              $('#modal').css('display','block')
            })           
          }

          let center_title = $(`<div class="center-title">${center.name}</div>`)
          let center_availability = $(`<div class="center-availability">${center.availability}</div>`)
          $(center_container).append(center_title)
          $(center_container).append(center_availability)

          switch(center.dist_class){
            case('< 50 km'): $('#lt50').append(center_container); break;
            case('50 - 100 km'): $('#50t100').append(center_container); break;
            case('100 - 250 km'): $('#100t250').append(center_container); break;
            case('250 - 500 km'): $('#250t500').append(center_container); break;
            case('> 500 km'): $('#gt500').append(center_container); break;
          }
        }


        $('.sub-container').each((id,element) => 
          $(element).children()
            .sort((a,b)=>{return $(a).text().toUpperCase().localeCompare($(b).text().toUpperCase())})
            .each((a,b)=>{$(element).append(b)}))

      })
  })

fetch('update-time.txt')
  .then(response => response.text())
  .then(update_time => {
    $('#update-time').text(update_time)
  })
