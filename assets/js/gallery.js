var galleryCount = 0;

$(() => {

    /* Gallery Carousel ---------------------- */

    // Process list with gallery class to convert to bootstrap carousel
    $("ul.gallery").each((i, el) => {
        let inner = $( el );
        console.log("Convert to boostrap carousel", el, inner)

        // Create carousel wrapper and convert to inner class
        let galleryId = "gallery_" + ++galleryCount;
        inner.wrap("<div class='carousel'></div>");
        let gallery = inner.parent()
        gallery.addClass(inner.attr("class").split(/\s+/))  // Copy element classes to main carousel
        gallery.attr("data-bs-ride", "carousel")
        gallery.attr("id", galleryId)
        inner.attr("class", "carousel-inner");

        inner.children("li").each((i, el) => {
            $( el ).addClass("carousel-item")
            if (i == 0) $(el).addClass("active")
        })

        // Convert alt of images to titles
        inner.find("img").each((i, el) => {
            let alt = $(el).attr("alt")
            if (alt) {
                $(el).wrap('<div class="img-alt"></div>')
                $(el).parent().attr("data-alt", alt)
            }
        })

        // Append buttons
        gallery.append(`
        <button class="carousel-control-prev" type="button" data-bs-target="#${galleryId}" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#${galleryId}" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
        `);

        // Append thumbnails
        if (gallery.hasClass("gallery-thumbs")) { 
            gallery.append('<div class="carousel-indicators carousel-thumbs" style="position: initial"></div>');
            gallery.find(".carousel-item img").each((i, el) => {
                gallery.find(".carousel-indicators").append(`
                    <button type="button" 
                            data-bs-target="#${ galleryId }" data-bs-slide-to="${i}" 
                            class="${ (i ==0) ? "active" : "" }" aria-current="${ (i ==0) ? true : false }" 
                            aria-label="${ $(el).attr("alt") }" 
                            style="width: 100px; text-indent: 0;">
                        <img class="d-block w-100 shadow-1-strong rounded img-fluid" 
                            src="${ $(el).attr("src") }" 
                            alt="${ $(el).attr("alt") }" title="${ $(el).attr("alt") }"  />
                    </button>            
                `)
            })
        }

        // Trigger carousel
        new bootstrap.Carousel(el);
    })

})
